
-- creating the sales, inventory, product, location
create table if not exists inventory(
Store_ID serial ,
Product_ID int,
Stock_On_Hand int
)

create table if not exists products(
Product_ID serial primary key,
Product_Name varchar(500),
Product_Category varchar(500),
Product_Cost float,
Product_Price float

)

create table if not exists sales(
Sale_ID serial primary key,
Date date,
Store_ID int,
Product_ID int,
Units int
)

create table if not exists stores (
Store_ID serial primary key,
Store_Name varchar(100),
Store_City varchar(100),
Store_Location varchar(50),
Store_Open_Date date
)

show tables;

-- \COPY inventory FROM 'C:\Users\DELL\Documents\learning\Binance\sql\capstone\inventory.csv' DELIMITER ',' CSV HEADER;
-- \COPY products FROM 'C:\Users\DELL\Documents\learning\Binance\sql\capstone\products.csv' DELIMITER ',' CSV HEADER;
-- \COPY stores FROM 'C:\Users\DELL\Documents\learning\Binance\sql\capstone\stores.csv' DELIMITER ',' CSV HEADER;
-- \COPY sales FROM 'C:\Users\DELL\Documents\learning\Binance\sql\capstone\sales.csv' DELIMITER ',' CSV HEADER;



select *
from sales;


select *
from products  ;


select *
from inventory ;


select *
from stores ;

 -- task 1 Which product categories drive the biggest profits? Is this the same across store 
locations?

SELECT
  p.Product_Category,
  SUM(p.Product_Price - p.Product_Cost) AS Profit
FROM
  products p
JOIN
  sales s ON p.Product_ID = s.Product_ID
GROUP BY
  p.Product_Category
ORDER BY
  Profit DESC;
  
 /* 
This query will calculate the profit for each product category by subtracting the cost from the price, 
and then group the results by category. 
The categories driving the biggest profits will be shown at the top.
*/
 
 -- task 2  How much money is tied up in inventory at the toy stores? How long will it last?
SELECT
  SUM(p.Product_Price * i.Stock_On_Hand) AS Inventory_Value,
  SUM(p.Product_Cost * i.Stock_On_Hand) AS Inventory_Cost
FROM
  products p
JOIN
  inventory i ON p.Product_ID = i.Product_ID
JOIN
  stores s ON i.Store_ID = s.Store_ID
WHERE
  s.Store_Name = 'Toy Store';

 /*
This query will calculate the total value and cost of the inventory at the toy stores by multiplying the product price and cost by the stock on hand.
It will give you the financial information about the inventory at the toy stores
*/
 
 
 -- task 3 Are sales being lost with out-of-stock products at certain locations?
 select *
 from stores;

 select *
 from inventory i ;

SELECT
  s.Store_Location,
  COUNT(*) AS Lost_Sales_Count
FROM
  sales s
LEFT JOIN
  inventory i ON s.Store_ID = i.Store_ID AND s.Product_ID = i.Product_ID
WHERE
  i.Stock_On_Hand  IS NULL
GROUP BY
  s.Store_Location;
/*
This query will identify the number of lost sales by checking if there is a match between sales and inventory based on store and product ID. 
If there is no stock available for a particular product at a specific store, it will count as a lost sale.
 The results will be grouped by store location.
*/