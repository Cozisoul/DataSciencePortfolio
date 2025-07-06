-- ==========================================================
-- Happy Mart Retail Database Schema Setup
-- Author: [Thaplelo Madiba Masebe]
-- Date:   [2025-06-06]
-- ==========================================================

-- 1. Drop and Create the Database
DROP DATABASE IF EXISTS sql_basics;-- 3. Create Product Table
DROP TABLE IF EXISTS product;
CREATE TABLE product (
 p_code     INT PRIMARY KEY,
 p_name     VARCHAR(100) NOT NULL,
 price      DECIMAL(10,2) NOT NULL CHECK (price >= 0),
 stock      INT NOT NULL CHECK (stock >= 0),
 category   VARCHAR(50) NOT NULL
) ENGINE=InnoDB COMMENT='Product catalog';

CREATE DATABASE sql_basics
 DEFAULT CHARACTER SET utf8mb4
 DEFAULT COLLATE utf8mb4_unicode_ci;

USE sql_basics;

-- 2. Create Customer Table
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
 c_id       INT PRIMARY KEY,
 c_name     VARCHAR(100) NOT NULL,
 c_location VARCHAR(100),
 c_phoneno  VARCHAR(20)
) ENGINE=InnoDB COMMENT='Customer master data';

-- 3. Create Product Table
DROP TABLE IF EXISTS product;
CREATE TABLE product (
 p_code     INT PRIMARY KEY,
 p_name     VARCHAR(100) NOT NULL,
 price      DECIMAL(10,2) NOT NULL CHECK (price >= 0),
 stock      INT NOT NULL CHECK (stock >= 0),
 category   VARCHAR(50) NOT NULL
) ENGINE=InnoDB COMMENT='Product catalog';

-- 4. Create Sales Table
--  DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
 order_date   DATE NOT NULL,
 order_no     VARCHAR(20) PRIMARY KEY,
 c_id         INT NOT NULL,
 c_name       VARCHAR(100) NOT NULL,
 s_code       INT NOT NULL,
 p_name       VARCHAR(100) NOT NULL,
 qty          INT NOT NULL CHECK (qty > 0),
 price        DECIMAL(10,2) NOT NULL CHECK (price >= 0),
 FOREIGN KEY (c_id) REFERENCES customer(c_id),
 FOREIGN KEY (s_code) REFERENCES product(p_code)
) ENGINE=InnoDB COMMENT='Sales transactions';

 SELECT * FROM sales;

-- 5. Add new columns: serial number and categories to sales table
ALTER TABLE sales ADD COLUMN serial_number INT AUTO_INCREMENT UNIQUE FIRST;
ALTER TABLE sales ADD COLUMN categories VARCHAR(50);

-- 6. Change the stock field type to varchar in product table
ALTER TABLE product MODIFY COLUMN stock VARCHAR(20);

-- 7. Change the table name from customer to customer_details
RENAME TABLE customer TO customer_details;

-- 8. Drop the serial_number and categories columns from sales table
ALTER TABLE sales DROP COLUMN serial_number;
ALTER TABLE sales DROP COLUMN categories;

-- 9. Display order ID, customer ID, order date, price, and quantity columns of the sales table
SELECT order_no AS order_id, c_id AS customer_id, order_date, price, qty FROM sales;

-- 10. Display details where the category is stationary from the product table
SELECT * FROM product WHERE LOWER(category) = 'stationary';

-- 11. Display the unique category from the product table
SELECT DISTINCT categorycategorycategorycategorycategory FROM product;

-- 12. Display details of sales where quantity > 2 and price < 500
SELECT * FROM sales WHERE qty > 2 AND price < 500;

-- 13. Display every customer whose name ends with an ‘a’
SELECT * FROM customer_details WHERE c_name LIKE '%a';

-- 14. Display the product details in descending order of price
SELECT * FROM product ORDER BY price DESC;

-- 15. Display the product code and category from categories that have two or more products
SELECT p_code, category
FROM product
WHERE category IN (
SELECT category FROM product GROUP BY category HAVING COUNT(*) >= 2
);

-- 16. Combine the sales and product tables based on the order number and customer's name including duplicated rows
SELECT s.*, p.*
FROM sales s
JOIN product p ON s.s_code = p.p_code
JOIN customer c ON s.c_id = c.c_id
ORDER BY s.order_no, c.c_name;

-- ==========================================================
-- End of Script
-- ==========================================================
