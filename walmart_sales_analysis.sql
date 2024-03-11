----- Create database

CREATE DATABASE WalmartSales;

----- Create table

CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price FLOAT NOT NULL,
    quantity INT NOT NULL,
    tax_percentage FLOAT NOT NULL,
    total FLOAT NOT NULL,
    date_value DATETIME NOT NULL,
    time_value TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs FLOAT NOT NULL,
    gross_margin_percentage FLOAT NOT NULL,
    gross_income FLOAT NOT NULL,
    rating FLOAT NOT NULL
);

SELECT * FROM sales;

-------------------------------------------------------------------------------------------------------
----------------- Feature Engineering ------------------------

----- time_of_day

SELECT time_value,
(CASE
	WHEN time_value BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN time_value BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END) AS time_of_day
FROM sales;

ALTER TABLE sales
ADD time_of_day VARCHAR(20);



UPDATE sales
SET time_of_day = (
CASE
	WHEN time_value BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN time_value BETWEEN '12:00:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END
);

SELECT invoice_id, time_of_day FROM sales;

----- day_name

SELECT date_value, 
DATENAME(w, date_value) AS [day_name]
FROM [sales];

ALTER TABLE sales
ADD day_name VARCHAR(10);

UPDATE sales
SET day_name = DATENAME(w, date_value);

SELECT invoice_id, day_name FROM sales;

----- month_name

SELECT date_value, 
DATENAME(MONTH, date_value) AS [month_name]
FROM [sales];

ALTER TABLE sales
ADD month_name VARCHAR(10);

UPDATE sales
SET month_name = DATENAME(MONTH, date_value);

SELECT invoice_id, month_name FROM sales;





------------------------------------------------------------------------------------------------------


---------------------- Generic ------------------------------


----- How many unique cities does the data have?

SELECT DISTINCT city FROM sales;



----- In which city is each branch?

SELECT DISTINCT city, branch FROM sales;


-----------------------------------------------------------------------------------------------------

---------------------------- Product ------------------------


----- How many unique product lines does the data have?

SELECT DISTINCT product_line FROM sales;



----- What is the most common payment method?

SELECT payment, COUNT(payment) AS count_pay
FROM sales
GROUP BY payment
ORDER BY count_pay DESC;



----- What is the most selling product line?

SELECT product_line, SUM(quantity) AS total_sales
FROM sales
GROUP BY product_line
ORDER BY total_sales DESC;


------What is the total revenue by month?

SELECT month_name, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;


------What month had the largest COGS?

SELECT month_name, SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;


------What product line had the largest revenue?

SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


------What is the city with the largest revenue? 

SELECT city, branch, SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;


-----What product line had the largest VAT?

SELECT product_line, avg(tax_percentage) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-----Which branch sold more products than average product sold?

SELECT branch, SUM(quantity)
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


------What is the most common product line by gender?

SELECT gender, product_line, COUNT(gender) AS count_gender
FROM sales
GROUP BY gender, product_line
ORDER BY count_gender DESC;


------What is the average rating of each product line?

SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-----------------------------------------------------------------------------------------------------

---------------------------Sales----------------------------

---Number of sales made in each time of the day per weekday?

SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;


---Which of the customer types brings the most revenue?

SELECT customer_type, ROUND(SUM(total), 0) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;


---Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT city, AVG(tax_percentage) AS largest_vat
FROM sales
GROUP BY city
ORDER BY largest_vat DESC;


---Which customer type pays the most in VAT?

SELECT customer_type, AVG(tax_percentage) AS largest_vat
FROM sales
GROUP BY customer_type
ORDER BY largest_vat DESC;


-----------------------------------------------------------------------------------------------------

-------------------------Customer------------------------------

-- How many unique customer types does the data have?

SELECT DISTINCT customer_type
FROM sales;


---How many unique payment methods does the data have?

SELECT DISTINCT payment
FROM sales;

---What is the most common customer type?

SELECT customer_type, COUNT(customer_type) AS count_customer
FROM sales
GROUP BY customer_type
ORDER BY count_customer DESC;


---Which customer type buys the most?

SELECT customer_type, COUNT(*) AS count_customer
FROM sales
GROUP BY customer_type
ORDER BY count_customer DESC;

---What is the gender of most of the customers?

SELECT gender, COUNT(*) AS count_gender
FROM sales
GROUP BY gender
ORDER BY count_gender DESC;

---What is the gender distribution per branch?

SELECT gender, branch, COUNT(*) AS count_gender
FROM sales
GROUP BY gender, branch
ORDER BY count_gender DESC;

---Which time of the day do customers give most ratings?

SELECT time_of_day,ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

---Which time of the day do customers give most ratings per branch?

SELECT branch, time_of_day, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;



---Which day of the week has the best avg ratings?

SELECT day_name, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;


---Which day of the week has the best average ratings per branch?

SELECT day_name, branch, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;