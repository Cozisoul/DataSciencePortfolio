# Project 3: Exploratory Data Analysis of Mobile App Ratings

### Overview
This project is an exploratory data analysis (EDA) of a mobile app dataset. The goal was to use data visualization to investigate how user ratings are distributed and whether they are influenced by factors like app type (free vs. paid), content rating, and category.

### Tools Used
- **Language:** Python 3.x
- **Libraries:**
- **pandas:** For data loading and manipulation.
- **matplotlib & seaborn:** For creating insightful visualizations.

### Key Skills
- Exploratory Data Analysis (EDA)
- Data Visualization (Box Plots, Bar Charts)
- Statistical Summary and Interpretation
- Data-Driven Insight Generation

### Screenshots

#### Key Visualizations
*   **Ratings are similar for Free vs. Paid apps, but Paid apps have fewer very low ratings.**
  

*   **App ratings are fairly consistent across different content ratings.**
  

*   **Most app categories have a mean rating between 4.0 and 4.4.**
  

### Key Learnings & Insights
- **App Type:** While both Free and Paid apps have a similar median rating of around 4.3, Paid apps appear to have a tighter distribution and fewer extremely low-rated outliers. This suggests a potentially more consistent user experience for apps that require payment.
- **Content Rating:** There is no strong evidence to suggest that an app's content rating (e.g., "Everyone," "Teen," "Mature 17+") significantly impacts its average user rating.
- **Category:** Most app categories perform similarly, with average ratings clustering closely together. "Events" and "Education" apps have the highest mean ratings, while "Dating" apps have the lowest, though the overall variance between categories is small.

### Future Improvements
- **Predictive Modeling:** Build a machine learning model to predict app ratings based on available features.
- **Sentiment Analysis:** If user reviews were available, perform sentiment analysis to extract more nuanced insights than a simple star rating can provide.
- **Analyze Other Features:** Investigate the impact of other variables like the number of installs, last updated date, and app size on user ratings.
