#=======================================================
# Analysis of Sales Report of a Clothes Manufacturing Outlet
#=======================================================



#Packages Import and Load

install.packages(c("tidyverse", "lubridate", "caret", "randomForest", "corrplot", "ggpubr", "readxl", "forcats"))
install.packages("scales")

library(tidyr)
library(lubridate)
library(caret)
library(randomForest)
library(corrplot)
library(forcats)
library(ggpubr)
library(ggplot2)
library(readxl)
library(dplyr)
library(scales)


#=================================
#Data Understanding & Preprocessing
#==================================

#Read the data:
df1 <- read_xlsx("Attribute DataSet.xlsx")
df2 <- read_xlsx("Dress Sales.xlsx")

#Explore structure, summary, missing values:
str(df1)
summary(df1)
sapply(df1, function(x) sum(is.na(x)))

# Check in1
sum(duplicated(df1$Dress_ID))

# See which IDs are duplicated
df1 %>% filter(duplicated(Dress_ID) | duplicated(Dress_ID, fromLast = TRUE))

str(df2)
summary(df2)
sapply(df2, function(x) sum(is.na(x)))

# Check in df2
sum(duplicated(df2$Dress_ID))
df2 %>% filter(duplicated(Dress_ID) | duplicated(Dress_ID, fromLast = TRUE))


#Merge datasets if needed (by Dress_ID):

sales_cols <- setdiff(names(df2), "Dress_ID")

# Convert all sales columns to numeric
df2[sales_cols] <- lapply(df2[sales_cols], function(x) as.numeric(as.character(x)))

# Aggregate sales in df2
df2_agg <- df2 %>%
  group_by(Dress_ID) %>%
  summarise(across(all_of(sales_cols), sum, na.rm = TRUE))

# Keep first occurrence in df1
df1_unique <- df1 %>% distinct(Dress_ID, .keep_all = TRUE)

# Join
Retail <- left_join(df1_unique, df2_agg, by = "Dress_ID")

#=====================
# Clean Attribute Data
#=====================

# Convert relevant columns to factors
Retail$Rating <- factor(Retail$Rating, ordered = TRUE) # Ordinal

# Define categorical columns
cat_cols <- c("Style", "Price", "Size", "Season", "NeckLine", 
              "SleeveLength", "Material", "FabricType", "Decoration", "Pattern Type")

# Convert columns to factors
Retail <- Retail %>%
mutate(across(all_of(cat_cols), as.factor),
       Recommendation = as.factor(Recommendation))

# Check the structure of the cleaned data frame
str(Retail)

# Fix typos in levels
Retail$Season <- fct_recode(Retail$Season, Autumn = "Automn")



#Factor recode
Retail$Season <- fct_recode(Retail$Season,
                            
                            Spring = "spring",  
                            
                            Spring = "Spring")  
Retail$Season <- fct_recode(Retail$Season,
                            
                            Winter = "winter",  
                            
                            Winter = "Winter")  
Retail$Price <- fct_recode(Retail$Price,
                           
                           High = "high",  
                           
                           High = "High")  
Retail$Price <- fct_recode(Retail$Price,
                           
                           Low = "low",  
                           
                           Low = "Low")

#============================================
# Feature Engineering: Total Sales per Dress
#============================================

# List of attribute columns
attribute_cols <- c("Dress_ID", "Style", "Price", "Rating", "Size", "Season",
                    "NeckLine", "SleeveLength", "waiseline", "Material",
                    "FabricType", "Decoration", "Pattern Type", "Recommendation")

# All other columns are sales
sales_cols <- setdiff(names(Retail), attribute_cols)

Retail[sales_cols] <- lapply(Retail[sales_cols], function(x) as.numeric(as.character(x)))

str(Retail)

#Calculate Total Sales per Dress
Retail$Total_Sales <- rowSums(Retail[sales_cols], na.rm = TRUE)

#================================
# Explatory Data Analysis (EDA)
#================================

#Summarize and Visualize Key Attributes

#Distribution of Styles
ggplot(Retail, aes(x = Style)) + geom_bar() + theme(axis.text.x = element_text(angle=45, hjust=1))

#Distribution of Price:
  ggplot(Retail, aes(x = Price)) + geom_bar()
  
#Ratings Distribution:
  ggplot(Retail, aes(x = as.numeric(as.character(Rating)))) +
    geom_histogram(binwidth = 0.2)
  
# Distribution of Season
ggplot(Retail, aes(x = Season)) + 
    geom_bar()

# Correlation Matrix
num_vars <- Retail %>% select(where(is.numeric))
corrplot::corrplot(cor(num_vars, use = "complete.obs"), method = "color")

# ===========================
# Task 1 - Recommendation Prediction Model
# ===========================

# Prepare Data

# Exclude sales columns and Dress_ID from predictors
predictors <- c(cat_cols, "Rating")
Retail_model <- Retail %>% select(all_of(predictors), Recommendation) %>% drop_na()

set.seed(123)
trainIndex <- createDataPartition (Retail_model$Recommendation, p = .8, list = FALSE)
train <- Retail_model[trainIndex, ]
test <- Retail_model[-trainIndex, ]

train <- train %>% rename(PatternType = `Pattern Type`)
test  <- test %>% rename(PatternType = `Pattern Type`)

#Train Random Forest Classifier
model_rf <- randomForest(Recommendation ~ ., data = train)
pred_rf <- predict(model_rf, newdata = test)
confusionMatrix(pred_rf, test$Recommendation)

library(pROC)
rf_probs <- predict(model_rf, newdata = test, type = "prob")[,2]
roc_obj <- roc(as.numeric(test$Recommendation), rf_probs)
plot(roc_obj)
auc(roc_obj)

# ===========================
# Task 2: Sales Trend Prediction (Time Series Forecasting)
# ===========================

one_dress_sales <- Retail %>% filter(Dress_ID == Retail$Dress_ID[1]) %>% select(all_of(sales_cols))
ts_sales <- ts(as.numeric(one_dress_sales[1, ]), frequency = 1)
fit_arima_manual <- arima(ts_sales, order=c(1,0,0))
forecasted_manual <- predict(fit_arima_manual, n.ahead=3)

plot(ts_sales, xlim=c(1, length(ts_sales)+3), ylim=range(c(ts_sales, forecasted_manual$pred)), type="l", main="Manual ARIMA Forecast")
lines((length(ts_sales)+1):(length(ts_sales)+3), forecasted_manual$pred, col="red", type="o")

plot(ts_sales, xlim=c(1, length(ts_sales)+3), ylim=range(c(ts_sales, forecasted_manual$pred)), type="l", main="Manual ARIMA Forecast", ylab="Sales", xlab="Time")

# ===========================
#Task 3: Influence of Style, Season, Material, Price on Sales
# ===========================


#ANOVA
summary(aov(Total_Sales ~ Style, data = Retail))
summary(aov(Total_Sales ~ Price, data = Retail))
summary(aov(Total_Sales ~ Season, data = Retail))
summary(aov(Total_Sales ~ Material, data = Retail))

#Multiple Regression
lm_model <- lm(Total_Sales ~ Style + Price + Season + Material, data = Retail)
summary(lm_model)

# ===========================
#Task 4: Leading Factors Affecting Sales
# ===========================

Retail <- Retail %>% rename(PatternType = `Pattern Type`)

rf_data <- Retail %>%
  select(Total_Sales, Style, Price, Size, Season, NeckLine, SleeveLength, waiseline,
         Material, FabricType, Decoration, PatternType, Rating) %>%
  na.omit()


#Variable Importance via Random Forest
rf_sales <- randomForest(Total_Sales ~ ., data = rf_data)
varImpPlot(rf_sales)
importance(rf_sales)
plot (varImpPlot(rf_sales))

# ===========================
#Task 5: Does Rating Affect Sales?
# ===========================

  ggplot(Retail, aes(x = as.numeric(Rating), y = Total_Sales)) + 
  geom_point() + 
  geom_smooth(method = "lm")

cor(as.numeric(Retail$Rating), Retail$Total_Sales, use = "complete.obs")
summary(lm(Total_Sales ~ Rating, data = Retail))

# ===========================
# Reporting in PDF
# ===========================

