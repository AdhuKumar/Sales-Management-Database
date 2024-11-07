# Sales Management Database

This project demonstrates a robust Sales Management Database built using SQL. It contains relational tables for managing products, customers, employees, and sales orders, along with insightful queries to analyze business performance.

---

## Table of Contents

1. [Description](#description)
2. [Schema Overview](#schema-overview)
3. [Features](#features)
4. [Setup Instructions](#setup-instructions)
5. [Queries and Analysis](#queries-and-analysis)
6. [Case Study Questions](#case-study-questions)

---

## Description

This project simulates a complete sales database system, including:
- **Products**: Manage details such as product name, price, and release date.
- **Customers**: Store customer information such as name and email.
- **Employees**: Track employee details for order assignments.
- **Sales Orders**: Record transactions, delivery statuses, and relationships between employees, customers, and products.

The database supports both day-to-day operations and advanced analytics with pre-written queries.

---

## Schema Overview

### Tables Created:

1. **Products**  
   Stores product details like ID, name, price, and release date.
   
2. **Customers**  
   Stores customer details such as name and email.
   
3. **Employees**  
   Maintains employee information.
   
4. **Sales Order**  
   Tracks sales transactions, including products, customers, employees, and order statuses.

---

## Features

- View total sales for specific customers, employees, or days.
- Analyze total orders and product quantities by status, employee, and customer.
- Calculate average and total sales for specific time periods.
- Handle various delivery statuses and sales conditions (e.g., "On Hold", "Completed").

---

## Setup Instructions

1. Download or clone this repository to your local machine.
2. Import the SQL file into your SQL database (e.g., MySQL, PostgreSQL).
3. Run the queries in your database management system.

---

## Queries and Analysis

The SQL queries provided in this repository cover a wide range of analysis for your sales database. These include total sales, product quantities, and customer behavior, as well as employee performance.

---

## Case Study Questions

Below are the SQL queries corresponding to the case study questions:

1. **Find the total number of orders corresponding to each delivery status, ignoring case.**  
   Sort the result by the number of orders in descending order.
   
2. **Identify the total products purchased by each customer.**

3. **Display the total and average sales done for each day.**

4. **Display the customer name, employee name, and total sale amount of all orders which are either 'On Hold' or 'Pending'.**

5. **Fetch all the orders which were neither 'Completed' nor 'Pending' or were handled by the employee named Abrar.**  
   Display the employee name along with all order details.

6. **Fetch the orders which cost more than $2000 but did not include 'MacBook Pro'.**  
   Print the total sale amount as well.

7. **Identify the customers who have not purchased any product yet.**

8. **Write a query to identify the total products purchased by each customer.**  
   Return all customers irrespective of whether they have made a purchase or not.  
   Sort the result with the highest number of orders at the top.

9. **Corresponding to each employee, display the total sales they made of all the completed orders.**  
   Display total sales as 0 if an employee made no sales yet.

10. **Re-write the above query to display the total sales made by each employee corresponding to each customer.**  
    If an employee has not served a customer yet, then display "-" under the customer column.

11. **Re-write the above query to display only those records where the total sales are above $1000.**

12. **Identify employees who have served more than 2 customers.**

13. **Identify the customers who have purchased more than 5 products.**

14. **Identify customers whose average purchase cost exceeds the average sale amount of all orders.**

---



