-- ==========================================================
-- ScienceQtech Employee Performance Mapping Project Script
-- Author: Thapelo Masebe
-- Date:   2025--06-10
-- ==========================================================

-- 1. Create database
DROP DATABASE IF EXISTS employee;
CREATE DATABASE employee DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
USE employee;

-- 2. Create tables
DROP TABLE IF EXISTS emp_record_table;
DROP TABLE IF EXISTS proj_table;
DROP TABLE IF EXISTS data_science_team;

CREATE TABLE proj_table (
project_id   VARCHAR(10) PRIMARY KEY,
proj_name    VARCHAR(100) NOT NULL,
domain       VARCHAR(100) NOT NULL,
start_date   VARCHAR(10) NOT NULL,
closure_date VARCHAR(10),
dev_qtr      VARCHAR(10),
status       VARCHAR(50)
);

SET SQL_SAFE_UPDATES = 0;

UPDATE proj_table
SET closure_date = STR_TO_DATE(closure_date, '%m-%d-%Y')
WHERE closure_date LIKE '%-%-%';

UPDATE proj_table
SET start_date = STR_TO_DATE(start_date, '%m-%d-%Y')
WHERE start_date LIKE '%-%-%';

CREATE TABLE emp_record_table (
emp_id      VARCHAR(10) PRIMARY KEY,
first_name  VARCHAR(100) NOT NULL,
last_name   VARCHAR(100) NOT NULL,
gender      ENUM('M','F','O') NOT NULL,
role        VARCHAR(100) NOT NULL,
dept        VARCHAR(100) NOT NULL,
exp         INT NOT NULL CHECK (exp >= 0),
country     VARCHAR(100) NOT NULL,
continent   VARCHAR(50) NOT NULL,
salary      DECIMAL(12,2) NOT NULL CHECK (salary >= 0),
emp_rating  INT NOT NULL CHECK (emp_rating BETWEEN 1 AND 5),
manager_id  VARCHAR(10),
proj_id     VARCHAR(10),
FOREIGN KEY (proj_id) REFERENCES proj_table(project_id)
);

CREATE TABLE data_science_team (
emp_id      VARCHAR(10) PRIMARY KEY,
first_name  VARCHAR(100) NOT NULL,
last_name   VARCHAR(100) NOT NULL,
gender      ENUM('M','F','O') NOT NULL,
role        VARCHAR(100) NOT NULL,
dept        VARCHAR(100) NOT NULL,
exp         INT NOT NULL CHECK (exp >= 0),
country     VARCHAR(100) NOT NULL,
continent   VARCHAR(50) NOT NULL
);

-- 3. Import your CSVs using Table Data Import Wizard in MySQL Workbench.
-- (Right-click each table > Table Data Import Wizard > select CSV file.)

SELECT * From emp_record_table;
SELECT * From proj_table;
SELECT * From data_science_team;


-- =======================
-- QUERIES & TASKS
-- =======================

-- 4. List employees and their departments
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table;

-- 5. Employees with emp_rating <2, >4, or between 2 and 4

-- Less than two
SELECT emp_id, first_name, last_name, gender, dept, emp_rating
FROM emp_record_table WHERE emp_rating < 2;

-- Greater than four
SELECT emp_id, first_name, last_name, gender, dept, emp_rating
FROM emp_record_table WHERE emp_rating > 4;

-- Between two and four (inclusive)
SELECT emp_id, first_name, last_name, gender, dept, emp_rating
FROM emp_record_table WHERE emp_rating BETWEEN 2 AND 4;

-- 6. Concatenate FIRST_NAME and LAST_NAME for Finance department
SELECT CONCAT(first_name, ' ', last_name) AS NAME
FROM emp_record_table
WHERE dept = 'Finance';

-- 7. Employees who have reporters (including President)
SELECT e.emp_id, e.first_name, e.last_name, COUNT(r.emp_id) AS num_reporters
FROM emp_record_table e
JOIN emp_record_table r ON e.emp_id = r.manager_id
GROUP BY e.emp_id, e.first_name, e.last_name
HAVING num_reporters > 0;

-- 8. Employees from healthcare and finance departments using UNION
SELECT * FROM emp_record_table WHERE dept = 'Healthcare'
UNION
SELECT * FROM emp_record_table WHERE dept = 'Finance';

-- 9. Employee details grouped by dept, include max emp rating for dept
SELECT emp_id, first_name, last_name, role, dept, emp_rating,
   MAX(emp_rating) OVER (PARTITION BY dept) AS max_dept_rating
FROM emp_record_table;

-- 10. Min and max salary of employees in each role
SELECT role, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM emp_record_table
GROUP BY role;

-- 11. Assign ranks to each employee based on experience
SELECT emp_id, first_name, last_name, exp,
   RANK() OVER (ORDER BY exp DESC) AS exp_rank
FROM emp_record_table;

-- 12. Create a view for employees in various countries with salary > 6000
CREATE OR REPLACE VIEW high_earners_by_country AS
SELECT * FROM emp_record_table WHERE salary > 6000;

SELECT * FROM high_earners_by_country;

-- 13. Nested query: employees with experience > 10 years
SELECT * FROM emp_record_table
WHERE emp_id IN (
SELECT emp_id FROM emp_record_table WHERE exp > 10
);

-- 14. Stored procedure: employees with experience > 3 years
DELIMITER $$
CREATE PROCEDURE get_experienced_employees()
BEGIN
SELECT * FROM emp_record_table WHERE exp > 3;
END $$
DELIMITER ;

-- EXECUTE  

-- To call:
CALL get_experienced_employees();

-- 15. Stored function: check job profile standard
DELIMITER $$
CREATE FUNCTION check_profile_standard(experience INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE profile VARCHAR(50);
IF experience <= 2 THEN SET profile = 'JUNIOR DATA SCIENTIST';
ELSEIF experience > 2 AND experience <= 5 THEN SET profile = 'ASSOCIATE DATA SCIENTIST';
ELSEIF experience > 5 AND experience <= 10 THEN SET profile = 'SENIOR DATA SCIENTIST';
ELSEIF experience > 10 AND experience <= 12 THEN SET profile = 'LEAD DATA SCIENTIST';
ELSEIF experience > 12 AND experience <= 16 THEN SET profile = 'MANAGER';
ELSE SET profile = 'OTHER';
END IF;
RETURN profile;
END $$
DELIMITER ;

-- Usage example:
SELECT emp_id, first_name, last_name, exp, check_profile_standard(exp) AS org_standard
FROM data_science_team;

-- 16. Create index for FIRST_NAME and check execution plan
CREATE INDEX idx_first_name ON emp_record_table(first_name);
EXPLAIN SELECT * FROM emp_record_table WHERE first_name = 'Eric';

-- 17. Calculate bonus for all employees (5% of salary * emp_rating)
SELECT emp_id, first_name, last_name, salary, emp_rating,
   (salary * 0.05 * emp_rating) AS bonus
FROM emp_record_table;

-- 18. Average salary distribution by continent and country
SELECT continent, country, AVG(salary) AS avg_salary
FROM emp_record_table
GROUP BY continent, country;

-- ==========================================================
-- End of Script
-- ==========================================================