# Directory set up 
getwd()
setwd("C:/Users/ThapeloMasebe/OneDrive - Ogilvy/Documents/R p")

#1. Load Libraries
install.packages("tidyverse")      # Includes ggplot2, dplyr, readr, tibble, etc.
install.packages("data.table")     # Fast data manipulation (optional but handy)
install.packages("car")            # For VIF and diagnostics
install.packages("corrplot")       # Correlation plots
install.packages("GGally")         # For ggpairs (pairwise plotsinstall.packages("broom")          # Tidy model summaries
install.packages("janitor")        # Clean column names and tabulation
install.packages("readr")          # Robust CSV reading

# Load libraries (put at top of script)

library(tidyverse)   
library(data.table)
library(car)
library(corrplot)
library(GGally)
library(broom)
library(janitor)
library(readr)

#2. Data Import

data <- read_csv("Insurance_factor_identification.csv")
 str(data)

#3. Data Cleaning  
 
  data <- data %>%
  mutate(
    Kilometres = as.factor(Kilometres),
    Zone       = as.factor(Zone),
    Bonus      = as.factor(Bonus),
    Make       = as.factor(Make)
  )
  str(data) 
 
#4. EDA
  
  summary(data)
  sapply(data, function(x) sum(is.na(x)))
  glimpse(data) 

# Histograms for Numeric Variablesnum_vars <- c("Insured", "Claims", "Payment")
  
for (var in num_vars) {
  print(
    ggplot(data, aes(x = .data[[var]])) +
      geom_histogram(bins = 30, fill = "skyblue") +
      ggtitle(paste("Histogram of", var)) +
      xlab(var)
  )
}

# Barplots for categorical vars

  cat_vars <- c("Kilometres", "Zone", "Bonus", "Make")
  for (var in cat_vars) {
    print(
      ggplot(data, aes_string(x = var)) +
        geom_bar(fill = "orange") +
        geom_text(stat='count', aes(label=..count..), vjust=-0.5, size=5) +
        labs(title = paste("Barplot of", var), x = var, y = "Count") +
        theme_minimal(base_size = 14 ) +
        theme(axis.text.x = element_text(angle = 0, vjust = 0.5, size = 14),
              plot.title = element_text(size = 18, face = "bold"))
    )
  }    

# Bivariate Relationships
  
# Scatterplots for Numeric Relationships

  ggplot(data, aes(x = Claims, y = Payment)) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(title = "Payment vs Claims")
  
  ggplot(data, aes(x = Insured, y = Payment)) +
    geom_point(alpha = 0.4) +
    geom_smooth(method = "lm", se = FALSE, color = "red") +
    labs(title = "Payment vs Insured")

# Correlation Matrix

  library(corrplot)
  cor_matrix <- cor(data %>% select(Insured, Claims, Payment))
  print(cor_matrix)
  corrplot(cor_matrix, method = "circle")

# Boxplots by Category
  
  ggplot(data, aes(x = Zone, y = Payment)) +
  geom_boxplot() +
    scale_y_log10() +
  labs(title = "Payment by Zone")
  
  ggplot(data, aes(x = Kilometres, y = Payment)) +
    geom_boxplot() +
    scale_y_log10() +
    labs(title = "Payment by Kilometres (Log Scale)")
  
  ggplot(data, aes(x = Bonus, y = Payment)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(title = "Payment by Bonus")

  ggplot(data, aes(x = Make, y = Payment)) +
  geom_boxplot() +
  scale_y_log10() +
  labs(title = "Payment by Make")

#Claim Rate Calculation & Histogram
      
  data <- data %>%
    mutate(ClaimRate = Claims / Insured)

  hist(data$ClaimRate, breaks = 30, main = "Histogram of Claim Rate", xlab = "Claim Rate")
  summary(data$ClaimRate)  
  
#5. Correlation and Relationships
  cor(data %>% select(Insured, Claims, Payment))
  pairs(data %>% select(Insured, Claims, Payment))

#6. Regression: Payment ~ Claims + Insured
  model_simple <- lm(Payment ~ Claims + Insured, data=data)
  summary(model_simple)
  ggplot(data, aes(x=Claims, y=Payment)) + geom_point() + geom_smooth(method="lm")

#7. Full Model: Payment ~ All Predictors
  model_pay_full <- lm(Payment ~ Kilometres + Zone + Bonus + Make + Insured + Claims, data=data)
  summary(model_pay_full)
  
  car::vif(model_pay_full)

#8.  Aggregated Analysis
  
  agg <- data %>%
    group_by(Zone, Kilometres, Bonus) %>%
    summarise(Total_Insured = sum(Insured), Total_Claims = sum(Claims), Total_Payment = sum(Payment))
  print(agg)

#9. Claim Rate Analysis
  
  data$ClaimRate <- data$Claims / data$Insured
  model_claimrate <- lm(ClaimRate ~ Insured + Zone + Kilometres + Bonus + Make, data=data)
  summary(model_claimrate)

  ggplot(data, aes(x = ClaimRate)) +
  geom_histogram(bins = 30, fill = "purple", color = "black")  
  labs(title = "Distribution of Claim Rate", x = "Claim Rate (Claims / Insured)", y = "Count")

#10. Visualizations for Key Findings

# Simple model: Payment ~ Claims + Insured

model_simple <- lm(Payment ~ Claims + Insured, data=data)
summary(model_simple)

# Full model: Payment ~ All Predictors

model_pay_full <- lm(Payment ~ Kilometres + Zone + Bonus + Make + Insured + Claims, data=data)
summary(model_pay_full)
car::vif(model_pay_full)

# Model for Claim Rate
model_claimrate <- lm(ClaimRate ~ Insured + Zone + Kilometres + Bonus + Make, data=data)
summary(model_claimrate)

ggplot(data, aes(x = Payment)) +
  geom_histogram(bins = 30, fill = "skyblue", color = "black") +
  scale_x_log10() +
  labs(title = "Distribution of Payments (Log Scale)", x = "Payment (log10 SEK)", y = "Count")

ggplot(data, aes(x = Bonus)) +
  geom_bar(fill = "orange") +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5, size=4) +
  labs(title = "Policy Counts by Bonus Class", x = "Bonus Class", y = " of Policies") +
  theme_minimal(base_size = 14)

   (data, aes(x = Zone, y = Payment)) +
    geom_boxplot() +
    scale_y_log10() +
    labs(title = "Payment by Zone (Log Scale)", x = "Zone", y = "Payment (log10 SEK)")

  

# 11. Save Results
write.csv(agg, "insurance_aggregates.csv")
