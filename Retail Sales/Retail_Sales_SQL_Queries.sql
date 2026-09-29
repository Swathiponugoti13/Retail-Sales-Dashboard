--Monthly Revenue
WITH M AS (
 SELECT YEAR(Date) Y, MONTH(Date) M, SUM([Total Amount]) Revenue
 FROM Retail_Sales GROUP BY YEAR(Date), MONTH(Date)
)
SELECT *, LAG(Revenue) OVER(ORDER BY Y,M) Prev,
 CASE WHEN Revenue > LAG(Revenue) OVER(ORDER BY Y,M)
 THEN 'Increase' ELSE 'Decrease' END Trend
FROM M;



--Category Ranking
WITH C AS (
 SELECT [Product Category], SUM([Total Amount]) Revenue
 FROM Retail_Sales GROUP BY [Product Category]
)
SELECT *, DENSE_RANK() OVER(ORDER BY Revenue DESC) Rank
FROM C;



--Top Customers
WITH C AS (
 SELECT [Customer ID], SUM([Total Amount]) Spending
 FROM Retail_Sales GROUP BY [Customer ID]
)
SELECT *, DENSE_RANK() OVER(ORDER BY Spending DESC) Rank
FROM C;



--Age Group
SELECT
 CASE WHEN Age<=25 THEN 'Youth'
      WHEN Age<=35 THEN 'Young Adults'
      WHEN Age<=49 THEN 'Adults'
      ELSE 'Seniors' END Age_Group,
 SUM([Total Amount]) Revenue
FROM Retail_Sales
GROUP BY CASE WHEN Age<=25 THEN 'Youth'
              WHEN Age<=35 THEN 'Young Adults'
              WHEN Age<=49 THEN 'Adults'
              ELSE 'Seniors' END;



--Gender Contribution
WITH G AS (
 SELECT Gender, SUM([Total Amount]) Revenue
 FROM Retail_Sales GROUP BY Gender
)
SELECT *, Revenue*100/SUM(Revenue) OVER() Percentage
FROM G;



--Customer vs Average
WITH C AS (
 SELECT [Customer ID], SUM([Total Amount]) Spending
 FROM Retail_Sales GROUP BY [Customer ID]
)
SELECT *, CASE WHEN Spending > AVG(Spending) OVER()
 THEN 'Above Average' ELSE 'Below Average' END Status
FROM C;



--Running Revenue
WITH M AS (
 SELECT MONTH(Date) M, SUM([Total Amount]) Revenue
 FROM Retail_Sales GROUP BY MONTH(Date)
)
SELECT *, SUM(Revenue) OVER(ORDER BY M) Running_Revenue
FROM M;



--Top 3 Customers by Gender
WITH C AS (
 SELECT Gender,[Customer ID],SUM([Total Amount]) Spending
 FROM Retail_Sales GROUP BY Gender,[Customer ID]
),
R AS (
 SELECT *,ROW_NUMBER() OVER(
 PARTITION BY Gender ORDER BY Spending DESC) Rank
 FROM C
)
SELECT * FROM R WHERE Rank<=3;



--Category Monthly Trend
WITH M AS (
 SELECT [Product Category],MONTH(Date) M,SUM([Total Amount]) Revenue
 FROM Retail_Sales GROUP BY [Product Category],MONTH(Date)
)
SELECT *,LAG(Revenue) OVER(
 PARTITION BY [Product Category] ORDER BY M) Prev_Revenue
FROM M;



--Transaction Segmentation
WITH T AS (
 SELECT *,NTILE(4) OVER(ORDER BY [Total Amount] DESC) Q
 FROM Retail_Sales
)
SELECT *,CASE WHEN Q=1 THEN 'High Value'
 ELSE 'Regular' END Segment
FROM T;