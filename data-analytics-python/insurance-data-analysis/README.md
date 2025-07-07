# Project 2: Insurance Cost Prediction using Regression Analysis

### Overview
This project involves a comprehensive analysis of a medical insurance dataset to identify the key factors that influence premium charges. The primary objective is to perform Exploratory Data Analysis (EDA) to uncover relationships between policyholder attributes (like age, BMI, and smoking status) and their insurance costs, and then to build a regression model to predict these charges.

### Tools Used
- **Language:** Python 3.x
- **Libraries:**
- **pandas:** For data manipulation and cleaning.
- **NumPy:** For numerical operations.
- **matplotlib & seaborn:** For data visualization.
- **scikit-learn:** For building and evaluating the regression model.

### Key Skills
- Data Cleaning & Preprocessing
- Exploratory Data Analysis (EDA)
- Data Visualization (Scatter Plots, Box Plots, Heatmaps)
- Feature Engineering (One-Hot Encoding)
- Predictive Modeling (Linear Regression)
- Model Evaluation & Interpretation

### Screenshots

#### Key Relationships Discovered
*   **Smoking is the dominant factor for high charges.**
  

*   **Charges increase with age and BMI, especially for smokers.**
  
  

#### Correlation of Features
*   The correlation heatmap confirms that `smoker_yes` has the strongest correlation (0.79) with `charges`.
  

### Key Learnings & Insights
- **Smoker Status:** This is the most significant predictor of insurance costs. Smokers, on average, face dramatically higher premiums than non-smokers, and this gap widens with age and higher BMI.
- **Age & BMI:** Both have a moderate positive correlation with charges. The effect of a high BMI is much more pronounced for smokers.
- **Other Factors:** The number of children, sex, and region have a negligible impact on insurance charges.
- **Business Application:** The analysis provides clear, data-driven evidence for risk assessment. An insurance company can confidently use smoking status, age, and BMI as primary factors for determining premium prices.

### Future Improvements
- **Advanced Models:** Implement more complex regression models like Gradient Boosting or XGBoost and tune their hyperparameters to potentially improve prediction accuracy.
- **Interaction Terms:** Engineer new features that capture the interaction between variables (e.g., `bmi * smoker_status`) to help linear models capture more complex relationships.
- **Log Transformation:** Apply a log transformation to the skewed `charges` target variable to see if it improves model performance by normalizing the distribution.