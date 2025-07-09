# Retail-Sales-Analysis

### Project Overview

This data analysis project aims to provide insight into the sales performance of a retail sales data over the past year. By analyzing various aspects of the sales data, we seek to identify trends, make data-driven recommendations, and gain a deeper understanding of the sales performance.

![Dashboard report](https://github.com/user-attachments/assets/3e87cf83-76d8-4462-8df9-9e5a4490a7d0)


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

- Calculate the total sales for each category

```sql
SELECT category, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC;
```

- Find the average age of customers who purchased items from the each category

```sql
SELECT category, ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
GROUP BY 1;
```

- Find all transactions where the total_sale is greater than 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

- Find the total number of transactions made by each gender in each category

```sql
SELECT category, gender, COUNT(transactions_id)
FROM retail_sales
GROUP BY 1, 2
ORDER BY 3 DESC;
```

- Calculate the average sale for each month. Find out best selling month in each year

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

- Find the top 5 customers based on the highest total sales

```sql
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

- Find the number of unique customers who purchased items from each category

```sql
SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;
```

- Create each shift and number of orders (Example Morning <12:00, Afternoon Between 12:00 & 17:00, Evening >17:00)

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

After EDA process, I loaded the data into Power BI and perform the following tasks;

1. Created a Date table and marked it as a Date table. Also i perfomed a modelling task by creating a many to one relationship between sql retail sales and Date table, joining the sale_date column with the Date column.

```power BI
Date = CALENDAR(DATE(YEAR(MIN('sql retail sales'[sale_date])), 1, 1), DATE(YEAR(MAX('sql retail sales'[sale_date])), 12, 31))
```

2. I then added new columns from the Date table.

```power BI
Year = YEAR('Date'[Date])
```

```power BI
Month No = MONTH('Date'[Date])
```

```power BI
Month Name = FORMAT('Date'[Date], "mmmm")
```

```power BI
Day = DAY('Date'[Date])
```

```power BI
Weekday Number = WEEKDAY('Date'[Date], 2)
```

```power BI
Weekday Name = FORMAT('Date'[Date], "DDD")
```

3. Using DAX function, I craeted key measures;

```power BI
Total sales for the category Beauty = CALCULATE(SUM('sql retail sales'[total_sale]), 'sql retail sales'[category] = "Beauty")
```

```power BI
Total sales for the category clothing = CALCULATE(SUM('sql retail sales'[total_sale]), 'sql retail sales'[category] = "Clothing")
```

```power BI
Total sales for the category Electronics = CALCULATE(SUM('sql retail sales'[total_sale]), 'sql retail sales'[category] = "Electronics")
```

```power BI
No of customers = DISTINCTCOUNT('sql retail sales'[customer_id])
```

```power BI
No of orders = COUNTA('sql retail sales'[customer_id])
```

4. Created a Dashboard [Dashboard view](https://github.com/onatolumayowa/Retail-Sales-Analysis/blob/main/Dashboard%20report.png)


### Results/Findings

1. Some transactions had a total sale amount greater than 1000, indicating premium purchases.
2. The analysis identifies the top-spending customers and the most popular product categories.
3. The category that made the most sale is "Electronics".
4. The average age of customers who purchased items from each category are between the age of range 40-42.
5. The best selling month in year 2022 and 2023 is july and feburary respectively.


### Recommendations

After analyzing and exploring the data, I observed most sales were made in the time >17;00. To imrove the sales made for each category, 
   



