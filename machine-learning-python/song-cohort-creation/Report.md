# Final Report: Song Cohort Analysis for The Rolling Stones

**Date:** July 8, 2025  
**Subject:** Creation of Data-Driven Song Cohorts to Enhance User Recommendations

### 1. Executive Summary
The Data Science team has completed a cluster analysis of the entire Rolling Stones catalog available on Spotify. Using unsupervised machine learning, we have successfully segmented their discography into **four distinct, data-driven song cohorts**. These cohorts group songs based on their intrinsic audio characteristics, moving beyond simple genre labels to capture the true sonic signature of each track.

The identified cohorts are:
1.  **The Studio Rock Anthems:** Classic, high-energy studio recordings.
2.  **The Live Performances:** All live tracks, isolated by their unique audio properties.
3.  **The Instrumental Jams:** Powerful instrumental and minimal-vocal tracks.
4.  **The Acoustic & Mellow Tracks:** Ballads and softer, acoustic-driven songs.

The creation of these cohorts provides a powerful new tool for enhancing user engagement. We recommend integrating this cohort data into the recommendation engine to power thematic playlists, improve radio station generation, and create more nuanced "Fans Also Like" suggestions.

### 2. Project Objective
The goal of this project was to apply unsupervised learning techniques to the audio feature data of The Rolling Stones' songs. The objective was to move beyond manual playlisting and create scientifically-derived song groupings that could form the basis of a more sophisticated and personalized recommendation system.

### 3. Methodology
A multi-step machine learning workflow was employed:
1.  **Data Ingestion:** A dataset containing all Rolling Stones songs and their associated Spotify audio features (e.g., `danceability`, `energy`, `acousticness`) was used.
2.  **Feature Scaling:** All audio features were scaled using a `StandardScaler` to ensure that no single feature (like `tempo`) disproportionately influenced the clustering algorithm.
3.  **Optimal Cluster Identification:** The **Elbow Method** was used to determine the ideal number of natural groupings within the data. The analysis clearly indicated that **four clusters** provided the best balance of detail and distinction.
4.  **K-Means Clustering:** The K-Means algorithm was then applied to partition the 1,700+ songs into the four identified cohorts.
5.  **Visualization:** Principal Component Analysis (PCA) was used to reduce the 9-dimensional feature space into 2 dimensions, allowing for a clear visualization of the four distinct song cohorts.

### 4. The Four Song Cohorts: A Deep Dive
The analysis revealed four musically coherent and distinct cohorts:

| Cohort ID | Persona | Key Characteristics | Business Application |
| :--- | :--- | :--- | :--- |
| **0** | **Studio Rock Anthems** | High energy, high loudness, high positivity (valence). Low acousticness. | The core of any "Best Of" or "Introduction to The Rolling Stones" playlist. |
| **1** | **Live Performances** | Extremely high `liveness` score, high energy, fast tempo. | Powering a "Rolling Stones Live" radio station or for fans who prefer concert recordings. |
| **2** | **Instrumental Jams** | Very high `instrumentalness`, maintaining high rock energy. | Niche playlists for "deep cut" fans, studying musicians, or background music. |
| **3** | **Acoustic & Mellow** | High `acousticness`, low energy, low loudness. | "Chill," "Acoustic," or "Late Night" playlists. Perfect for a different listening context. |

### 5. Strategic Recommendations
The creation of these cohorts is not just an analytical exercise; it is a direct path to enhancing the user experience. We recommend the following actions:
1.  **Enrich Song Metadata:** Tag each Rolling Stones song in our backend with its new cohort ID.
2.  **Power Thematic Playlists:** Auto-generate playlists such as "Rolling Stones: The Anthems," "Rolling Stones: Live in Concert," and "Rolling Stones: Unplugged" using these cohorts.
3.  **Improve Radio Algorithm:** When a user starts a radio station from a song in one cohort (e.g., an acoustic track), the algorithm should be weighted to play other songs from the same cohort, creating a more consistent listening experience.
4.  **Expand the Model:** Apply this same methodology to other artists with large catalogs to scale this capability across the platform.

By understanding *why* songs are similar, we can move beyond simple popularity-based recommendations and deliver a truly personalized and context-aware experience to our users.