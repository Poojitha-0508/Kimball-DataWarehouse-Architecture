USE AppAnalytics;
--------------------------------------- Marketing Mart------------------------------------
-- 1. Which install source brings highest quality users (most revenue + longest sessions)?
SELECT	install_source, 
		COUNT(DISTINCT user_key) users_count, 
		ROUND(AVG(revenue_usd),2) revenue_usd, 
		ROUND(AVG(session_minutes),2) session_mins
FROM dw.vw_Marketing_mart
GROUP BY install_source
ORDER BY revenue_usd DESC, session_mins DESC;

-- 2. Which gender has highest purchase rate?
SELECT	gender, 
		COUNT(user_key) as purchased_users
FROM dw.vw_Marketing_mart
WHERE event_type='Purchase'
GROUP BY gender
ORDER BY COUNT(user_key) DESC;

-- 3. Which age group spends most time in apps?
SELECT	age_group, 
		COUNT(user_key) TotalUsers2, 
		AVG(session_minutes) session_mins
FROM dw.vw_Marketing_mart
GROUP BY age_group
ORDER BY session_mins DESC;
select distinct event_type from dw.vw_Marketing_mart 

-- 4. Which country has most active users?
SELECT	country,
		COUNT(*) ActiveUsers
FROM dw.vw_Marketing_mart
WHERE event_type!='Uninstall'
GROUP BY country
ORDER BY ActiveUsers DESC;

-- 5. Do premium users have longer sessions than free users?  // NO
SELECT 
	CASE
		WHEN is_premium=1 THEN 'Premium'
		WHEN is_premium=0 THEN 'Free'
	END AS 'Premium/Free', 
	SUM(session_minutes) session_mins
FROM dw.vw_Marketing_mart
GROUP BY is_premium
ORDER BY SUM(session_minutes) DESC;

-- 6. Which app category is most popular among female users?
SELECT	category, 
		COUNT(user_key) female_users
FROM dw.vw_Marketing_mart
WHERE gender='Female'
GROUP BY category
ORDER BY COUNT(user_key) DESC

-- 7. Weekend vs Weekday — when do users spend more money?
SELECT 
	CASE
		WHEN is_weekend=0 THEN 'WeekDay'
		WHEN is_weekend=1 THEN 'WeekEnd'
	END AS 'weekend/weekday',
	SUM(revenue_usd) AS revenue_usd
FROM dw.vw_Marketing_mart
GROUP BY is_weekend
ORDER BY SUM(revenue_usd) DESC

-- 8. Which city has highest revenue per user?
SELECT 
		city, 
		ROUND(SUM(revenue_usd),2) Revenue, 
		COUNT(DISTINCT user_key) users, 
		ROUND(SUM(revenue_usd)/NULLIF(COUNT(DISTINCT user_key),0),2) AS revenue_per_user
FROM dw.vw_Marketing_mart
GROUP BY city
ORDER BY revenue_per_user DESC;

-- 9. Monthly trend — which month has most downloads?
SELECT 
		month_name,
		month,
		COUNT(*) users_count
FROM dw.vw_Marketing_mart
WHERE event_type='Download'
GROUP BY month_name,month
ORDER BY month;

-- 10. Which platform (iOS/Android) users are more engaged?
SELECT 
		platform, 
		COUNT(user_key) users_count, 
		SUM(session_minutes) session_mins
FROM dw.vw_Marketing_mart
GROUP BY platform
ORDER BY SUM(session_minutes) DESC;

--------------------------------------- Finance Mart--------------------------------------
-- 1. Which app category generates highest total revenue?
SELECT 
		category, 
		SUM(revenue_usd) AS total_revenue
FROM dw.vw_Finance_mart
GROUP BY category
ORDER BY SUM(revenue_usd) DESC;

-- 2. Which region has highest revenue per purchase?
SELECT 
		region_name,
		SUM(revenue_usd) as Revenue,
		COUNT(CASE WHEN event_type='Purchase' THEN 1 END) AS purchases,
		ROUND(SUM(revenue_usd)/NULLIF(COUNT(CASE WHEN event_type='Purchase' THEN 1 END),0),2) revenue_per_purchase
FROM dw.vw_Finance_mart
GROUP BY region_name
ORDER BY revenue_per_purchase;

-- 3. Do premium users generate more revenue than free users?  //yes
SELECT 
	CASE
		WHEN is_premium=1 THEN 'Premium'
		WHEN is_premium=0 THEN 'Free'
	END AS 'Premium/Free',
	SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Finance_mart
GROUP BY is_premium
ORDER BY SUM(revenue_usd) DESC;

-- 4. Which quarter had best revenue performance?
SELECT 
		quarter, 
		SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Finance_mart
GROUP BY quarter
ORDER BY SUM(revenue_usd) DESC;

-- 5. Does giving more discount actually increase purchases?
WITH withDiscount as(
	SELECT 	
			SUM(revenue_usd) Revenue, 
			SUM(CASE WHEN event_type='Purchase' THEN 1 ELSE 0 END) purchases
	FROM dw.vw_Finance_mart
	WHERE discount_pct!=0
), withoutDiscount as(
	SELECT 
			SUM(revenue_usd) Revenue, 
			SUM(CASE WHEN event_type='Purchase' THEN 1 ELSE 0 END) purchases
	FROM dw.vw_Finance_mart
	WHERE discount_pct=0
)

SELECT 
		'With Discount' as 'With/Without Discount',
		purchases AS purchaseCount
FROM withDiscount
UNION ALL
SELECT 
		'Without Discount',
		purchases
FROM withoutDiscount;

-- 6. Which app has highest revenue despite being free (price=0)?
SELECT TOP 5
		app_name,
		SUM(revenue_usd) TotalRevenue
FROM dw.vw_Finance_mart
WHERE price_usd=0 AND event_type='Purchase'
GROUP BY app_name
ORDER BY TotalRevenue DESC;

-- 7. Which country contributes most revenue?
SELECT 
		country, 
		SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Finance_mart
GROUP BY country
ORDER BY SUM(revenue_usd) DESC;

-- 8. Year over year revenue growth trend?
SELECT 
		YEAR, 
		revenue_usd, 
		LAG(revenue_usd, 1, 0) OVER(ORDER BY YEAR) AS prevSales, 
		revenue_usd-LAG(revenue_usd, 1, 0) OVER(ORDER BY YEAR) AS RevenueGrowth
FROM (
		SELECT 
			YEAR, 
			SUM(revenue_usd) AS revenue_usd
		FROM dw.vw_Finance_mart
		GROUP BY YEAR
)T

-- 9. Which content rating category earns most?
SELECT
		content_rating, 
		SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Finance_mart
GROUP BY content_rating
ORDER BY Total_Revenue DESC;

-- 10. Which app version generates most revenue?
SELECT
		app_version, 
		SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Finance_mart
GROUP BY app_version
ORDER BY Total_Revenue DESC;

--------------------------------------- Product Mart--------------------------------------

-- 1. Which app has highest average rating?
SELECT	
		app_name,
		ROUND(AVG(RATING),2) avgRating
FROM dw.vw_Product_mart
WHERE rating IS NOT NULL
GROUP BY app_name
ORDER BY avgRating DESC;

-- 2. Which device type has longest average session?
SELECT 
		device_type, 
		AVG(session_minutes) AS session_minutes
FROM dw.vw_Product_mart
GROUP BY device_type
ORDER BY session_minutes DESC;

-- 3. Does app size affect user session duration
SELECT 
		CASE 
			 WHEN size_mb>400 THEN '401-500'
			 WHEN size_mb>300 THEN '301-400'
			 WHEN size_mb>200 THEN '201-300'
			 WHEN size_mb>100 THEN '101-200'
			 ELSE '<100'
		END AS sizeCategory,
		ROUND(AVG(session_minutes),2) AvgSessions
FROM dw.vw_Product_mart
GROUP BY
		CASE 
			 WHEN size_mb>400 THEN '401-500'
			 WHEN size_mb>300 THEN '301-400'
			 WHEN size_mb>200 THEN '201-300'
			 WHEN size_mb>100 THEN '101-200'
			 ELSE '<100'
		END


-- 4. Which platform (iOS/Android) gets better ratings?
SELECT	
		platform,
		ROUND(AVG(RATING),2) avgRating
FROM dw.vw_Product_mart
WHERE rating IS NOT NULL
GROUP BY platform
ORDER BY avgRating DESC;

-- 5. Do premium users rate apps higher than free users?
SELECT	
		CASE
			WHEN is_premium=1 THEN 'Premium'
			WHEN is_premium=0 THEN 'Free'
		END AS 'Premium/Free',
		ROUND(AVG(RATING),2) avgRating
FROM dw.vw_Product_mart
WHERE rating IS NOT NULL
GROUP BY is_premium
ORDER BY avgRating DESC;

-- 6. Which age group writes most detailed reviews?
SELECT 
		age_group, 
		AVG(review_text_len) AS AvgReviewLength
FROM dw.vw_Product_mart
GROUP BY age_group
ORDER BY AvgReviewLength DESC

-- 7. Which OS version has best user engagement?
SELECT 
		os_version, 
		AVG(session_minutes) AS AvgSessions
FROM dw.vw_Product_mart
GROUP BY os_version
ORDER BY AvgSessions DESC

-- 8. Which app category has longest sessions?
SELECT 
		category, 
		ROUND(AVG(session_minutes),2) session_mins
FROM dw.vw_Product_mart
WHERE rating IS NOT NULL
GROUP BY category
ORDER BY session_mins DESC;

-- 9. Does newer release year mean better ratings?
SELECT 
		year,
		ROUND(AVG(rating),2) avgRating,
		COUNT(DISTINCT app_name) AS totalApps
FROM dw.vw_Product_mart
WHERE rating IS NOT NULL
GROUP BY year
ORDER BY avgRating DESC;

-- 10. Which manufacturer users spend most time in apps?
SELECT 
		manufacturer,
		SUM(session_minutes) session_minutes
FROM dw.vw_Product_mart
GROUP BY manufacturer
ORDER BY session_minutes DESC

--------------------------------------- Regional Mart--------------------------------------
-- 1. Which region generates most total revenue?
SELECT 
		region_name, 
		SUM(revenue_usd) as Total_Revenue
FROM dw.vw_Regional_mart
GROUP BY region_name
ORDER BY Total_Revenue DESC;

-- 2. Which region has highest revenue per purchase?
SELECT 
		region_name,
		SUM(revenue_usd) TotalRevenue,
		COUNT(CASE WHEN event_type='Purchase' THEN 1 END) Purchases,
		ROUND(SUM(revenue_usd)/NULLIF(COUNT(CASE WHEN event_type='Purchase' THEN 1 END),0),2) revenue_per_purchase
FROM dw.vw_Regional_mart
GROUP BY region_name
ORDER BY revenue_per_purchase;

-- 3. Which app category dominates each region?
SELECT	
		category,
		SUM(CASE WHEN region_name='Asia Pacific' THEN 1 ELSE 0 END) 'Asia Pacific',
		SUM(CASE WHEN region_name='Europe' THEN 1 ELSE 0 END) 'Europe',
		SUM(CASE WHEN region_name='Latin America' THEN 1 ELSE 0 END) 'Latin America',
		SUM(CASE WHEN region_name='Middle East & Africa' THEN 1 ELSE 0 END) 'Middle East & Africa',
		SUM(CASE WHEN region_name='North America' THEN 1 ELSE 0 END) 'North America'
FROM dw.vw_Regional_mart
GROUP BY category;

-- 4. Which currency market has most purchases?
SELECT 
		store_currency, 
		SUM(CASE WHEN event_type='Purchase' THEN 1 ELSE 0 END) purchases
FROM dw.vw_Regional_mart
GROUP BY store_currency
ORDER BY purchases DESC

-- 5. Does tax rate affect purchase volume?
SELECT 
		CASE 
			 WHEN tax_rate_pct>10 THEN 'High'
			 WHEN tax_rate_pct>5 THEN 'Medium'
			 ELSE 'Low'
		END AS taxCategory,
		COUNT(CASE WHEN event_type='Purchase' THEN 1 END) Purchases
FROM dw.vw_Regional_mart
GROUP BY 
		CASE 
			 WHEN tax_rate_pct>10 THEN 'High'
			 WHEN tax_rate_pct>5 THEN 'Medium'
			 ELSE 'Low'
		END;

-- 6. Which country within each region spends most?
SELECT	
		country,
		SUM(CASE WHEN region_name='Asia Pacific' THEN revenue_usd ELSE 0 END) 'Asia Pacific',
		SUM(CASE WHEN region_name='Europe' THEN revenue_usd ELSE 0 END) 'Europe',
		SUM(CASE WHEN region_name='Latin America' THEN revenue_usd ELSE 0 END) 'Latin America',
		SUM(CASE WHEN region_name='Middle East & Africa' THEN revenue_usd ELSE 0 END) 'Middle East & Africa',
		SUM(CASE WHEN region_name='North America' THEN revenue_usd ELSE 0 END) 'North America'
FROM dw.vw_Regional_mart
GROUP BY country;

-- 7. Which region has most premium users?
SELECT 
		region_name, 
		SUM(CASE WHEN is_premium=1 THEN 1 ELSE 0 END) 'Premium users'
FROM dw.vw_Regional_mart
GROUP BY region_name
ORDER BY [Premium users] DESC;

-- 8. Quarterly revenue trend by region?
SELECT 
		region_name,
		SUM(CASE WHEN quarter=1 THEN revenue_usd ELSE 0 END) '1ST QUARTER',
		SUM(CASE WHEN quarter=2 THEN revenue_usd ELSE 0 END) '2ND QUARTER',
		SUM(CASE WHEN quarter=3 THEN revenue_usd ELSE 0 END) '3RD QUARTER',
		SUM(CASE WHEN quarter=4 THEN revenue_usd ELSE 0 END) '4TH QUARTER'
FROM dw.vw_Regional_mart
GROUP BY region_name;

-- 9. Which platform is preferred in each region?
SELECT 
		region_name,
		SUM(CASE WHEN platform='Android' THEN 1 ELSE 0 END) 'Android users',
		SUM(CASE WHEN platform='iOS' THEN 1 ELSE 0 END) 'iOS users',
		SUM(CASE WHEN platform='Both' THEN 1 ELSE 0 END) as 'Android & iOS users'
FROM dw.vw_Regional_mart
GROUP BY region_name;

-- 10. Which region gives most discounts?
SELECT 
		region_name,
		SUM(CASE WHEN discount_pct!=0 THEN 1 ELSE 0 END) AS discounts
FROM dw.vw_Regional_mart
GROUP BY region_name
order by discounts DESC;

--------------------------------------- Device Mart --------------------------------------

-- 1. Which device type has longest average session?
SELECT 
		device_type, 
		AVG(session_minutes) AS session_minutes
FROM dw.vw_Device_mart
GROUP BY device_type
ORDER BY session_minutes DESC;

-- 2. Which manufacturer has lowest uninstall rate?
SELECT	
		manufacturer, 
		SUM(CASE WHEN event_type='Uninstall' THEN 1 ELSE 0 END) UninstallRate
FROM dw.vw_Device_mart
GROUP BY manufacturer
ORDER BY UninstallRate;

-- 3. Does screen size affect revenue generation?
SELECT 
		screen_size_inch,
		SUM(revenue_usd) TotalRevenue
FROM dw.vw_Device_mart
GROUP BY screen_size_inch
ORDER BY TotalRevenue DESC;

-- 4. Which OS version has best average ratings?
SELECT 
    os_version,
    ROUND(AVG(rating),2) as avg_rating,
    ROUND(AVG(session_minutes),2) as avg_session
FROM dw.vw_Device_mart
WHERE rating IS NOT NULL
GROUP BY os_version
ORDER BY avg_rating DESC

-- 5. Which device type generates most revenue?
SELECT 
		device_type, 
		SUM(revenue_usd) AS TotalRevenue
FROM dw.vw_Device_mart
GROUP BY device_type
ORDER BY TotalRevenue DESC;

-- 6. Which age group uses which device most?
SELECT 
		age_group,
		SUM(CASE WHEN device_type='PC' THEN 1 ELSE 0 END) 'PC users',
		SUM(CASE WHEN device_type='Smartphone' THEN 1 ELSE 0 END) 'Smartphone users',
		SUM(CASE WHEN device_type='Smartwatch' THEN 1 ELSE 0 END) as 'Smartwatch users',
		SUM(CASE WHEN device_type='Tablet' THEN 1 ELSE 0 END) as 'Tablet users',
		SUM(CASE WHEN device_type IS NULL THEN 1 ELSE 0 END) as 'Unknown users'
FROM dw.vw_Device_mart
GROUP BY age_group

-- 7. Do premium users use specific devices more?
SELECT 
		device_type,
		COUNT(*) users
FROM dw.vw_Device_mart
WHERE is_premium=1
GROUP BY device_type
ORDER BY users DESC;

-- 8. Which app category is most popular on tablets?
SELECT 
		category, 
		COUNT(*) users
FROM dw.vw_Device_mart
WHERE device_type='Tablet'
GROUP BY category;

-- 9. Which manufacturer users give highest ratings?
SELECT 
    manufacturer,
    ROUND(AVG(rating),2) as avg_rating,
    COUNT(CASE WHEN event_type='Review' THEN 1 END) AS reviews
FROM dw.vw_Device_mart
WHERE rating IS NOT NULL
GROUP BY manufacturer
ORDER BY avg_rating DESC

-- 10. Which device type has most purchase events?
SELECT 
		device_type,
		SUM(CASE WHEN event_type='Purchase' THEN 1 ELSE 0 END) purchases
FROM dw.vw_Device_mart
GROUP BY device_type
ORDER BY purchases DESC;

--------------------------------------- Executive Mart --------------------------------------

-- 1. What is year over year revenue growth?
SELECT 
		YEAR, 
		revenue_usd, 
		LAG(revenue_usd, 1, 0) OVER(ORDER BY YEAR) AS prevSales, 
		revenue_usd-LAG(revenue_usd, 1, 0) OVER(ORDER BY YEAR) AS RevenueGrowth
FROM (
		SELECT 
			YEAR, 
			SUM(revenue_usd) AS revenue_usd
		FROM dw.vw_Executive_mart
		GROUP BY YEAR
)T

-- 2. Premium vs free users — who drives more revenue?
SELECT 
		CASE
			WHEN is_premium=1 THEN 'Premium'
			WHEN is_premium=0 THEN 'Free'
		END AS 'Premium/Free', 
		SUM(revenue_usd) Total_Revenue
FROM dw.vw_Executive_mart
GROUP BY is_premium
ORDER BY Total_Revenue DESC;

-- 3. Which app category is most valuable overall?
SELECT 
		category, 
		SUM(revenue_usd) Total_Revenue
FROM dw.vw_Executive_mart
GROUP BY category
ORDER BY Total_Revenue DESC;

-- 4. Which region contributes most to business?
SELECT 
		region_name, 
		SUM(revenue_usd) Total_Revenue
FROM dw.vw_Executive_mart
GROUP BY region_name
ORDER BY Total_Revenue DESC;

-- 5. Weekend vs weekday overall performance?
SELECT 
	CASE
		WHEN is_weekend=0 THEN 'WeekDay'
		WHEN is_weekend=1 THEN 'WeekEnd'
	END AS 'weekend/weekday',
	SUM(revenue_usd) AS revenue_usd
FROM dw.vw_Executive_mart
GROUP BY is_weekend
ORDER BY SUM(revenue_usd) DESC;

-- 6. Which platform drives most business value?
SELECT 
		platform, 
		SUM(revenue_usd) Total_Revenue
FROM dw.vw_Executive_mart
GROUP BY platform
ORDER BY Total_Revenue DESC;

-- 7. Monthly revenue trend across all years?
SELECT 
		month_name, 
		MONTH,
		revenue_usd, 
		LAG(revenue_usd, 1, 0) OVER(ORDER BY month_name) AS prevSales, 
		revenue_usd-LAG(revenue_usd, 1, 0) OVER(ORDER BY month_name) AS RevenueGrowth
FROM (
		SELECT 
			month_name,
			MONTH,
			SUM(revenue_usd) AS revenue_usd
		FROM dw.vw_Executive_mart
		GROUP BY month_name,MONTH
)T
ORDER BY MONTH;

-- 8. Which country is most valuable market?
SELECT 
		country, 
		SUM(revenue_usd) Total_Revenue
FROM dw.vw_Executive_mart
GROUP BY country
ORDER BY Total_Revenue DESC;

-- 9. Overall app rating trend by year?
SELECT 
		year,
		ROUND(AVG(rating),2) avgRating,
		COUNT(DISTINCT app_name) AS totalApps
FROM dw.vw_Executive_mart
WHERE rating IS NOT NULL
GROUP BY year
ORDER BY avgRating DESC;

-- 10. What percentage of events lead to purchases?'
SELECT 
		COUNT(CASE WHEN event_type='Purchase' THEN 1 END) purchases,
		COUNT(*) AS totalEvents,
		ROUND(COUNT(CASE WHEN event_type='Purchase' THEN 1 END) *100 /NULLIF(COUNT(event_type),0),2) 'Purchase%'
FROM dw.vw_Executive_mart;