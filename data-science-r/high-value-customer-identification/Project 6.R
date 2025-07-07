# -------------------------------------------------------
# Project: E-Commerce Customer Segmentation
# -------------------------------------------------------

getwd()

# -------------------------------------------------------
# 1. Load Libraries
# -------------------------------------------------------

install.packages("factoextra")
install.packages("NbClust")

library(tidyverse)
library(lubridate)
library(cluster)
library(factoextra)
library(NbClust)

# -------------------------------------------------------
# 2. Data Import
# -------------------------------------------------------


data <- read_csv("Ecommerce.csv")

str(data)

# -------------------------------------------------------
# 3. Data Cleaning
# -------------------------------------------------------

# Check for and remove rows with missing CustomerID
data <- data %>% filter(!is.na(CustomerID))

# Remove rows with invalid quantities or prices
data <- data %>% filter(Quantity > 0, UnitPrice > 0)

# Convert InvoiceDate to datetime format
data$InvoiceDate <- parse_date_time(data$InvoiceDate, orders = c("d-b-y", "d/m/y", "d-m-y"))

# Remove the extra column (...9) if it exists
if ("...9" %in% names(data)) {
  data <- data %>% select(-"...9")
}

str(data)


# -------------------------------------------------------
# 4. RFM Feature Engineering
# -------------------------------------------------------

# Define snapshot date (last date in dataset)
snapshot_date <- max(data$InvoiceDate)

# Calculate RFM features
rfm <- data %>%
  group_by(CustomerID) %>%
  summarise(
    Recency = as.numeric(snapshot_date - max(InvoiceDate)),
    Frequency = n_distinct(InvoiceNo),
    MonetaryValue = sum(Quantity * UnitPrice),
    .groups = "drop"
  )

# -------------------------------------------------------
# 4. Log Transformation
# -------------------------------------------------------

rfm <- rfm %>%
  mutate(
    log_Frequency = log1p(Frequency),
    log_MonetaryValue = log1p(MonetaryValue)
  )

# -------------------------------------------------------
# 5. Data Scaling
# -------------------------------------------------------

rfm_scaled <- scale(rfm[, c("Recency", "log_Frequency", "log_MonetaryValue")])

# Summary statistics for RFM features
summary(rfm)

# Histograms for RFM features (log scale)
hist(rfm$Recency, main = "Histogram of Recency", xlab = "Recency")
hist(rfm$log_Frequency, main = "Histogram of Log(Frequency)", xlab = "Log(Frequency)")
hist(rfm$log_MonetaryValue, main = "Histogram of Log(Monetary Value)", xlab = "Log(Monetary Value)")

# Scatterplot (Recency vs Log(Monetary Value))
ggplot(rfm, aes(x = Recency, y = log_MonetaryValue)) +
  geom_point(alpha = 0.3, position = "jitter") +
  labs(title = "Recency vs Log(Monetary Value)", x = "Recency", y = "Log(Monetary Value)")


# -------------------------------------------------------
# 7. K-Means Clustering
# -------------------------------------------------------

# Determine optimal K using Elbow method
fviz_nbclust(rfm_scaled, kmeans, method = "wss") +
  labs(subtitle = "Elbow method for K-Means")

# Determine optimal K using Silhouette method
fviz_nbclust(rfm_scaled, kmeans, method = "silhouette") +
  labs(subtitle = "Silhouette method for K-Means")

# Choose K based on the above methods (example: K = 3)
k <- 3

# Run K-Means clustering
kmeans_model <- kmeans(rfm_scaled, centers = k, nstart = 25)

# Visualize K-Means clusters
fviz_cluster(kmeans_model, data = rfm_scaled, geom = "point", ellipse.type = "convex")

# -------------------------------------------------------
# 8. Hierarchical Clustering
# -------------------------------------------------------

# Calculate distance matrix
distance <- dist(rfm_scaled, method = "euclidean")

# Perform hierarchical clustering
hc <- hclust(distance, method = "ward.D2")

# Plot dendrogram
plot(hc, cex = 0.6, hang = -1)
rect.hclust(hc, k = k, border = 2:5)

# Cut the dendrogram to create clusters
cluster_hc <- cutree(hc, k = k)

# -------------------------------------------------------
# 9. Cluster Profiling
# -------------------------------------------------------

# Add cluster assignments to RFM data
rfm$KMeans_Cluster <- as.factor(kmeans_model$cluster)
rfm$HC_Cluster <- as.factor(cluster_hc)

# Profile clusters (K-Means)
kmeans_summary <- rfm %>%
  group_by(KMeans_Cluster) %>%
  summarise(across(c(Recency, log_Frequency, log_MonetaryValue), mean), .groups = "drop")
print("K-Means Cluster Profiles:")
print(kmeans_summary)

# Profile clusters (Hierarchical)
hc_summary <- rfm %>%
  group_by(HC_Cluster) %>%
  summarise(across(c(Recency, log_Frequency, log_MonetaryValue), mean), .groups = "drop")
print("Hierarchical Cluster Profiles:")
print(hc_summary)

# -------------------------------------------------------
# Re-clustering
# -------------------------------------------------------

# Find the size of each cluster
cluster_sizes <- table(rfm$KMeans_Cluster)
largest_cluster <- names(cluster_sizes[which.max(cluster_sizes)])

# Filter data for the largest cluster
largest_cluster_data <- rfm_scaled[rfm$KMeans_Cluster == largest_cluster, ]

# Re-cluster the largest cluster into 2 sub-clusters
kmeans_reclustered <- kmeans(largest_cluster_data, centers = 2, nstart = 25)

# Add sub-cluster assignments to the original data
rfm$Reclustered <- ifelse(rfm$KMeans_Cluster == largest_cluster, paste0(largest_cluster, "_", kmeans_reclustered$cluster), as.character(rfm$KMeans_Cluster))

#Profiling the Re-Clustered Segments:
  reclustered_summary <- rfm %>%
  group_by(Reclustered) %>%
  summarise(across(c(Recency, log_Frequency, log_MonetaryValue), mean), .groups = "drop")
print("Re-Clustered Profiles:")
print(reclustered_summary)

# -------------------------------------------------------
# 11. Save Results
# -------------------------------------------------------

write.csv(rfm, "customer_segments.csv", row.names = FALSE)

# -------------------------------------------------------
# End of Script
# -------------------------------------------------------