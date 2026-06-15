USE AppAnalytics;

--------------------------------------------------------------------------
--------------------------***DATA VALIDATION***---------------------------
--------------------------------------------------------------------------


--------------------------------------------------------------------------
----------------------------NO DATA LOSS----------------------------------
--------------------------------------------------------------------------

SELECT 'dim_app' as 'table',
(SELECT COUNT(*) FROM Stg.dim_app) as Staging_rows,
(SELECT COUNT(*) FROM dw.dim_app) as DW_Rows
UNION ALL
SELECT 'dim_date' as 'table',
(SELECT COUNT(*) FROM Stg.dim_date) as Staging_rows,
(SELECT COUNT(*) FROM dw.dim_date) as DW_Rows
UNION ALL
SELECT 'dim_device' as 'table',
(SELECT COUNT(*) FROM Stg.dim_device) as Staging_rows,
(SELECT COUNT(*) FROM dw.dim_device) as DW_Rows
UNION ALL
SELECT 'dim_store_region' as 'table',
(SELECT COUNT(*) FROM Stg.dim_store_region) as Staging_rows,
(SELECT COUNT(*) FROM dw.dim_store_region) as DW_Rows
UNION ALL
SELECT 'dim_user' as 'table',
(SELECT COUNT(*) FROM Stg.dim_user) as Staging_rows,
(SELECT COUNT(*) FROM dw.dim_user) as DW_Rows
UNION ALL
SELECT 'fact_app_events' as 'table',
(SELECT COUNT(*) FROM Stg.fact_app_events) as Staging_rows,
(SELECT COUNT(*) FROM dw.fact_app_events) as DW_Rows


USE AppAnalytics;

----------------------------stg.dim_app---------------------------
SELECT TOP 10 * FROM Stg.dim_app;
SELECT TOP 10 * FROM dw.dim_app;

SELECT DISTINCT app_name COLLATE Latin1_General_CS_AS as appNames, 'Stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT app_name COLLATE Latin1_General_CS_AS as appNames, 'dw.dim_app' as 'source'
FROM dw.dim_app;

SELECT 'Stg.dim_app' as 'source', app_name, COUNT(*) as count
FROM Stg.dim_app
GROUP BY app_name
UNION ALL
SELECT 'dw.dim_app' as 'source', app_name, COUNT(*) as count
FROM dw.dim_app
GROUP BY app_name
ORDER BY count DESC;

SELECT COUNT(*) AS nulls, 'stg.dim_app' as 'source'
FROM Stg.dim_app
WHERE app_name IS NULL OR LTRIM(RTRIM(app_name))=''
UNION ALL
SELECT COUNT(*) AS nulls, 'dw.dim_app' as 'source'
FROM dw.dim_app
WHERE app_name IS NULL OR LTRIM(RTRIM(app_name))='';

SELECT DISTINCT category, 'stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT category, 'dw.dim_app' as 'source'
FROM dw.dim_app

SELECT  'stg.dim_app' as 'source', category, COUNT(*) as count
FROM Stg.dim_app
GROUP BY category
UNION ALL
SELECT  'dw.dim_app' as 'source', category, COUNT(*) as count
FROM dw.dim_app
GROUP BY category
ORDER BY count DESC;

SELECT  'stg.dim_app' as 'source', COUNT(*) AS nulls
FROM Stg.dim_app
WHERE category IS NULL OR LTRIM(RTRIM(category))=''
UNION ALL
SELECT  'dw.dim_app' as 'source', COUNT(*) AS nulls
FROM dw.dim_app
WHERE category IS NULL OR LTRIM(RTRIM(category))='';

SELECT DISTINCT developer as developers,  'stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT developer as developers, 'dw.dim_app' as 'source'
FROM dw.dim_app;

SELECT 'stg.dim_app' as 'source', developer, COUNT(*) as count
FROM Stg.dim_app
GROUP BY developer
UNION ALL
SELECT 'dw.dim_app' as 'source', developer, COUNT(*) as count
FROM dw.dim_app
GROUP BY developer
ORDER BY count DESC;

SELECT 'stg.dim_app' as 'source', COUNT(*) AS nulls
FROM Stg.dim_app
WHERE developer IS NULL OR LTRIM(RTRIM(developer))=''
UNION ALL
SELECT 'dw.dim_app' as 'source', COUNT(*) AS nulls
FROM dw.dim_app
WHERE developer IS NULL OR LTRIM(RTRIM(developer))='';

SELECT DISTINCT platform COLLATE Latin1_General_CS_AS as platforms, 'stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT platform COLLATE Latin1_General_CS_AS as platforms, 'dw.dim_app' as 'source'
FROM dw.dim_app;

SELECT 'stg.dim_app' as 'source', platform, COUNT(*) as count
FROM Stg.dim_app
GROUP BY platform
UNION ALL
SELECT 'dw.dim_app' as 'source', platform, COUNT(*) as count
FROM dw.dim_app
GROUP BY platform
ORDER BY count DESC;

SELECT 'stg.dim_app' as 'source', COUNT(*) AS nulls
FROM Stg.dim_app
WHERE platform IS NULL OR LTRIM(RTRIM(platform))=''
UNION ALL
SELECT 'dw.dim_app' as 'source', COUNT(*) AS nulls
FROM dw.dim_app
WHERE platform IS NULL OR LTRIM(RTRIM(platform))='';

SELECT 
		'stg.dim_app' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(price_usd) as non_null_count,
		COUNT(*)-COUNT(price_usd) as null_count,
		MAX(price_usd) as max_value,
		MIN(price_usd) as min_value,
		AVG(price_usd) as avg_value
FROM Stg.dim_app
UNION ALL
SELECT 
		'dw.dim_app' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(price_usd) as non_null_count,
		COUNT(*)-COUNT(price_usd) as null_count,
		MAX(price_usd) as max_value,
		MIN(price_usd) as min_value,
		AVG(price_usd) as avg_value
FROM dw.dim_app;

SELECT DISTINCT content_rating, 'stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT content_rating, 'dw.dim_app' as 'source' 
FROM dw.dim_app;

SELECT 'stg.dim_app' as 'source', content_rating, COUNT(*) as count
FROM Stg.dim_app
GROUP BY content_rating
UNION ALL
SELECT 'dw.dim_app' as 'source', content_rating, COUNT(*) as count
FROM dw.dim_app
GROUP BY content_rating
ORDER BY count DESC;

SELECT 'stg.dim_app' as 'source', COUNT(*) as nulls
FROM Stg.dim_app
WHERE content_rating IS NULL OR LTRIM(RTRIM(content_rating)) = ''
UNION ALL
SELECT 'dw.dim_app' as 'source', COUNT(*) as nulls
FROM dw.dim_app
WHERE content_rating IS NULL OR LTRIM(RTRIM(content_rating)) = '';

-- release_year
SELECT DISTINCT release_year, 'stg.dim_app' as 'source'
FROM Stg.dim_app
UNION ALL
SELECT DISTINCT release_year, 'dw.dim_app' as 'source'
FROM dw.dim_app;

SELECT 'stg.dim_app' as 'source', release_year, COUNT(*) as count
FROM Stg.dim_app
GROUP BY release_year
UNION ALL
SELECT 'dw.dim_app' as 'source', release_year, COUNT(*) as count
FROM dw.dim_app
GROUP BY release_year
ORDER BY count DESC

SELECT 'stg.dim_app' as 'source', max(release_year), min(release_year),
       count(*), count(*)-count(release_year) as nulls
FROM Stg.dim_app
UNION ALL
SELECT 'dw.dim_app' as 'source',max(release_year), min(release_year),
       count(*), count(*)-count(release_year) as nulls
FROM dw.dim_app;

SELECT 
		'stg.dim_app' as 'source',
		COUNT(*) AS TotalRows,
		COUNT(size_mb) as non_null_count,
		COUNT(*)-COUNT(size_mb) as null_count,
		MAX(size_mb) as max_value,
		MIN(size_mb) as min_value,
		AVG(size_mb) as avg_value
FROM Stg.dim_app
UNION ALL
SELECT 
		'dw.dim_app' as 'source',
		COUNT(*) AS TotalRows,
		COUNT(size_mb) as non_null_count,
		COUNT(*)-COUNT(size_mb) as null_count,
		MAX(size_mb) as max_value,
		MIN(size_mb) as min_value,
		AVG(size_mb) as avg_value
FROM dw.dim_app;

-----------------------------Stg.dim_date------------------------------

SELECT TOP 10 * FROM Stg.dim_date;
SELECT TOP 10 * FROM dw.dim_date;

SELECT COUNT(*) AS totalRows
FROM Stg.dim_date
UNION ALL
SELECT COUNT(*) AS totalRows
FROM dw.dim_date

SELECT 'stg.dim_date' as 'source', MAX(full_date) as latest_date,
       MIN(full_date) as earliest_date
FROM Stg.dim_date
UNION ALL
SELECT 'dw.dim_date' as 'source', MAX(full_date) as latest_date,
       MIN(full_date) as earliest_date
FROM dw.dim_date;

SELECT 'stg.dim_date' as 'source', COUNT(*)-COUNT(full_date) AS nulls
FROM Stg.dim_date
UNION ALL
SELECT 'dw.dim_date' as 'source', COUNT(*)-COUNT(full_date) AS nulls
FROM dw.dim_date

SELECT 'stg.dim_date' as 'source', day,COUNT(*) count
FROM Stg.dim_date
GROUP BY day
UNION ALL
SELECT 'dw.dim_date' as 'source', day,COUNT(*) count
FROM dw.dim_date
GROUP BY day
ORDER BY day;

SELECT 'stg.dim_date' as 'source', month,month_name,COUNT(*) count
FROM Stg.dim_date
GROUP BY month,month_name
UNION ALL
SELECT 'dw.dim_date' as 'source', month,month_name,COUNT(*) count
FROM dw.dim_date
GROUP BY month,month_name
ORDER BY month

SELECT 'stg.dim_date' as 'source', quarter,COUNT(*) count
FROM Stg.dim_date
GROUP BY quarter
UNION ALL
SELECT 'dw.dim_date' as 'source', quarter,COUNT(*) count
FROM dw.dim_date
GROUP BY quarter
ORDER BY quarter

SELECT 'stg.dim_date' as 'source', year,COUNT(*) count
FROM Stg.dim_date
GROUP BY year
UNION ALL
SELECT 'dw.dim_date' as 'source', year,COUNT(*) count
FROM dw.dim_date
GROUP BY year
ORDER BY year;

SELECT 'stg.dim_date' as 'source', 
		MAX(week_of_year) as max_week,
       MIN(week_of_year) as min_week,
       COUNT(DISTINCT week_of_year) as unique_weeks
FROM Stg.dim_date
UNION ALL
SELECT 'dw.dim_date' as 'source', MAX(week_of_year) as max_week,
       MIN(week_of_year) as min_week,
       COUNT(DISTINCT week_of_year) as unique_weeks
FROM dw.dim_date

SELECT 'stg.dim_date' as 'source', day_of_week,COUNT(*) count
FROM Stg.dim_date
GROUP BY day_of_week
UNION ALL
SELECT 'dw.dim_date' as 'source', day_of_week,COUNT(*) count
FROM dw.dim_date
GROUP BY day_of_week
ORDER BY day_of_week;

SELECT DISTINCT is_weekend as is_weekend, 'stg.dim_date' as 'source'
FROM Stg.dim_date
UNION ALL
SELECT DISTINCT is_weekend as is_weekend, 'dw.dim_date' as 'source'
FROM dw.dim_date;

SELECT 'stg.dim_date' as 'source', is_weekend, COUNT(*) as count
FROM Stg.dim_date
GROUP BY is_weekend
UNION ALL
SELECT 'dw.dim_date' as 'source', is_weekend, COUNT(*) as count
FROM dw.dim_date
GROUP BY is_weekend
ORDER BY count DESC;

SELECT 'stg.dim_date' as 'source', COUNT(*) AS nulls
FROM Stg.dim_date
WHERE is_weekend IS NULL
UNION ALL
SELECT 'dw.dim_date' as 'source', COUNT(*) AS nulls
FROM dw.dim_date
WHERE is_weekend IS NULL

--------------------------------Stg.dim_device-----------------------------

SELECT TOP 10 * FROM Stg.dim_device;
SELECT TOP 10 * FROM dw.dim_device;

SELECT COUNT(*) AS totalRows FROM Stg.dim_device
UNION ALL
SELECT COUNT(*) AS totalRows FROM dw.dim_device;

SELECT DISTINCT device_type COLLATE Latin1_General_CS_AS as devices,'stg.dim_device' as 'source'
FROM Stg.dim_device
UNION ALL
SELECT DISTINCT device_type COLLATE Latin1_General_CS_AS as devices, 'dw.dim_device' as 'source'
FROM dw.dim_device;

SELECT 'stg.dim_device' as 'source', device_type, COUNT(*) as count
FROM Stg.dim_device
GROUP BY device_type
UNION ALL
SELECT 'dw.dim_device' as 'source', device_type, COUNT(*) as count
FROM dw.dim_device
GROUP BY device_type
ORDER BY count DESC;

SELECT 'stg.dim_device' as 'source', COUNT(*) AS nulls
FROM Stg.dim_device
WHERE device_type IS NULL OR LTRIM(RTRIM(device_type))=''
UNION ALL
SELECT 'dw.dim_device' as 'source', COUNT(*) AS nulls
FROM dw.dim_device
WHERE device_type IS NULL OR LTRIM(RTRIM(device_type))='';

SELECT DISTINCT os_version, 'stg.dim_device' as 'source'
FROM Stg.dim_device
UNION ALL
SELECT DISTINCT os_version,'dw.dim_device' as 'source'
FROM dw.dim_device;

SELECT 'stg.dim_device' as 'source', os_version, COUNT(*) as count
FROM Stg.dim_device
GROUP BY os_version
UNION ALL
SELECT 'dw.dim_device' as 'source', os_version, COUNT(*) as count
FROM dw.dim_device
GROUP BY os_version
ORDER BY count DESC;

SELECT 'stg.dim_device' as 'source', COUNT(*) AS nulls
FROM Stg.dim_device
WHERE os_version IS NULL OR LTRIM(RTRIM(os_version))=''
UNION ALL
SELECT 'dw.dim_device' as 'source', COUNT(*) AS nulls
FROM dw.dim_device
WHERE os_version IS NULL OR LTRIM(RTRIM(os_version))='';

SELECT DISTINCT manufacturer, 'stg.dim_device' as 'source'
FROM Stg.dim_device
UNION ALL
SELECT DISTINCT manufacturer, 'dw.dim_device' as 'source'
FROM dw.dim_device;

SELECT 'stg.dim_device' as 'source', manufacturer, COUNT(*) as count
FROM Stg.dim_device
GROUP BY manufacturer
UNION ALL
SELECT 'dw.dim_device' as 'source', manufacturer, COUNT(*) as count
FROM dw.dim_device
GROUP BY manufacturer
ORDER BY count DESC

SELECT 'stg.dim_device' as 'source', COUNT(*) AS nulls
FROM Stg.dim_device
WHERE manufacturer IS NULL OR LTRIM(RTRIM(manufacturer))=''
UNION ALL
SELECT 'dw.dim_device' as 'source', COUNT(*) AS nulls
FROM dw.dim_device
WHERE manufacturer IS NULL OR LTRIM(RTRIM(manufacturer))='';

SELECT 
		'stg.dim_device' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(screen_size_inch) as non_null_count,
		COUNT(*)-COUNT(screen_size_inch) as null_count,
		MAX(screen_size_inch) as max_value,
		MIN(screen_size_inch) as min_value,
		AVG(screen_size_inch) as avg_value
FROM Stg.dim_device
UNION ALL
SELECT 
		'dw.dim_device' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(screen_size_inch) as non_null_count,
		COUNT(*)-COUNT(screen_size_inch) as null_count,
		MAX(screen_size_inch) as max_value,
		MIN(screen_size_inch) as min_value,
		AVG(screen_size_inch) as avg_value
FROM dw.dim_device;

-----------------------------Stg.dim_user------------------------

SELECT TOP 10 * FROM Stg.dim_user;
SELECT TOP 10 * FROM dw.dim_user;


SELECT COUNT(*) AS TotalRows
FROM Stg.dim_user
UNION ALL
SELECT COUNT(*) AS TotalRows
FROM dw.dim_user;

SELECT DISTINCT gender COLLATE Latin1_General_CS_AS as gender, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL
SELECT DISTINCT gender COLLATE Latin1_General_CS_AS as gender, 'dw.dim_user' as 'source'
FROM dw.dim_user;

SELECT 'stg.dim_user' as 'source', gender, COUNT(*) as count
FROM Stg.dim_user
GROUP BY gender
UNION ALL
SELECT 'dw.dim_user' as 'source', gender, COUNT(*) as count
FROM dw.dim_user
GROUP BY gender
ORDER BY count DESC;

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE gender IS NULL OR LTRIM(RTRIM(gender))=''
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE gender IS NULL OR LTRIM(RTRIM(gender))='';

SELECT DISTINCT age_group COLLATE Latin1_General_CS_AS as age_groups, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL
SELECT DISTINCT age_group COLLATE Latin1_General_CS_AS as age_groups, 'dw.dim_user' as 'source'
FROM dw.dim_user;

SELECT 'stg.dim_user' as 'source', age_group, COUNT(*) as count
FROM Stg.dim_user
GROUP BY age_group
UNION ALL
SELECT 'dw.dim_user' as 'source', age_group, COUNT(*) as count
FROM dw.dim_user
GROUP BY age_group
ORDER BY count DESC;

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE age_group IS NULL OR LTRIM(RTRIM(age_group))=''
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE age_group IS NULL OR LTRIM(RTRIM(age_group))='';

SELECT DISTINCT city COLLATE Latin1_General_CS_AS AS cities, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL
SELECT DISTINCT city COLLATE Latin1_General_CS_AS AS cities, 'dw.dim_user' as 'source'
FROM dw.dim_user;

SELECT 'stg.dim_user' as 'source', city, COUNT(*) as count
FROM Stg.dim_user
GROUP BY city
UNION ALL
SELECT 'dw.dim_user' as 'source', city, COUNT(*) as count
FROM dw.dim_user
GROUP BY city
ORDER BY count DESC;

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE city IS NULL OR LTRIM(RTRIM(city))=''
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE city IS NULL OR LTRIM(RTRIM(city))='';

SELECT 'stg.dim_user' as 'source', COUNT(*)-COUNT(registration_date) AS nulls
FROM Stg.dim_user
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*)-COUNT(registration_date) AS nulls
FROM dw.dim_user;

SELECT DISTINCT email_domain as email_domain, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL
SELECT DISTINCT email_domain as email_domain, 'dw.dim_user' as 'source'
FROM dw.dim_user;

SELECT 'stg.dim_user' as 'source', email_domain, COUNT(*) as count
FROM Stg.dim_user
GROUP BY email_domain
UNION ALL
SELECT 'dw.dim_user' as 'source', email_domain, COUNT(*) as count
FROM dw.dim_user
GROUP BY email_domain
ORDER BY count DESC;

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE email_domain IS NULL OR LTRIM(RTRIM(email_domain))=''
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE email_domain IS NULL OR LTRIM(RTRIM(email_domain))='';

SELECT DISTINCT is_premium as is_premium, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL
SELECT DISTINCT CAST(is_premium AS NVARCHAR) as is_premium, 'dw.dim_user' as 'source'
FROM dw.dim_user

SELECT 'stg.dim_user' as 'source', is_premium, COUNT(*) as count
FROM Stg.dim_user
GROUP BY is_premium
UNION ALL
SELECT 'dw.dim_user' as 'source', is_premium, COUNT(*) as count
FROM dw.dim_user
GROUP BY is_premium
ORDER BY count DESC;

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE is_premium IS NULL
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE is_premium IS NULL;

SELECT DISTINCT country, 'stg.dim_user' as 'source'
FROM Stg.dim_user
UNION ALL 
SELECT DISTINCT country, 'dw.dim_user' as 'source'
FROM dw.dim_user

SELECT 'stg.dim_user' as 'source', country, COUNT(*) as count
FROM Stg.dim_user
GROUP BY country
UNION ALL
SELECT 'dw.dim_user' as 'source', country, COUNT(*) as count
FROM dw.dim_user
GROUP BY country
ORDER BY count DESC

SELECT 'stg.dim_user' as 'source', COUNT(*) AS nulls
FROM Stg.dim_user
WHERE country IS NULL OR LTRIM(RTRIM(country))=''
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) AS nulls
FROM dw.dim_user
WHERE country IS NULL OR LTRIM(RTRIM(country))='';

SELECT 'stg.dim_user' as 'source', COUNT(*) as total,
       COUNT(DISTINCT user_id) as unique_users
FROM Stg.dim_user
UNION ALL
SELECT 'dw.dim_user' as 'source', COUNT(*) as total,
       COUNT(DISTINCT user_id) as unique_users
FROM dw.dim_user;

----------------------------stg.store_regions--------------------------

SELECT TOP 10 * FROM Stg.dim_store_region;
SELECT TOP 10 * FROM dw.dim_store_region;


SELECT COUNT(*) AS totalRows FROM Stg.dim_store_region
UNION ALL
SELECT COUNT(*) AS totalRows FROM dw.dim_store_region

SELECT DISTINCT region_name as regions, 'stg.dim_store_region' as 'source'
FROM Stg.dim_store_region
UNION ALL
SELECT DISTINCT region_name as regions, 'dw.dim_store_region' as 'source'
FROM dw.dim_store_region;

SELECT 'stg.dim_store_region' as 'source', region_name, COUNT(*) as count
FROM Stg.dim_store_region
GROUP BY region_name
UNION ALL
SELECT 'dw.dim_store_region' as 'source', region_name, COUNT(*) as count
FROM dw.dim_store_region
GROUP BY region_name
ORDER BY count DESC;

SELECT 'stg.dim_store_region' as 'source', COUNT(*) AS nulls
FROM Stg.dim_store_region
WHERE region_name IS NULL OR LTRIM(RTRIM(region_name))=''
UNION ALL
SELECT 'dw.dim_store_region' as 'source', COUNT(*) AS nulls
FROM dw.dim_store_region
WHERE region_name IS NULL OR LTRIM(RTRIM(region_name))='';

SELECT DISTINCT store_currency as store_currency, 'stg.dim_store_region' as 'source'
FROM Stg.dim_store_region
UNION ALL
SELECT DISTINCT store_currency as store_currency, 'dw.dim_store_region' as 'source'
FROM dw.dim_store_region;

SELECT 'stg.dim_store_region' as 'source', store_currency, COUNT(*) as count
FROM Stg.dim_store_region
GROUP BY store_currency
UNION ALL
SELECT 'dw.dim_store_region' as 'source', store_currency, COUNT(*) as count
FROM dw.dim_store_region
GROUP BY store_currency
ORDER BY count DESC;

SELECT 'stg.dim_store_region' as 'source', COUNT(*) AS nulls
FROM Stg.dim_store_region
WHERE store_currency IS NULL OR LTRIM(RTRIM(store_currency))=''
UNION ALL
SELECT 'dw.dim_store_region' as 'source', COUNT(*) AS nulls
FROM dw.dim_store_region
WHERE store_currency IS NULL OR LTRIM(RTRIM(store_currency))='';

SELECT 
		'stg.dim_store_region' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(tax_rate_pct) as non_null_count,
		COUNT(*)-COUNT(tax_rate_pct) as null_count,
		MAX(tax_rate_pct) as max_value,
		MIN(tax_rate_pct) as min_value,
		AVG(tax_rate_pct) as avg_value
FROM Stg.dim_store_region
UNION ALL
SELECT 
		'dw.dim_store_region' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(tax_rate_pct) as non_null_count,
		COUNT(*)-COUNT(tax_rate_pct) as null_count,
		MAX(tax_rate_pct) as max_value,
		MIN(tax_rate_pct) as min_value,
		AVG(tax_rate_pct) as avg_value
FROM dw.dim_store_region;

----------------------------stg.fact_app_events---------------------------

SELECT TOP 10 * FROM Stg.fact_app_events;
SELECT TOP 10 * FROM dw.fact_app_events;


SELECT COUNT(*) AS totalRows FROM Stg.fact_app_events
UNION ALL
SELECT COUNT(*) AS totalRows FROM dw.fact_app_events;


SELECT DISTINCT event_type COLLATE Latin1_General_CS_AS AS events, 'stg.fact_app_events' as 'source'
FROM Stg.fact_app_events
UNION ALL
SELECT DISTINCT event_type COLLATE Latin1_General_CS_AS AS events, 'dw.fact_app_events' as 'source'
FROM dw.fact_app_events;

SELECT 'stg.fact_app_events' as 'source', event_type, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY event_type
UNION ALL
SELECT 'dw.fact_app_events' as 'source', event_type, COUNT(*) as count
FROM dw.fact_app_events
GROUP BY event_type
ORDER BY count DESC;

SELECT 'stg.fact_app_events' as 'source', COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE event_type IS NULL OR LTRIM(RTRIM(event_type))=''
UNION ALL
SELECT 'dw.fact_app_events' as 'source', COUNT(*) AS nulls
FROM dw.fact_app_events
WHERE event_type IS NULL OR LTRIM(RTRIM(event_type))='';

SELECT 
		'stg.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(revenue_usd) as non_null_count,
		COUNT(*)-COUNT(revenue_usd) as null_count,
		MAX(revenue_usd) as max_value,
		MIN(revenue_usd) as min_value,
		AVG(revenue_usd) as avg_value
FROM Stg.fact_app_events
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(revenue_usd) as non_null_count,
		COUNT(*)-COUNT(revenue_usd) as null_count,
		MAX(revenue_usd) as max_value,
		MIN(revenue_usd) as min_value,
		AVG(revenue_usd) as avg_value
FROM dw.fact_app_events;

SELECT 
		'stg.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(session_minutes) as non_null_count,
		COUNT(*)-COUNT(session_minutes) as null_count,
		MAX(session_minutes) as max_value,
		MIN(session_minutes) as min_value,
		AVG(session_minutes) as avg_value
FROM Stg.fact_app_events
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(session_minutes) as non_null_count,
		COUNT(*)-COUNT(session_minutes) as null_count,
		MAX(session_minutes) as max_value,
		MIN(session_minutes) as min_value,
		AVG(session_minutes) as avg_value
FROM dw.fact_app_events;

SELECT 
		'stg.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(rating) as non_null_count,
		COUNT(*)-COUNT(rating) as null_count,
		MAX(rating) as max_value,
		MIN(rating) as min_value,
		AVG(rating) as avg_value
FROM Stg.fact_app_events
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(rating) as non_null_count,
		COUNT(*)-COUNT(rating) as null_count,
		MAX(rating) as max_value,
		MIN(rating) as min_value,
		AVG(rating) as avg_value
FROM dw.fact_app_events;

SELECT 
		'stg.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(review_text_len) as non_null_count,
		COUNT(*)-COUNT(review_text_len) as null_count,
		MAX(review_text_len) as max_value,
		MIN(review_text_len) as min_value,
		AVG(review_text_len) as avg_value
FROM Stg.fact_app_events
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(review_text_len) as non_null_count,
		COUNT(*)-COUNT(review_text_len) as null_count,
		MAX(review_text_len) as max_value,
		MIN(review_text_len) as min_value,
		AVG(review_text_len) as avg_value
FROM dw.fact_app_events;

SELECT DISTINCT install_source COLLATE Latin1_General_CS_AS AS events, 'stg.fact_app_events' as 'source'
FROM Stg.fact_app_events
UNION ALL
SELECT DISTINCT install_source COLLATE Latin1_General_CS_AS AS events, 'dw.fact_app_events' as 'source'
FROM dw.fact_app_events;

SELECT 'stg.fact_app_events' as 'source', install_source, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY install_source
UNION ALL
SELECT 'dw.fact_app_events' as 'source', install_source, COUNT(*) as count
FROM dw.fact_app_events
GROUP BY install_source
ORDER BY count DESC;

SELECT 'stg.fact_app_events' as 'source', COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE install_source IS NULL OR LTRIM(RTRIM(install_source))=''
UNION ALL
SELECT 'dw.fact_app_events' as 'source', COUNT(*) AS nulls
FROM dw.fact_app_events
WHERE install_source IS NULL OR LTRIM(RTRIM(install_source))='';

SELECT DISTINCT app_version COLLATE Latin1_General_CS_AS AS events, 'stg.fact_app_events' as 'source'
FROM Stg.fact_app_events
UNION ALL
SELECT DISTINCT app_version COLLATE Latin1_General_CS_AS AS events, 'dw.fact_app_events' as 'source'
FROM dw.fact_app_events;

SELECT 'stg.fact_app_events' as 'source', app_version, COUNT(*) as count
FROM Stg.fact_app_events
GROUP BY app_version
UNION ALL
SELECT 'dw.fact_app_events' as 'source', app_version, COUNT(*) as count
FROM dw.fact_app_events
GROUP BY app_version
ORDER BY count DESC;

SELECT 
		'stg.fact_app_events' as 'source', 
		SUM(CASE WHEN app_version LIKE 'v%' THEN 1 ELSE 0 END) as with_v_prefix,
		SUM(CASE WHEN app_version NOT LIKE 'v%' THEN 1 ELSE 0 END) as without_v_prefix,
		COUNT(*) AS nulls
FROM Stg.fact_app_events
WHERE app_version IS NULL OR LTRIM(RTRIM(app_version))=''
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		SUM(CASE WHEN app_version LIKE 'v%' THEN 1 ELSE 0 END) as with_v_prefix,
		SUM(CASE WHEN app_version NOT LIKE 'v%' THEN 1 ELSE 0 END) as without_v_prefix,
		COUNT(*) AS nulls
FROM dw.fact_app_events
WHERE app_version IS NULL OR LTRIM(RTRIM(app_version))='';

SELECT 
		'stg.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(discount_pct) as non_null_count,
		COUNT(*)-COUNT(discount_pct) as null_count,
		MAX(CAST(discount_pct AS float)) as max_value,
		MIN(CAST(discount_pct AS float)) as min_value,
		AVG(CAST(discount_pct AS float)) as avg_value
FROM Stg.fact_app_events
UNION ALL
SELECT 
		'dw.fact_app_events' as 'source', 
		COUNT(*) AS TotalRows,
		COUNT(discount_pct) as non_null_count,
		COUNT(*)-COUNT(discount_pct) as null_count,
		MAX(discount_pct) as max_value,
		MIN(discount_pct) as min_value,
		AVG(discount_pct) as avg_value
FROM dw.fact_app_events

select 'stg.fact_app_events' as 'source', count(*) as negative_discounts
from Stg.fact_app_events
where CAST(discount_pct AS float) < 0
UNION ALL
select 'dw.fact_app_events' as 'source', count(*) as negative_discounts
from dw.fact_app_events
where discount_pct < 0;