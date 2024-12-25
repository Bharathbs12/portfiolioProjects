-- sql Retail sales analysis - p1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
limit 10


SELECT 
    count(*) 
FROM retail_sales


SELECT * FROM retail_sales
WHERE transaction_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales


SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select *
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022


SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
    category,
	sum(total_sale) as net_sales,
	count(*) as total_orders
 from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select
    round(avg(age),2) as avg_age
	from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
   category,
   gender,
   count (*) as total_trans
 from retail_sales 
group by category,gender
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select
year,
month,
avg_sale
from
(
select 
   EXtract(YEAR from sale_date) as year,
   EXTRACT(MONTH from sale_date) as month,
   avg(total_sale) as avg_sale,
   rank() over(PARTITION by EXtract(YEAR from sale_date) order by avg(total_sale) desc) as rank 
   from retail_sales
group by 1,2
--order by 1,3 desc
)
where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
   customer_id,
   sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
  category,
  count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
   CASE 
       when extract(hour from sale_time) < 12 then 'morning'
	   when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	   else 'evening'
	   end as shift
from retail_sales
)
select 
    shift,
     count(*) as total_orders 
from hourly_sale
group by shift