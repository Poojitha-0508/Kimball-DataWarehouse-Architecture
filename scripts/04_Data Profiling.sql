USE AppAnalytics;

---------------------------------------------------------------------------------------------------------
---------------------------------------------***DATA PROFILING***----------------------------------------
---------------------------------------------------------------------------------------------------------

----------------------------stg.dim_app---------------------------
SELECT TOP 10 * FROM Stg.dim_app;

SELECT COUNT(*) AS totalRows
FROM Stg.dim_app;

--app name
SELECT DISTINCT app_name COLLATE Latin1_General_CS_AS as appNames
FROM Stg.dim_app

SELECT app_name, COUNT(*) as count
FROM Stg.dim_app
GROUP BY app_name
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_app
WHERE app_name IS NULL OR LTRIM(RTRIM(app_name))='';

-- category
SELECT DISTINCT category
FROM Stg.dim_app

SELECT category, COUNT(*) as count
FROM Stg.dim_app
GROUP BY category
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_app
WHERE category IS NULL OR LTRIM(RTRIM(category))='';

-- developer 
SELECT DISTINCT developer as developers
FROM Stg.dim_app

SELECT developer, COUNT(*) as count
FROM Stg.dim_app
GROUP BY developer
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_app
WHERE developer IS NULL OR LTRIM(RTRIM(developer))='';

-- platform 
SELECT DISTINCT platform COLLATE Latin1_General_CS_AS as platforms
FROM Stg.dim_app

SELECT platform, COUNT(*) as count
FROM Stg.dim_app
GROUP BY platform
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_app
WHERE platform IS NULL OR LTRIM(RTRIM(platform))='';

-- price_usd
SELECT 
		COUNT(*) AS TotalRows,
		COUNT(price_usd) as non_null_count,
		COUNT(*)-COUNT(price_usd) as null_count,
		MAX(price_usd) as max_value,
		MIN(price_usd) as min_value,
		AVG(price_usd) as avg_value
FROM Stg.dim_app

-- content rating
SELECT DISTINCT content_rating 
FROM Stg.dim_app;

SELECT content_rating, COUNT(*) as count
FROM Stg.dim_app
GROUP BY content_rating
ORDER BY count DESC;

SELECT COUNT(*) as nulls
FROM Stg.dim_app
WHERE content_rating IS NULL OR LTRIM(RTRIM(content_rating)) = '';

-- release_year
SELECT DISTINCT release_year
FROM Stg.dim_app;

SELECT release_year, COUNT(*) as count
FROM Stg.dim_app
GROUP BY release_year
ORDER BY count DESC;

SELECT max(release_year), min(release_year),
       count(*), count(*)-count(release_year) as nulls
FROM Stg.dim_app

-- size_mb
SELECT 
		COUNT(*) AS TotalRows,
		COUNT(size_mb) as non_null_count,
		COUNT(*)-COUNT(size_mb) as null_count,
		MAX(size_mb) as max_value,
		MIN(size_mb) as min_value,
		AVG(size_mb) as avg_value
FROM Stg.dim_app


-----------------------------Stg.dim_date------------------------------

SELECT TOP 10 * FROM Stg.dim_date;

SELECT COUNT(*) AS totalRows
FROM Stg.dim_date;

SELECT MAX(full_date) as latest_date,
       MIN(full_date) as earliest_date
FROM Stg.dim_date;

SELECT COUNT(*)-COUNT(full_date) AS nulls
FROM Stg.dim_date;

SELECT day,COUNT(*) count
FROM Stg.dim_date
GROUP BY day
ORDER BY day;

SELECT month,month_name,COUNT(*) count
FROM Stg.dim_date
GROUP BY month,month_name
ORDER BY month;

SELECT quarter,COUNT(*) count
FROM Stg.dim_date
GROUP BY quarter
ORDER BY quarter;

SELECT year,COUNT(*) count
FROM Stg.dim_date
GROUP BY year
ORDER BY year;

SELECT MAX(week_of_year) as max_week,
       MIN(week_of_year) as min_week,
       COUNT(DISTINCT week_of_year) as unique_weeks
FROM Stg.dim_date;

SELECT day_of_week,COUNT(*) count
FROM Stg.dim_date
GROUP BY day_of_week
ORDER BY day_of_week;

SELECT DISTINCT is_weekend as is_weekend
FROM Stg.dim_date

SELECT is_weekend, COUNT(*) as count
FROM Stg.dim_date
GROUP BY is_weekend
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_date
WHERE is_weekend IS NULL OR LTRIM(RTRIM(is_weekend))='';


--------------------------------Stg.dim_device-----------------------------

SELECT TOP 10 * FROM Stg.dim_device;

SELECT COUNT(*) AS totalRows
FROM Stg.dim_device;

SELECT DISTINCT device_type COLLATE Latin1_General_CS_AS as devices
FROM Stg.dim_device

SELECT device_type, COUNT(*) as count
FROM Stg.dim_device
GROUP BY device_type
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_device
WHERE device_type IS NULL OR LTRIM(RTRIM(device_type))='';

SELECT DISTINCT os_version 
FROM Stg.dim_device

SELECT os_version, COUNT(*) as count
FROM Stg.dim_device
GROUP BY os_version
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_device
WHERE os_version IS NULL OR LTRIM(RTRIM(os_version))='';

SELECT DISTINCT manufacturer 
FROM Stg.dim_device

SELECT manufacturer, COUNT(*) as count
FROM Stg.dim_device
GROUP BY manufacturer
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_device
WHERE manufacturer IS NULL OR LTRIM(RTRIM(manufacturer))='';

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(screen_size_inch) as non_null_count,
		COUNT(*)-COUNT(screen_size_inch) as null_count,
		MAX(screen_size_inch) as max_value,
		MIN(screen_size_inch) as min_value,
		AVG(screen_size_inch) as avg_value
FROM Stg.dim_device


-----------------------------Stg.dim_user------------------------

SELECT TOP 10 * FROM Stg.dim_user;

SELECT COUNT(*) AS TotalRows
FROM Stg.dim_user;

SELECT DISTINCT gender COLLATE Latin1_General_CS_AS as gender
FROM Stg.dim_user

SELECT gender, COUNT(*) as count
FROM Stg.dim_user
GROUP BY gender
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE gender IS NULL OR LTRIM(RTRIM(gender))='';

SELECT DISTINCT age_group COLLATE Latin1_General_CS_AS as age_groups
FROM Stg.dim_user

SELECT age_group, COUNT(*) as count
FROM Stg.dim_user
GROUP BY age_group
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE age_group IS NULL OR LTRIM(RTRIM(age_group))='';

SELECT DISTINCT city COLLATE Latin1_General_CS_AS AS cities
FROM Stg.dim_user

SELECT city, COUNT(*) as count
FROM Stg.dim_user
GROUP BY city
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE city IS NULL OR LTRIM(RTRIM(city))='';

SELECT COUNT(*)-COUNT(registration_date) AS nulls
FROM Stg.dim_user;

SELECT DISTINCT email_domain as email_domain
FROM Stg.dim_user

SELECT email_domain, COUNT(*) as count
FROM Stg.dim_user
GROUP BY email_domain
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE email_domain IS NULL OR LTRIM(RTRIM(email_domain))='';

SELECT DISTINCT is_premium as is_premium
FROM Stg.dim_user

SELECT is_premium, COUNT(*) as count
FROM Stg.dim_user
GROUP BY is_premium
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE is_premium IS NULL OR LTRIM(RTRIM(is_premium))='';

SELECT DISTINCT country
FROM Stg.dim_user

SELECT country, COUNT(*) as count
FROM Stg.dim_user
GROUP BY country
ORDER BY count DESC

SELECT COUNT(*) AS nulls
FROM Stg.dim_user
WHERE country IS NULL OR LTRIM(RTRIM(country))='';

SELECT COUNT(*) as total,
       COUNT(DISTINCT user_id) as unique_users
FROM Stg.dim_user;


----------------------------stg.store_regions--------------------------

SELECT TOP 10 * FROM Stg.dim_store_region;

SELECT COUNT(*) AS totalRows FROM Stg.dim_store_region;

SELECT DISTINCT region_name as regions
FROM Stg.dim_store_region

SELECT region_name, COUNT(*) as count
FROM Stg.dim_store_region
GROUP BY region_name
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_store_region
WHERE region_name IS NULL OR LTRIM(RTRIM(region_name))='';

SELECT DISTINCT store_currency as store_currency
FROM Stg.dim_store_region

SELECT store_currency, COUNT(*) as count
FROM Stg.dim_store_region
GROUP BY store_currency
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.dim_store_region
WHERE store_currency IS NULL OR LTRIM(RTRIM(store_currency))='';

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(tax_rate_pct) as non_null_count,
		COUNT(*)-COUNT(tax_rate_pct) as null_count,
		MAX(tax_rate_pct) as max_value,
		MIN(tax_rate_pct) as min_value,
		AVG(tax_rate_pct) as avg_value
FROM Stg.dim_store_region

----------------------------stg.fact_app_events---------------------------

SELECT TOP 10 * FROM Stg.fact_app_events;

SELECT COUNT(*) AS totalRows FROM Stg.fact_app_events;

SELECT DISTINCT event_type COLLATE Latin1_General_CS_AS AS events
FROM Stg.fact_app_events;

SELECT event_type, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY event_type
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE event_type IS NULL OR LTRIM(RTRIM(event_type))='';

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(revenue_usd) as non_null_count,
		COUNT(*)-COUNT(revenue_usd) as null_count,
		MAX(revenue_usd) as max_value,
		MIN(revenue_usd) as min_value,
		AVG(revenue_usd) as avg_value
FROM Stg.fact_app_events;

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(session_minutes) as non_null_count,
		COUNT(*)-COUNT(session_minutes) as null_count,
		MAX(session_minutes) as max_value,
		MIN(session_minutes) as min_value,
		AVG(session_minutes) as avg_value
FROM Stg.fact_app_events;

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(rating) as non_null_count,
		COUNT(*)-COUNT(rating) as null_count,
		MAX(rating) as max_value,
		MIN(rating) as min_value,
		AVG(rating) as avg_value
FROM Stg.fact_app_events;

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(review_text_len) as non_null_count,
		COUNT(*)-COUNT(review_text_len) as null_count,
		MAX(review_text_len) as max_value,
		MIN(review_text_len) as min_value,
		AVG(review_text_len) as avg_value
FROM Stg.fact_app_events;

SELECT DISTINCT install_source COLLATE Latin1_General_CS_AS AS events
FROM Stg.fact_app_events;

SELECT install_source, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY install_source
ORDER BY count DESC;

SELECT COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE install_source IS NULL OR LTRIM(RTRIM(install_source))='';

SELECT DISTINCT app_version COLLATE Latin1_General_CS_AS AS events
FROM Stg.fact_app_events;

SELECT app_version, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY app_version
ORDER BY count DESC;

SELECT 
		SUM(CASE WHEN app_version LIKE 'v%' THEN 1 ELSE 0 END) as with_v_prefix,
		SUM(CASE WHEN app_version NOT LIKE 'v%' THEN 1 ELSE 0 END) as without_v_prefix,
		COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE app_version IS NULL OR LTRIM(RTRIM(app_version))='';

SELECT 
		COUNT(*) AS TotalRows,
		COUNT(discount_pct) as non_null_count,
		COUNT(*)-COUNT(discount_pct) as null_count,
		MAX(discount_pct) as max_value,
		MIN(discount_pct) as min_value,
		AVG(discount_pct) as avg_value
FROM Stg.fact_app_events;

select count(*) as negative_discounts
from Stg.fact_app_events
where discount_pct < 0;