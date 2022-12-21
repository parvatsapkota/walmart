--Super Bowl: 12-Feb-10, 11-Feb-11, 10-Feb-12, 8-Feb-13
--Labour Day: 10-Sep-10, 9-Sep-11, 7-Sep-12, 6-Sep-13
--Thanksgiving: 26-Nov-10, 25-Nov-11, 23-Nov-12, 29-Nov-13
--Christmas: 31-Dec-10, 30-Dec-11, 28-Dec-12, 27-Dec-13


SELECT *
FROM PortfolioProject.dbo.Walmart


--SELECT [Date],CONVERT(date,[Date])
--FROM PortfolioProject.dbo.Walmart


ALTER TABLE PortfolioProject.dbo.Walmart
Add new_date nvarchar(50)


UPDATE PortfolioProject.dbo.Walmart 
SET new_date = CONVERT(date,[Date])

SELECT new_date
FROM PortfolioProject.dbo.Walmart

--Store vs Sale
SELECT Store, sum(weekly_sales) as total_sales
FROM PortfolioProject.dbo.Walmart
GROUP BY Store
ORDER BY total_sales DESC

--How does the sales look like over time?
SELECT new_date, sum(weekly_sales) as sales_weekly_walmart
FROM PortfolioProject.dbo.Walmart
GROUP BY new_date
ORDER BY new_date ASC


--Which holiday resulted in the greatest sales?:Aggregate
WITH cte_superbowl as
		(SELECT new_date, sum(weekly_sales) as sales1
		FROM PortfolioProject.dbo.Walmart
		GROUP BY new_date
		HAVING new_date IN ('2010-02-12','2011-02-11','2012-02-10','2013-02-08')
		),
		cte_laborday as
		(SELECT new_date, sum(weekly_sales) as sales2
		FROM PortfolioProject.dbo.Walmart
		GROUP BY new_date
		HAVING new_date IN ('2010-09-10','2011-09-09','2012-09-07','2013-09-06')
		),
		cte_thanksgiving as
		(SELECT new_date, sum(weekly_sales) as sales3
		FROM PortfolioProject.dbo.Walmart
		GROUP BY new_date
		HAVING new_date IN ('2010-11-26','2011-11-25','2012-11-23','2013-11-29')
		),
		cte_christmas as
		(SELECT new_date, sum(weekly_sales) as sales4
		FROM PortfolioProject.dbo.Walmart
		GROUP BY new_date
		HAVING new_date IN ('2010-12-31','2011-11-30','2012-12-28','2013-12-27')
		)
SELECT sum(sales1) as sales_superbowl, sum(sales2) as sales_laborday,sum(sales3) as sales_thanksgiving,sum(sales4) as sales_christmas
FROM cte_superbowl,cte_laborday,cte_thanksgiving,cte_christmas

--Which holiday resulted in the greatest sales?:Breakdown a/c to store
WITH cte_superbowl as
		(SELECT store,sum(weekly_sales) as sales1
		FROM PortfolioProject.dbo.Walmart
		WHERE new_date IN ('2010-02-12','2011-02-11','2012-02-10','2013-02-08')
		GROUP BY store
		),
		cte_laborday as
		(SELECT store,sum(weekly_sales) as sales2
		FROM PortfolioProject.dbo.Walmart
		WHERE new_date IN ('2010-09-10','2011-09-09','2012-09-07','2013-09-06')
		GROUP BY store

		),
		cte_thanksgiving as
		(SELECT store, sum(weekly_sales) as sales3
		FROM PortfolioProject.dbo.Walmart
		WHERE new_date IN ('2010-11-26','2011-11-25','2012-11-23','2013-11-29')
		GROUP BY store

		),
		cte_christmas as
		(SELECT store, sum(weekly_sales) as sales4
		FROM PortfolioProject.dbo.Walmart
		WHERE new_date IN ('2010-12-31','2011-11-30','2012-12-28','2013-12-27')
		GROUP BY store
		)
SELECT cte_superbowl.store,cte_superbowl.sales1 as sales_superbowl, cte_laborday.sales2 as sales_laborday,cte_thanksgiving.sales3 as sales_thanksgiving,cte_christmas.sales4 as sales_christmas
FROM cte_superbowl
JOIN cte_laborday
	ON cte_superbowl.store = cte_laborday.store
JOIN cte_thanksgiving
	ON cte_thanksgiving.store = cte_laborday.store
JOIN cte_christmas
	ON cte_christmas.store = cte_laborday.store

