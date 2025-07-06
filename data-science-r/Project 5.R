setwd("C:/Users/ThapeloMasebe/OneDrive - Ogilvy/Documents/R p")

# 1. Load Libraries
install.packages("caret")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("svm")
install.packages("e1071")   

library(e1071)
library(svm)
library(rpart)
library(rpart.plot)
library(rpart)
library(caret)
library(tidyverse)
library(caret)
library(e1071)
library(rpart)
library(part.plot)


# 2. Data Import
data <- read_csv("College_admission.csv")

str(data)

# 3. Data Cleaning
data <- data %>%
  mutate(
    admit = as.factor(admit),
    ses = as.factor(ses),
    Gender_Male = as.factor(Gender_Male),
    Race = as.factor(Race),
    rank = as.factor(rank)
  )

summary(data)
sapply(data, function(x) sum(is.na(x)))

# 4. Descriptive Analysis

# GPA Categorization
data <- data %>%
  mutate(GPA_cat = case_when(
    gpa < 3 ~ "Low",
    gpa >= 3 & gpa < 3.7 ~ "Medium",
    gpa >= 3.7 ~ "High"
  ))

# Admission rate by GPA_cat
gpa_admit <- data %>%
  group_by(GPA_cat) %>%
  summarise(Admit_Rate = mean(as.numeric(as.character(admit))))
ggplot(gpa_admit, aes(x = GPA_cat, y = Admit_Rate)) +
  geom_point(size = 4) +   # Or any other positive number
  labs(title = "Admission Rate by GPA Category", x = "GPA Category", y = "Admission Rate")

# GRE Categorization
data <- data %>%
  mutate(GRE_cat = case_when(
    gre <= 440 ~ "Low",
    gre > 440 & gre <= 580 ~ "Medium",
    gre > 580 ~ "High"
  ))

# Cross-tab GRE_cat vs admit
table(data$GRE_cat, data$admit)
ggplot(data, aes(x = GRE_cat, fill = admit)) +
  geom_bar(position = "fill") +
  labs(title = "Admission Proportion by GRE Category", x = "GRE Category", y = "Proportion")

#5. Logistic Regression
logit_model <- glm(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, family = binomial)
summary(logit_model)

# Drop insignificant variables, refit if needed

# Predict and calculate accuracy
pred_logit <- predict(logit_model, type = "response")
pred_class <- ifelse(pred_logit > 0.5, 1, 0)
confusionMatrix(as.factor(pred_class), data$admit)

# 6. Decision Tree
tree_model <- rpart(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, method = "class")
rpart.plot(tree_model)
pred_tree <- predict(tree_model, type = "class")
confusionMatrix(pred_tree, data$admit)

# 7. SVM
svm_model <- svm(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, probability = TRUE)
pred_svm <- predict(svm_model, data)
confusionMatrix(as.factor(pred_svm), as.factor(data$admit))

# 8. Model Comparison
# Collect and compare accuracy from all three models

# Logistic Regression
logit_model <- glm(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, family = binomial)
pred_logit <- predict(logit_model, type = "response")
pred_class_logit <- ifelse(pred_logit > 0.5, 1, 0)
cm_logit <- caret::confusionMatrix(as.factor(pred_class_logit), data$admit)

# Decision Tree
library(rpart)
tree_model <- rpart(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, method = "class")
pred_tree <- predict(tree_model, type = "class")
cm_tree <- confusionMatrix(pred_tree, data$admit)

# SVM
library(e1071)
svm_model <- svm(admit ~ gre + gpa + ses + Gender_Male + Race + rank, data = data, probability = TRUE)
pred_svm <- predict(svm_model, data)
cm_svm <- caret::confusionMatrix(as.factor(pred_svm), as.factor(data$admit))

# Create summary table
model_names <- c("Logistic Regression", "Decision Tree", "SVM")
accuracy <- c(cm_logit$overall["Accuracy"], cm_tree$overall["Accuracy"], cm_svm$overall["Accuracy"])
sensitivity <- c(cm_logit$byClass["Sensitivity"], cm_tree$byClass["Sensitivity"], cm_svm$byClass["Sensitivity"])
specificity <- c(cm_logit$byClass["Specificity"], cm_tree$byClass["Specificity"], cm_svm$byClass["Specificity"])
kappa <- c(cm_logit$overall["Kappa"], cm_tree$overall["Kappa"], cm_svm$overall["Kappa"])

results_table <- data.frame(
  Model = model_names,
  Accuracy = round(accuracy, 3),
  Sensitivity = round(sensitivity, 3),
  Specificity = round(specificity, 3),
  Kappa = round(kappa, 3)
)

print(results_table)


# 9. Save Results (optional)
write.csv(data, "admission_data_cleaned.csv")

