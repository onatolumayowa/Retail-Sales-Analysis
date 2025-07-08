# Retail-Sales-Analysis

### Project Overview

This data analysis project aims to provide insight into the sales performance of a retail sales data over the past year. By analyzing various aspects of the sales data, we seek to identify trends, make data-driven recommendations, and gain a deeper understanding of the sales performance.

### Data Source

Sales Data: The primary dataset used for this analysis: [click here](https://github.com/onatolumayowa/Retail-Sales-Analysis/blob/main/Retail%20Sales%20Analysis_utf.csv)

### Tools

- Excel - Data Cleaning
- PostgreSQL - Data Analysis
- Power BI - Data Visualization

### Process

1. Data Loading - Downloaded the dataset from [Kaggle.com](https://www.kaggle.com/) then opened the csv file with Excel
2. Data Cleaning - Identify and remove any records with missing or null values using Excel
3. Data Analysis(EDA) - Use SQL to answer specific business questions and derive insights from the sales data
4. Creating reports - Loaded the data into power BI to create Dashboards

### Data Cleaning and Preparation

In the initial data preparation phase, I performed the following tasks:

1. Data loading and inspection.

2. Blank or missing values: I used the filter option to filter out blank rows. Then deleted the rows where quantiy, price_per_unit, cost, and total_sale were blank. I also checked the column age and filled the missing values with 0.

3. Spelling error: I checked for spelling Error then changed the column cogs to cost.

### Exploratory Data Analysis

EDA involved exploring the retail sales data to answer key questions such as:

- Calculate the total sales for each category
- Find the average age of customers who purchased items from the each category
- Find all transactions where the total_sale is greater than 1000
- Find the total number of transactions made by each gender in each category
- Calculate the average sale for each month. Find out best selling month in each year
- Find the top 5 customers based on the highest total sales
- Find the number of unique customers who purchased items from each category
- Create each shift and number of orders (Example Morning <12:00, Afternoon Between 12:00 & 17:00, Evening >17:00)

### Data Analysis

After Data cleaning in excel, I created a database in postgreSQL named retail_db.

To create a table retail_sales to store the data;

```sql
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
```

1. Calculate the total sales for each category

```sql
SELECT category, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC;
```

2. Find the average age of customers who purchased items from the each category

```sql
SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
GROUP BY 1;
```

3. Find all transactions where the total_sale is greater than 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

4. Find the total number of transactions made by each gender in each category

```sql
SELECT category, gender, COUNT(transactions_id)
FROM retail_sales
GROUP BY 1, 2
ORDER BY 3 DESC;
```

5. Calculate the average sale for each month. Find out best selling month in each year

```sql
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
```

6. Find the top 5 customers based on the highest total sales

```sql
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

7. Find the number of unique customers who purchased items from each category

```sql
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;
```

8. Create each shift and number of orders (Example Morning <12:00, Afternoon Between 12:00 & 17:00, Evening >17:00)

```sql
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
```

### Data Visualization

This is a power BI reports of the retail sales data.

### 



