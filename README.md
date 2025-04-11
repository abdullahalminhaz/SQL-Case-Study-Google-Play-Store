# 📱 Google Play Store SQL Case Study

This project is a comprehensive analysis of the Google Play Store dataset using Python and SQL. It demonstrates data cleaning, business insight generation, SQL procedures/triggers, and data exploration to support strategic app development decisions.

---

## 📊 Project Overview

As a market analyst and data specialist, I worked on real-world business questions such as:
- Identifying top-performing app categories.
- Estimating revenue from paid apps.
- Understanding app category distribution.
- Detecting unauthorized price changes using SQL triggers.
- Exploring rating-review correlation.
- Building dynamic tools using SQL procedures.

---

## 🧰 Tools & Technologies

- **Python** (for data cleaning)
- **MySQL** (for SQL analysis)
- **SQL Triggers & Procedures**
- **Google Colab**
- **Git & GitHub**

---

## 🧼 Data Cleaning (Python)

The raw CSV dataset was cleaned using Python:
- Handled null values
- Standardized column formats
- Prepared data for SQL ingestion

The cleaned dataset was then imported into MySQL using `LOAD DATA INFILE`.

---

## 📁 File Overview

| Path                        | File/Folder                  | Description                                                                 |
|----------------------------|------------------------------|-----------------------------------------------------------------------------|
| `/data/`                   | `googleplaystore(impure).csv`| Raw dataset containing missing values, duplicates, and inconsistencies      |
| `/data/`                   | `playstore.csv`              | Cleaned and preprocessed dataset ready for SQL analysis                     |
| `/sql/`                    | `analysis_queries.sql`       | SQL file containing all queries, triggers, stored procedures, and functions |
| `/python/`                 | `data_cleaning.ipynb`        | Python Jupyter Notebook used for cleaning and preparing the dataset         |
| `/`                        | `README.md`                  | Project overview, objectives, business questions, insights, and findings    |



---

## 🔍 Key SQL Tasks & Insights

### 1️⃣ Top 5 Categories for Free Apps (Based on Ratings)
EVENTS, EDUCATION, ART_AND_DESIGN, BOOKS_AND_REFERENCE, PARENTING

### 2️⃣ Highest Revenue Generating Categories (Paid Apps)
LIFESTYLE, FINANCE, PHOTOGRAPHY

### 3️⃣ Percentage Distribution of Apps by Category
Top 5:
- FAMILY – 18.65%
- GAME – 11.72%
- TOOLS – 7.83%
- PRODUCTIVITY – 3.75%
- MEDICAL – 3.74%

### 4️⃣ Recommendation: Free vs Paid Apps (Based on Ratings)
Built logic to recommend whether to build paid or free apps category-wise using average rating comparison.

### 5️⃣ Hacker Alert: Track Price Changes Using Triggers
Used SQL Trigger to automatically record price changes into a `PriceChangeLog` table. Helped recover original prices after unauthorized edits.

### 6️⃣ Genre Splitting with SQL Functions
Split multi-genre values like `'Art & Design;Pretend Play'` into two clean columns using custom SQL functions.

### 7️⃣ Correlation Between Ratings and Reviews
Pearson Correlation Coefficient, r = 0.06
(Slight positive correlation between user reviews and ratings)

### 8️⃣ Dynamic Stored Procedure for Underperforming Apps
Created a stored procedure `checking('category')` that shows apps with below-average ratings for any given category.

---

## 👤 Author

**Abdullah Al Minhaz**  
BEEE learner | Aspiring Data Scientist & Roboticist  
📍 Jamalpur Science and Technology University (JSTU)  
🔗 [LinkedIn](https://www.linkedin.com/in/abdullahalminhaz)

---

## ⭐ Project Highlights
- Combined Python + SQL for end-to-end analysis.
- Demonstrated advanced SQL concepts: triggers, stored procedures, nested queries.
- Created real-world business solutions and automation logic.

---

## 📌 Future Work
- Add Power BI / Tableau dashboard
- Build SQL views for app performance reports
- Create a recommender system using Python

---

## 🗃 License
This project is open-source and free to use for learning and academic purposes.





