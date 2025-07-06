# -------------------------------------------------------
# Project: Healthcare Cost and Utilization Analysis
# -------------------------------------------------------

# -------------------------------------------------------
# 1. Load Libraries
# -------------------------------------------------------
library(tidyverse)
library(readxl)
library(car)
library(lubridate)

# -------------------------------------------------------
# 2. Data Import & Cleaning
# -------------------------------------------------------

#Data Read

  data <- read_xlsx("HospitalCosts.xlsx", sheet = "HospitalCosts")

# Convert categorical variables to factors
  
  data$FEMALE <- as.factor(data$FEMALE)
  data$RACE <- as.factor(data$RACE)
  data$APRDRG <- as.factor(data$APRDRG)

# Check for missing values
  
  sapply(data, function(x) sum(is.na(x)))
  
  data <- data %>% filter(!is.na(RACE))

# Check for outliers/invalid values (example)
  
  summary(data$AGE)
  summary(data$LOS)
  summary(data$TOTCHG)

# -------------------------------------------------------
# 3. Descriptive Analysis
# -------------------------------------------------------

# Age and Expenditure
  
  age_exp_sorted <- age_exp %>%
    arrange(desc(Mean_Cost))
  
  print(age_exp_sorted)

# Most frequent age category
  
  age_freq <- data %>%
    group_by(AGE) %>%
    summarise(Count = n(), .groups = "drop")
  print(age_freq)

# APRDRG and Expenditure
  
  aprdrg_summary <- data %>%
    group_by(APRDRG) %>%
    summarise(
      Count = n(),
      Mean_Cost = mean(TOTCHG),
      .groups = "drop"
    ) %>%
    arrange(desc(Count), desc(Mean_Cost))
  
  print(head(aprdrg_summary))

# Race and Costs
  
  model_race <- lm(TOTCHG ~ RACE, data = data)
  anova(model_race)

# Age, Gender, and Costs
  
  age_gender_exp <- data %>%
    group_by(AGE, FEMALE) %>%
    summarise(Mean_Cost = mean(TOTCHG), .groups = "drop")
  print(age_gender_exp)

# LOS Prediction
  
  model_los <- lm(LOS ~ AGE + FEMALE + RACE, data = data)
  summary(model_los)

# Variable Importance
  
  model_full <- lm(TOTCHG ~ AGE + FEMALE + LOS + RACE + APRDRG, data = data)
  summary(model_full)
  
# -------------------------------------------------------
# 4. Visualizations
# -------------------------------------------------------

# Distribution of Hospital Costs  (Log Scale)
  
  ggplot(data, aes(x = TOTCHG)) +
    geom_histogram(bins = 30, fill = "skyblue", color = "black") +
    scale_x_log10() +
    labs(title = "Distribution of Hospital Costs (Log Scale)", x = "Total Charges (Log10)", y = "Count")
  
  
# Relationship Between Length of Stay and Hospital Costs  (Log Scale and Jitter)
  
  ggplot(data, aes(x = LOS, y = TOTCHG)) +
    geom_point(alpha = 0.3, position = "jitter") +
    scale_y_log10() +
    labs(title = "Relationship Between Length of Stay and Hospital Costs (Log Scale)", x = "Length of Stay (LOS)", y = "Total Charges (Log10)")
  
# Mean Hospital Costs by Race
  
  race_exp <- data %>%
    group_by(RACE) %>%
    summarise(Mean_Cost = mean(TOTCHG), .groups = "drop")
  
  ggplot(race_exp, aes(x = RACE, y = Mean_Cost)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = "Mean Hospital Costs by Race", x = "Race", y = "Mean Total Charges")
  
# Mean Hospital Costs by Age
  
  ggplot(age_exp, aes(x = AGE, y = Mean_Cost)) +
    geom_line() +
    labs(title = "Mean Hospital Costs by Age", x = "Age", y = "Mean Total Charges")
  
#Mean Hospital Costs by Age (Boxplots)
  
  ggplot(data, aes(x = AGE, y = TOTCHG)) +
    geom_boxplot() +
    scale_y_log10() +
    labs(title = "Hospital Costs by Age (Boxplot, Log Scale)", x = "Age", y = "Total Charges (Log10)")  
  
# Mean Hospital Costs by Gender (with Error Bars)
  
  gender_summary <- data %>%
    group_by(FEMALE) %>%
    summarise(
      Mean_Cost = mean(TOTCHG),
      SE = sd(TOTCHG) / sqrt(n()),  # Standard Error
      .groups = "drop"
    )
  
  ggplot(gender_summary, aes(x = FEMALE, y = Mean_Cost)) +
    geom_bar(stat = "identity", fill = "purple") +
    geom_errorbar(aes(ymin = Mean_Cost - SE, ymax = Mean_Cost + SE), width = 0.2) +
    labs(title = "Mean Hospital Costs by Gender", x = "Gender (0=Male, 1=Female)", y = "Mean Total Charges")
  
# -------------------------------------------------------
# 5. Save Results
# -------------------------------------------------------
write.csv(age_exp, "age_expenditure.csv", row.names = FALSE)
  