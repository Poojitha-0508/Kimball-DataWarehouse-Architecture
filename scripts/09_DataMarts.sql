---------------------------------------------------------------------------------
----------------------- ***Creating Data Marts*** -------------------------------
---------------------------------------------------------------------------------

-- Creating Marketing Mart
IF OBJECT_ID('dw.vw_Marketing_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Marketing_mart;
GO

CREATE VIEW dw.vw_Marketing_mart AS
SELECT 
	u.user_key, 
	u.gender, 
	u.age_group, 
	u.country, 
	u.city, 
	u.is_premium,
	f.event_type, 
	f.session_minutes, 
	f.install_source, 
	f.revenue_usd,
	d.year, 
	d.month, 
	d.month_name, 
	d.quarter, 
	d.day_of_week, 
	d.is_weekend,
	a.app_name, 
	a.category, 
	a.platform
FROM dw.fact_app_events f
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date d
ON f.date_key=d.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
GO

-- Creating Finance Mart
IF OBJECT_ID('dw.vw_Finance_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Finance_mart;
GO

CREATE VIEW dw.vw_Finance_mart AS
SELECT 
	f.revenue_usd, 
	f.discount_pct, 
	f.event_type,
	f.app_version,
	a.app_name, 
	a.category, 
	a.platform, 
	a.price_usd,
	a.content_rating,
	s.region_name, 
	s.store_currency, 
	s.tax_rate_pct,
	d.year, 
	d.month, 
	d.month_name, 
	d.quarter,
	u.is_premium, 
	u.country
FROM dw.fact_app_events f
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date d
ON f.date_key=d.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
JOIN dw.dim_store_region s
ON f.region_key=s.region_key
GO

-- Creating Product Mart
IF OBJECT_ID('dw.vw_Product_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Product_mart;
GO

CREATE VIEW dw.vw_Product_mart AS
SELECT 
	f.rating, 
	f.session_minutes, 
	f.review_text_len, 
	f.event_type,
	a.app_name, 
	a.category, 
	a.platform, 
	a.price_usd, 
	a.size_mb,
	a.content_rating,
	dv.device_type, 
	dv.os_version, 
	dv.manufacturer,
	dt.year, 
	dt.month_name, 
	dt.quarter,
	u.is_premium, 
	u.age_group
FROM dw.fact_app_events f
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date dt
ON f.date_key=dt.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
JOIN dw.dim_device dv
ON f.device_key=dv.device_key
GO

-- Creating Regional Mart
IF OBJECT_ID('dw.vw_Regional_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Regional_mart;
GO

CREATE VIEW dw.vw_Regional_mart AS
SELECT 
	f.revenue_usd, 
	f.discount_pct, 
	f.event_type,
	s.region_name, 
	s.store_currency, 
	s.tax_rate_pct,
	a.app_name, 
	a.category, 
	a.platform,
	dt.year, 
	dt.month_name, 
	dt.quarter,
	u.country, 
	u.is_premium
FROM dw.fact_app_events f
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date dt
ON f.date_key=dt.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
JOIN dw.dim_store_region s
ON f.region_key=s.region_key
GO

-- Creating Device Mart
IF OBJECT_ID('dw.vw_Device_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Device_mart;
GO

CREATE VIEW dw.vw_Device_mart AS
SELECT 
	f.session_minutes, 
	f.event_type, 
	f.rating, 
	f.revenue_usd,
	dv.device_type, 
	dv.os_version, 
	dv.manufacturer, 
	dv.screen_size_inch,
	a.app_name, 
	a.category, 
	a.platform,
	dt.year, 
	dt.quarter, 
	dt.month_name,
	u.age_group, 
	u.is_premium
FROM dw.fact_app_events f
JOIN dw.dim_device dv
ON f.device_key=dv.device_key
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date dt
ON f.date_key=dt.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
GO

-- Creating Executive Mart
IF OBJECT_ID('dw.vw_Executive_mart','V') IS NOT NULL
	DROP VIEW dw.vw_Executive_mart;
GO

CREATE VIEW dw.vw_Executive_mart AS
SELECT 
	f.revenue_usd, 
	f.session_minutes, 
	f.rating, 
	f.discount_pct, 
	f.event_type,
	a.app_name, 
	a.category, 
	a.platform,
	s.region_name, 
	s.store_currency,
	u.is_premium, 
	u.country, 
	u.gender, 
	u.age_group,
	dt.year, 
	dt.month,
	dt.quarter, 
	dt.month_name, 
	dt.is_weekend 
FROM dw.fact_app_events f
JOIN dw.dim_user u
ON f.user_key=u.user_key
JOIN dw.dim_date dt
ON f.date_key=dt.date_key
JOIN dw.dim_app a
ON f.app_key=a.app_key
JOIN dw.dim_store_region s
ON f.region_key=s.region_key
GO