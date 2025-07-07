# Employee Performance Mapping with SQL

## 1. Overview

This project addresses a request from the HR department of ScienceQtech, a data science startup, to analyze employee performance data for the annual appraisal cycle. The goal was to build a database from multiple data sources and generate reports to help map employee performance, calculate bonuses, and identify training needs.

The final solution involved creating a relational database, importing data, and writing a series of complex SQL queries to extract actionable insights.

---

## 2. Tools & Technologies

- **Database:** MySQL
- **IDE:** MySQL Workbench
- **Data Source:** CSV files (`emp_record_table.csv`, `proj_table.csv`, `data_science_team.csv`)

---

## 3. Skills & Concepts Demonstrated

This project showcases a wide range of SQL skills, from basic to advanced:

- **Database Design:**
- Created a normalized schema with primary and foreign key constraints.
- Designed an ER diagram to visualize table relationships.
- **Data Manipulation & Filtering:**
- Used `SELECT`, `WHERE`, `BETWEEN`, and `LIKE` for targeted data retrieval.
- Combined datasets using `UNION`.
- **Advanced SQL:**
- **Window Functions:** Used `RANK()` and `MAX() OVER (PARTITION BY ...)` to rank employees and calculate departmental benchmarks.
- **Stored Procedures:** Created a procedure to fetch employees based on experience, encapsulating reusable logic.
- **Stored Functions:** Built a function to validate employee job titles against organizational standards based on experience.
- **Views:** Created a view to provide a secure, filtered look at high-earning employees.
- **Subqueries & CTEs:** Wrote nested queries for complex filtering.
- **Performance Tuning:**
- Analyzed query performance using `EXPLAIN`.
- Created an index to optimize query speed for a specific search condition.

---

## 4. Key Queries & Visuals

*(This section is a placeholder. Add your own screenshots from MySQL Workbench to the `visuals/` folder and link them here.)*

#### **Bonus Calculation Report**
*A query was written to calculate a 5% bonus based on employee salary and performance rating.*


#### **Departmental Performance Mapping**
*This query uses a window function to show each employee's rating alongside the maximum rating in their department.*


#### **Job Profile Validation**
*The stored function checks if an employee's role aligns with their years of experience.*
*

#### **Top Performing Routes**
*A query to identify the most frequently traveled routes by counting ticket bookings.*


#### **Customer Booking Analysis**
*This query identifies regular customers who have booked more than one flight.*
, which is a critical first step in any real-world analysis.