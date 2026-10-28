create database coffee_DB;
use coffee_db;

create table coffee_sales(
coffee_id int primary key,
order_id int,
coffee_name_id varchar(50),
quantity int,
order_date date,
order_time time,
unit_price float,
total_price float,
coffee_size varchar(50),
coffee_category varchar(50),
coffee_ingredients varchar(200),
coffee_name varchar(50)
);

desc coffee_sales;

show variables like "secure_file_priv";
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/coffee_sales.csv'
INTO TABLE coffee_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    coffee_id,
    order_id,
    coffee_name_id,
    quantity,
    @order_date,
    order_time,
    unit_price,
    total_price,
    coffee_size,
    coffee_category,
    coffee_ingredients,
    coffee_name
)
SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d');

#---------------------- KPI's Requirements ------------------
---- To get Total Revenue
select ROUND(SUM(total_price),2) as Total_Revenue 
from coffee_sales;

--- Average Order Value
SELECT ROUND(SUM(total_price) /COUNT(distinct order_id),2) as AVG_ORDER_VALUE 
from coffee_sales;

---- Total coffee_Sold
SELECT SUM(quantity) as Total_coffee_Sold 
from coffee_Sales;

--- Total Orders Placed
SELECT COUNT(DISTINCT order_id) as Total_Orders from coffee_sales;

--- Average coffee Sold Per Order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS Average_coffee_Per_Order
FROM coffee_sales;

------------------------- Charts Requirements ------------------------
select * from coffee_sales;

 ----- Daily Trend for total Orders
SELECT DAYNAME(order_date) AS order_day,COUNT(DISTINCT order_id) AS Total_Orders
FROM coffee_sales
GROUP BY DAYNAME(order_date)
order by Total_Orders desc ;

------ Monthly Trend for Total Orders
SELECT MonthName(order_date) AS Month_Name,COUNT(DISTINCT order_id) AS Total_Orders
FROM coffee_sales
GROUP BY MonthName(order_date)
ORDER BY Total_Orders DESC;

----- % of Sales as coffee Category
SELECT coffee_category,ROUND(SUM(total_price),2) as Total_Revenue, ROUND(SUM(total_price) * 100/(SELECT SUM(total_price) from coffee_sales),2)  as PCT
from coffee_sales
GROUP BY coffee_category
ORDER BY PCT DESC ;

----- % of Sales BY coffee Size
SELECT coffee_size,ROUND(SUM(total_price),2) as Total_Revenue, ROUND(SUM(total_price) * 100/(SELECT SUM(total_price) from coffee_sales),2)  as PCT
from coffee_sales
GROUP BY coffee_size
ORDER BY PCT DESC ;

---- Total coffee sold by coffee category;
SELECT coffee_category,SUM(quantity) AS Total_Quantity_Sold
FROM coffee_sales
GROUP BY coffee_category
ORDER BY Total_Quantity_Sold DESC ;

--- Top 5 coffee by revenue
SELECT coffee_name,SUM(total_price) as Total_Revenue
FROm coffee_sales
GROUP BY coffee_name
ORDER BY  Total_Revenue DESC
LIMIT 5;

----- Bottom 5 coffee by Revenue
SELECT coffee_name,ROUND(SUM(total_price),2) as Total_Revenue
FROM coffee_sales
GROUP BY coffee_name
ORDER BY  Total_Revenue ASC
LIMIT 5;

--- Top 5 Pizzas by Quantity
SELECT coffee_name,SUM(quantity) as Total_coffee_Sold
FROM coffee_sales
GROUP BY coffee_name
ORDER BY Total_coffee_Sold DESC
LIMIT 5;

--- Bottom 5 coffee by Quantity
SELECT coffee_name,SUM(quantity) as Total_coffee_Sold
FROM coffee_sales
GROUP BY coffee_name
ORDER BY Total_coffee_Sold ASC
LIMIT 5;

--- Top 5 pcoffee by Total Orders
SELECT coffee_name,COUNT(DISTINCT order_id) as Total_Orders
From coffee_sales
GROUP BY coffee_name
ORDER BY Total_Orders DESC
LIMIT 5 ;

--- Bottom 5 coffee by Total Orders
SELECT coffee_name,COUNT(DISTINCT order_id) as Total_Orders
From coffee_sales
GROUP BY coffee_name
ORDER BY Total_Orders ASC
LIMIT 5 ;

