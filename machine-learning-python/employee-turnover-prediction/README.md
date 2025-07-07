# Employee Turnover Prediction (Classification & Clustering)

## Overview
This project analyzed HR data to predict employee turnover using a combination of EDA, clustering to identify employee personas, and classification models to predict attrition risk.

## Tools Used
- Python (Pandas, NumPy, Matplotlib, Seaborn)
- scikit-learn (KMeans, train_test_split, StandardScaler, classification_report, roc_auc_score)
- imblearn (SMOTE)

## Skills Demonstrated
✅ **Data Quality & EDA:** Used heatmaps and distribution plots to uncover drivers of turnover.  
✅ **Clustering:** Applied K-Means to segment departing employees, revealing patterns like "Frustrated High-Performers."  
✅ **Handling Imbalance:** Used SMOTE to balance the dataset for better model accuracy.  
✅ **Classification:** Compared Logistic Regression, Random Forest, and Gradient Boosting, prioritizing Recall and AUC to minimize missed high-risk employees.  
✅ **Recommendations:** Translated outputs into actionable HR strategies.

## Key Learnings
- Combining clustering and classification for deeper insights.
- Choosing evaluation metrics aligned with business goals (Recall over Precision).
- Building deployable models that provide strategic HR insights.

## Screenshots
Visual outputs (ROC curves, confusion matrices, cluster plots) are in the `visuals/` folder.