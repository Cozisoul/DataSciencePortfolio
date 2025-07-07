# Song Cohort Creation using Unsupervised Learning

## Overview

This project demonstrates the use of unsupervised machine learning to create distinct cohorts of songs from The Rolling Stones' Spotify catalog. By analyzing the intrinsic audio features of each track, this project segments the entire discography into meaningful groups. The resulting cohorts can be used to power intelligent recommendation engines, create thematic playlists, and provide deeper insights into the artist's musical style.

## Tools Used

* Python (Pandas, NumPy, Matplotlib, Seaborn)
* Scikit-learn (StandardScaler, KMeans, PCA)

## Skills Demonstrated

✅ **Data Preprocessing & Cleaning**: Loaded and cleaned a real-world dataset from Spotify's API.
✅ **Exploratory Data Analysis (EDA)**: Utilized visualizations to identify key patterns in audio features and their correlation with song popularity.
✅ **Unsupervised Learning (Clustering)**: Applied the K-Means algorithm to group songs, using the Elbow Method to determine the optimal number of clusters.
✅ **Dimensionality Reduction**: Used Principal Component Analysis (PCA) to visualize the high-dimensional song data in a 2D space, confirming the distinctness of the created cohorts.
✅ **Data Interpretation**: Analyzed the characteristics of each cluster to define and label them (e.g., "Studio Rock Anthems," "Live Performances," "Acoustic & Mellow Tracks").

## Key Learnings

* A practical application of K-Means clustering to solve a real-world business problem in the music industry.
* The importance of feature scaling and dimensionality reduction as preparatory steps for effective clustering.
* How to translate the mathematical output of a clustering algorithm into qualitative, human-understandable insights and personas.

## Visualizations

*Visualizations for this project (e.g., elbow plot, PCA cluster plot) are placed in the `visuals/` folder.*