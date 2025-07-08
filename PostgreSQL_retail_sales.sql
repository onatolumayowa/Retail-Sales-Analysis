DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,	
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),	
quantiy INT,
price_per_unit FLOAT,	
cost FLOAT,	
total_sale FLOAT
);

SELECT *
FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT category, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC;

SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
GROUP BY 1;

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

SELECT category, gender, COUNT(transactions_id)
FROM retail_sales
GROUP BY 1, 2
ORDER BY 3 DESC;

WITH CTE_Example AS
(
SELECT EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale, 
		RANK() 
OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
)
SELECT year, month, avg_sale
FROM CTE_Example 
WHERE rank = 1;

SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;

WITH CTE_Example AS
(
SELECT *,
		CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 Then 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 Then 'Afternoon'
ELSE 'Evening'
END As shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS no_of_orders
FROM CTE_Example
GROUP BY shift
ORDER BY COUNT(*) DESC;