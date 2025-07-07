# 1. Load Libraries
install.packages("openxlsx")

library(tidyverse)
library(readr)
library(ggplot2)
library(corrplot)
library(car)
library(psych)
library(tidyr)
library(xlsx)
library(openxlsx)

# 2. Data Import

data <- read.xlsx("Internet_Dataset.xlsm")

# 3. Data Inspection
str(data)
summary(data)
sapply(data, function(x) sum(is.na(x)))

# 4. Data Cleaning

data_clean <- na.omit(data)

#Convert categorical variables to factors:
data$Continent <- as.factor(data$Continent)
data$Sourcegroup <- as.factor(data$Sourcegroup)

# 5. EDA

# Univariate
data_clean %>% 
  select_if(is.numeric) %>%
  summary()

# Histograms for numeric variables
num_vars <- c("Bounces", "Exits", "Timeinpage", "Uniquepageviews", "Visits", "BouncesNew")

sum(data_clean$BouncesNew == 0) / nrow(data_clean)

for (var in num_vars) {
  if (var == "BouncesNew") {
    # Filter non-zero for BouncesNew
    print(
      ggplot(data_clean[data_clean$BouncesNew > 0, ], aes_string(x = var)) +
        geom_histogram(bins = 30, fill = "orange", color = "black") +
        ggtitle("Histogram of Non-Zero BouncesNew")
    )
  } else {
    # Plot as usual for other variables
    print(
      ggplot(data_clean, aes_string(x = var)) +
        geom_histogram(bins = 30, fill = "skyblue", color = "black") +
        ggtitle(paste("Histogram of", var))
    )
  }
}

# Categorical variables
table(data_clean$Continent)
table(data_clean$`Sourcegroup`)

# Bivariate
pairs(data_clean[num_vars])

# Correlation matrix
corrplot(cor(data_clean[num_vars]), method="circle")

# 6. Analysis

# Q1: Does unique page view on visits?
model_upv_visits <- lm(`Uniquepageviews` ~ Visits, data=data_clean)
summary(model_upv_visits)
plot(data_clean$Visits, data_clean$`Uniquepageviews`,
     xlab = "Visits", ylab = "Unique Page Views",
     main = "Scatterplot: Visits vs Unique Page Views")
abline(model_upv_visits, col = "red")

ggplot(data_clean, aes(x = Visits, y = Uniquepageviews)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Visits vs Unique Page Views",
       x = "Visits", y = "Unique Page Views")

 # Q2: Factors affecting Exits
 model_exits <- lm(Exits ~ ., data = data_clean %>% select(-Bounces, -`Uniquepageviews`))
 summary(model_exits)

 # Q3: Factors affecting Time on Page
 model_timeonpage <- lm(`Timeinpage` ~ ., data = data_clean %>% select(-Bounces, -Exits))
 summary(model_timeonpage)

 #Q4: Factors impacting Bounces
 model_bounces <- lm(Bounces ~ ., data = data_clean %>% select(-Exits, -`Uniquepageviews`))
 summary(model_bounces)

# 7. Diagnostics
par(mfrow=c(2,2))
plot(model_exits)
plot(model_timeonpage)
plot(model_bounces)

# For model_exits:
plot(model_exits, which = 1) # Residuals vs Fitted
plot(model_exits, which = 2) # Normal Q-Q
plot(model_exits, which = 3) # Scale-Location
plot(model_exits, which  = 4) # Residuals vs Leverage


# . Visualizations for Key Findings
# Example: Boxplot of Time on Page by Source Group
ggplot(data_clean, aes(x=`Sourcegroup`, y=`Timeinpage`)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle=45, hjust=1))

# 9. Save Results
write.csv(summary(model_exits)$coefficients, "exits_model_summary.csv")
write.csv(summary(model_timeonpage)$coefficients, "timeonpage_model_summary.csv")
write.csv(summary(model_bounces)$coefficients, "bounces_model_summary.csv")

# End of Script

