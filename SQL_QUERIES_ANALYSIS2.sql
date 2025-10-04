USE RETAILPROJECT;

SELECT *  FROM  Data_retail;

------------------------------------------------------------------------------------------------------

--1 Identifies products with prices higher than the average price within their category.

 SELECT DR.Product_Name, DR.Category, DR.Price
FROM Data_retail DR
JOIN 
(SELECT  Category, AVG(Price) AS AvgCategoryPrice
FROM Data_retail
GROUP BY Category) AS CatAvg
ON DR.Category = CatAvg.Category
WHERE DR.Price > CatAvg.AvgCategoryPrice;



----------------------------------------------------------------------------------------------------

--2 Finding Categories with Highest Average Rating Across Products

SELECT Category,Product_Name, AVG(Rating) AS AvgRating 
FROM Data_retail
GROUP BY Category,Product_Name
ORDER BY AvgRating DESC;






---------------------------------------------------------------------------------------------------------------

--3 Find the most reviewed product in each warehouse


 SELECT  Product_Name, Warehouse,Category,Reviews
 from (SELECT  Product_Name, Warehouse,Category,Reviews,
dense_rank() OVER (PARTITION BY Warehouse ORDER BY Reviews DESC) AS rn
FROM Data_retail) as new2
where rn=1;

--------------------------------------------------------------------------------------------------------

--4 Find products that have higher-than-average prices within their category, along with their discount and supplier.


SELECT DR.Product_Name,DR.Discount, DR.Category, DR.Price,DR.Supplier
FROM Data_retail DR
JOIN 
(SELECT  Category, AVG(Price) AS AvgCategoryPrice
FROM Data_retail
GROUP BY Category) AS CatAvg
ON DR.Category = CatAvg.Category
WHERE DR.Price > CatAvg.AvgCategoryPrice;

-------------------------------------------------------------------------------------------------------

--5 Query to find the top 2 products with the highest average rating in each category


SELECT  product_name,Category,AverageRating
from(SELECT  product_name,Category, avg(rating) as AverageRating, 
DENSE_RANK() OVER (PARTITION BY Category ORDER BY avg(rating) DESC) AS rn
FROM Data_retail
group by Product_Name, Category) as new
where rn<=2;


----------------------------------------------------------------------------------------------------

--6 Analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc)

SELECT 
    Category,
    Return_Policy,
    COUNT(*) AS ProductCount,
    AVG([Stock_Quantity]) AS AvgStock,
    SUM([Stock_Quantity]) AS TotalStock,
    AVG(Rating) AS AvgRating,
    SUM(Rating * [Stock_Quantity]) * 1.0 / (SUM([Stock_Quantity])) AS WeightedAvgRating
FROM Data_retail
GROUP BY Return_Policy,Category;




