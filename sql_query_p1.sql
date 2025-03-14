--SQL REATIL SALES ANALYSIS
CREATE DATABASE sql_project_p1;

 --create table
 DROP TABLE IF EXISTS retail_sales;
 CREATE TABLE retail_sales(
 transactions_id INT PRIMARY KEY,	
 sale_date DATE,
 sale_time TIME,
 customer_id INT,	
 gender	VARCHAR(10),
 age INT,	
 category VARCHAR(20),
 quantiy INT,	
 price_per_unit FLOAT,
 cogs FLOAT,
 total_sale FLOAT
)

SELECT * FROM retail_sales;
SELECT count(*) FROM retail_sales;

select count(distinct(category))
from retail_sales;

--dealing null values  [DATA CLEANING]
select *
from retail_sales
where transactions_id is NULL;

select *
from retail_sales
where 
    transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;

--deleting null values
delete from retail_sales
where 
    transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantiy is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;
	
select count(*)
from retail_sales;

--DATA EXPLORATION

--how many sales?
select count(*) as total_sales
from retail_sales;

--how many customers?
select count(distinct(customer_id)) as no_of_cust
from retail_sales;

--how many categories?
select count(distinct(category)) 
from retail_sales;


--DATA ANALYSIS AND BUSINESS KEY ANALYSIS
--1.retrieve all columns for sales on '2022-11-05'
select *
from retail_sales
where sale_date='2022-11-05';

--2.retrieve all transactions  category is clothing and quantity is more than 10 in month of n0v-2022
   --select category,SUM(quantiy)
   --from retail_sales 
   --where category='Clothing'
    --group by category;
--one approach
select *
from retail_sales
where category='Clothing' and quantiy>1 and sale_date between '2022-11-01' and '2022-11-30';
--second approach
select *
from retail_sales
where category='Clothing' and quantiy>=4 and to_char(sale_date,'yyyy-mm')='2022-11';

--3.calculate the total-sales for each category
select category,sum(total_sale) as total_sales
from retail_sales
group by category;

--4.find avg age of customers who purchased items from 'beauty' category
select category,round(avg(age),2)
from retail_sales
--where category='Beauty'
group by category;

--5.find all transaction where total_sale>1000
select *
from retail_sales
where total_sale>1000;

--6.fing total no.of trans by each gender
select gender,count(*)
from retail_sales
group by gender;

   --made by gender in each category
select category,gender,count(*)
from retail_sales
group by category,gender;

--7.calculate avg sale for each month.find best selling month in each year
select year,month,avg_sales from
( 
select 
  extract(year from sale_date) as year, 
  extract(month from sale_date) as month,
  avg(total_sale) as avg_sales,
  rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2) as t1
where rank=1;


--8.find top 5 customers based on highest total sales
select distinct(customer_id),sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;


--9.find the no.of unique customers who purchased items frm each category
select category,count(distinct(customer_id))
from retail_sales
group by category;


--10.create each shift and no.of orders(ex:morning<12 ,aft b/w 12 and 17 ,evng>17)
select count(transactions_id),shift
from
( 
select *,
  CASE
    WHEN extract(hour from sale_time)<12 THEN 'morning'
	WHEN extract(hour from sale_time) between 12 and 17 THEN 'afternoon'
    ELSE 'evening'
  END as shift
from retail_sales) as t1
group by shift;



--End of project