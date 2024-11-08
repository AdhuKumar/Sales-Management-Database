-- ========================================
-- DROP EXISTING TABLES (IF THEY EXIST)
-- ========================================
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS sales_order;

-- ========================================
-- CREATE TABLE: PRODUCTS
-- ========================================
CREATE TABLE products (
    id            INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incremented product ID
    name          VARCHAR(100),                                -- Product name
    price         FLOAT,                                       -- Product price
    release_date  DATE                                         -- Release date of the product
);

-- Insert sample data into the products table
INSERT INTO products VALUES (DEFAULT, 'iPhone 15', 800, TO_DATE('22-08-2023', 'DD-MM-YYYY'));
INSERT INTO products VALUES (DEFAULT, 'Macbook Pro', 2100, TO_DATE('12-10-2022', 'DD-MM-YYYY'));
INSERT INTO products VALUES (DEFAULT, 'Apple Watch 9', 550, TO_DATE('04-09-2022', 'DD-MM-YYYY'));
INSERT INTO products VALUES (DEFAULT, 'iPad', 400, TO_DATE('25-08-2020', 'DD-MM-YYYY'));
INSERT INTO products VALUES (DEFAULT, 'AirPods', 420, TO_DATE('30-03-2024', 'DD-MM-YYYY'));

-- ========================================
-- CREATE TABLE: CUSTOMERS
-- ========================================
CREATE TABLE customers (
    id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incremented customer ID
    name    VARCHAR(100),                                -- Customer name
    email   VARCHAR(30)                                  -- Customer email address
);

-- Insert sample data into the customers table
INSERT INTO customers VALUES (DEFAULT, 'Meghan Harley', 'mharley@demo.com');
INSERT INTO customers VALUES (DEFAULT, 'Rosa Chan', 'rchan@demo.com');
INSERT INTO customers VALUES (DEFAULT, 'Logan Short', 'lshort@demo.com');
INSERT INTO customers VALUES (DEFAULT, 'Zaria Duke', 'zduke@demo.com');

-- ========================================
-- CREATE TABLE: EMPLOYEES
-- ========================================
CREATE TABLE employees (
    id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incremented employee ID
    name    VARCHAR(100)                                 -- Employee name
);

-- Insert sample data into the employees table
INSERT INTO employees VALUES (DEFAULT, 'Nina Kumari');
INSERT INTO employees VALUES (DEFAULT, 'Abrar Khan');
INSERT INTO employees VALUES (DEFAULT, 'Irene Costa');

-- ========================================
-- CREATE TABLE: SALES_ORDERS
-- ========================================
CREATE TABLE sales_order (
    order_id       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Auto-incremented order ID
    order_date     DATE,                                        -- Date of the order
    quantity       INT,                                         -- Quantity of products in the order
    prod_id        INT REFERENCES products(id),                 -- Foreign key to products table
    status         VARCHAR(20),                                 -- Delivery status of the order
    customer_id    INT REFERENCES customers(id),                -- Foreign key to customers table
    emp_id         INT,                                         -- Foreign key to employees table
    CONSTRAINT fk_so_emp FOREIGN KEY (emp_id) REFERENCES employees(id)
);

-- Insert sample data into the sales_order table
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('01-01-2024', 'DD-MM-YYYY'), 2, 1, 'Completed', 1, 1);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('01-01-2024', 'DD-MM-YYYY'), 3, 1, 'Pending', 2, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('02-01-2024', 'DD-MM-YYYY'), 3, 2, 'Completed', 3, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('03-01-2024', 'DD-MM-YYYY'), 3, 3, 'Completed', 3, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('04-01-2024', 'DD-MM-YYYY'), 1, 1, 'Completed', 3, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('04-01-2024', 'DD-MM-YYYY'), 1, 3, 'Completed', 2, 1);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('04-01-2024', 'DD-MM-YYYY'), 1, 2, 'On Hold', 2, 1);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('05-01-2024', 'DD-MM-YYYY'), 4, 2, 'Rejected', 1, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('06-01-2024', 'DD-MM-YYYY'), 5, 5, 'Completed', 1, 2);
INSERT INTO sales_order VALUES (DEFAULT, TO_DATE('06-01-2024', 'DD-MM-YYYY'), 1, 1, 'Cancelled', 1, 1);

-- ========================================
-- DISPLAY ALL TABLES
-- ========================================
SELECT * FROM products;    -- View all product details
SELECT * FROM customers;   -- View all customer details
SELECT * FROM employees;   -- View all employee details
SELECT * FROM sales_order; -- View all sales order details

-- ========================================
-- ANALYTICAL QUERIES
-- ========================================

-- 1. Total number of products sold
SELECT SUM(quantity) AS total_products FROM sales_order;

-- 2. Display distinct delivery statuses other than 'Completed'
SELECT DISTINCT status FROM sales_order WHERE LOWER(status) <> 'completed';

-- 3. Order details of completed orders
SELECT so.order_id, so.order_date, p.name AS product_name
FROM sales_order so
JOIN products p ON p.id = so.prod_id
WHERE LOWER(so.status) = 'completed';

-- 4. Sorted completed orders with customer names
SELECT so.order_id, so.order_date, p.name AS product, c.name AS customer
FROM sales_order so
JOIN products p ON p.id = so.prod_id
JOIN customers c ON c.id = so.customer_id
WHERE LOWER(so.status) = 'completed'
ORDER BY so.order_date;

-- 5. Total number of orders per delivery status
SELECT status, COUNT(*) AS tot_orders
FROM sales_order
GROUP BY status;

-- 6. Count of orders (not completed) with more than 1 item
SELECT COUNT(status) AS not_completed_orders
FROM sales_order
WHERE quantity > 1 AND LOWER(status) <> 'completed';

-- 7. Total orders per status (case-insensitive), sorted by count
SELECT status, COUNT(*) AS tot_orders
FROM (SELECT CASE WHEN LOWER(status) = 'completed' THEN 'Completed' ELSE status END AS status FROM sales_order) sq
GROUP BY status
ORDER BY tot_orders DESC;

-- ========================================
-- CONTINUE WITH ADDITIONAL QUERIES
-- Refer to earlier queries for full detailed list
-- ========================================


-- 7. Total orders per status (case-insensitive), sorted by count
-- This query first normalizes the case of the 'status' column using a subquery.
-- 'Completed' statuses are made consistent, and the counts for each status are calculated and sorted in descending order.
SELECT status, COUNT(*) AS tot_orders
FROM (
    SELECT CASE 
             WHEN LOWER(status) = 'completed' THEN 'Completed' -- Normalize 'completed' statuses
             ELSE status 
           END AS status 
    FROM sales_order
) sq
GROUP BY status -- Group by the normalized status
ORDER BY tot_orders DESC; -- Sort by the total number of orders

-- 8. Total products purchased by each customer
-- This query calculates the total quantity of products purchased by each customer.
SELECT c.name AS customer, SUM(quantity) AS total_products
FROM sales_order so
JOIN customers c ON c.id = so.customer_id -- Join to get customer details
GROUP BY c.name; -- Group results by customer name to get individual totals

-- 9. Total and average sales for each day
-- Calculates the total and average sales amount for each order date.
SELECT order_date, 
       SUM(quantity * p.price) AS total_sales, -- Total sales amount (quantity * price)
       AVG(quantity * p.price) AS avg_sales -- Average sales amount
FROM sales_order so
JOIN products p ON p.id = so.prod_id -- Join to get product prices
GROUP BY order_date -- Group by date for daily totals
ORDER BY order_date; -- Sort by order date

-- 10. Customer, employee, and total sales for 'On Hold' or 'Pending' orders
-- Identifies customers and employees involved in orders with specific statuses.
SELECT c.name AS customer, e.name AS employee, 
       SUM(quantity * p.price) AS total_sales -- Total sales for these orders
FROM sales_order so
JOIN employees e ON e.id = so.emp_id -- Join to get employee details
JOIN customers c ON c.id = so.customer_id -- Join to get customer details
JOIN products p ON p.id = so.prod_id -- Join to get product prices
WHERE status IN ('On Hold', 'Pending') -- Filter for specific statuses
GROUP BY c.name, e.name; -- Group by customer and employee to get totals

-- 11. Orders not completed/pending or handled by employee Abrar
-- Retrieves orders either not in 'completed' or 'pending' statuses or handled by an employee with 'Abrar' in their name.
SELECT e.name AS employee, so.*
FROM sales_order so
JOIN employees e ON e.id = so.emp_id -- Join to get employee details
WHERE LOWER(e.name) LIKE '%abrar%' -- Check if the employee's name contains 'Abrar'
   OR LOWER(status) NOT IN ('completed', 'pending'); -- Exclude specific statuses

-- 12. Orders costing more than $2000, excluding 'MacBook Pro'
-- Finds orders meeting the conditions, including the total sale amount.
SELECT (so.quantity * p.price) AS total_sale, so.*
FROM sales_order so
JOIN products p ON p.id = so.prod_id -- Join to get product prices
WHERE prod_id NOT IN (
          SELECT id FROM products WHERE name = 'MacBook Pro' -- Exclude 'MacBook Pro'
      )
  AND (so.quantity * p.price) > 2000; -- Filter for orders with total cost > $2000

-- 13. Customers who haven't purchased any products
-- Identifies customers with no corresponding entries in the sales_order table.
SELECT c.*
FROM customers c
LEFT JOIN sales_order so ON so.customer_id = c.id -- Left join to include all customers
WHERE so.order_id IS NULL; -- Filter for customers with no matching sales

-- 14. Total products purchased by each customer (including non-buyers)
-- Retrieves the total quantity of products purchased by each customer, including those who haven't made any purchases.
SELECT c.name, 
       COALESCE(SUM(quantity), 0) AS tot_prod_purchased -- Handle nulls with COALESCE
FROM sales_order so
RIGHT JOIN customers c ON c.id = so.customer_id -- Right join to include all customers
GROUP BY c.name
ORDER BY tot_prod_purchased DESC; -- Sort by total quantity purchased

-- 15. Total sales made by employees for completed orders
-- Displays the total sales made by each employee, including those with no sales yet.
SELECT e.name AS employee, 
       COALESCE(SUM(p.price * so.quantity), 0) AS total_sale -- Handle nulls with COALESCE
FROM sales_order so
JOIN products p ON p.id = so.prod_id -- Join to get product prices
RIGHT JOIN employees e ON e.id = so.emp_id AND LOWER(so.status) = 'completed' -- Include all employees
GROUP BY e.name
ORDER BY total_sale DESC; -- Sort by total sales

-- 16. Total sales by employees for each customer (include unserved customers)
-- Displays the total sales by employees for each customer, filling missing customers with '-'.
SELECT e.name AS employee, 
       COALESCE(c.name, '-') AS customer, -- Use '-' for customers with no orders
       COALESCE(SUM(p.price * so.quantity), 0) AS total_sale -- Handle nulls with COALESCE
FROM sales_order so
JOIN products p ON p.id = so.prod_id -- Join to get product prices
JOIN customers c ON c.id = so.customer_id -- Join to get customer details
RIGHT JOIN employees e ON e.id = so.emp_id AND LOWER(so.status) = 'completed' -- Include all employees
GROUP BY e.name, c.name
ORDER BY total_sale DESC;

-- 17. Total sales by employees for each customer with sales > $1000
-- Filters the previous query to include only customers with sales exceeding $1000.
SELECT e.name AS employee, 
       COALESCE(c.name, '-') AS customer, 
       COALESCE(SUM(p.price * so.quantity), 0) AS total_sale
FROM sales_order so
JOIN products p ON p.id = so.prod_id
JOIN customers c ON c.id = so.customer_id
RIGHT JOIN employees e ON e.id = so.emp_id AND LOWER(so.status) = 'completed'
GROUP BY e.name, c.name
HAVING SUM(p.price * so.quantity) > 1000 -- Filter for sales > $1000
ORDER BY total_sale DESC;

-- 18. Employees who served more than 2 distinct customers
-- Identifies employees who have served more than 2 unique customers.
SELECT e.name, COUNT(DISTINCT c.name) AS total_customers
FROM sales_order so
JOIN employees e ON e.id = so.emp_id -- Join to get employee details
JOIN customers c ON c.id = so.customer_id -- Join to get customer details
GROUP BY e.name
HAVING COUNT(DISTINCT c.name) > 2; -- Filter for employees with > 2 customers

-- 19. Customers who purchased more than 5 products
-- Finds customers who purchased a total quantity exceeding 5.
SELECT c.name AS customer, SUM(quantity) AS total_products_purchased
FROM sales_order so
JOIN customers c ON c.id = so.customer_id
GROUP BY c.name
HAVING SUM(quantity) > 5; -- Filter for total quantity > 5

-- 20. Customers whose average purchase cost exceeds the overall average
-- Identifies customers whose average purchase value is higher than the overall average.
SELECT c.name AS customer, AVG(quantity * p.price) AS avg_purchase
FROM sales_order so
JOIN customers c ON c.id = so.customer_id -- Join to get customer details
JOIN products p ON p.id = so.prod_id -- Join to get product prices
GROUP BY c.name
HAVING AVG(quantity * p.price) > (
          SELECT AVG(quantity * p.price) -- Calculate overall average
          FROM sales_order so
          JOIN products p ON p.id = so.prod_id
      );
