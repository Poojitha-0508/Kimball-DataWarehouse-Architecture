USE AppAnalytics;

-- Creating Staging 
IF OBJECT_ID('Stg.dim_app','U') IS NOT NULL
	DROP TABLE Stg.dim_app;
GO

CREATE TABLE Stg.dim_app(
	app_key				INT,
	app_id				NVARCHAR(20),
	app_name			NVARCHAR(1000),
	category			NVARCHAR(50),
	developer			NVARCHAR(100),
	platform			NVARCHAR(20),
	price_usd			FLOAT,
	content_rating		NVARCHAR(20),
	release_year		FLOAT,
	size_mb				FLOAT
);

IF OBJECT_ID('Stg.dim_date','U') IS NOT NULL
	DROP TABLE Stg.dim_date;
GO

CREATE TABLE Stg.dim_date(
	date_key			INT,
	full_date			DATE,
	day					INT,
	month				INT,
	month_name			NVARCHAR(15),
	quarter				INT,
	year				INT,
	week_of_year		INT,
	day_of_week			NVARCHAR(100),
	is_weekend			NVARCHAR(10)
);

IF OBJECT_ID('Stg.dim_device','U') IS NOT NULL
	DROP TABLE Stg.dim_device;
GO

CREATE TABLE Stg.dim_device(
	device_key			INT,
	device_type			NVARCHAR(20),
	os_version			NVARCHAR(20),
	manufacturer		NVARCHAR(20),
	screen_size_inch	FLOAT
);

IF OBJECT_ID('Stg.dim_store_region','U') IS NOT NULL
	DROP TABLE Stg.dim_store_region;
GO

CREATE TABLE Stg.dim_store_region(
	region_key			INT,
	region_name			NVARCHAR(50),
	store_currency		NVARCHAR(10),
	tax_rate_pct		FLOAT
);

IF OBJECT_ID('Stg.dim_user','U') IS NOT NULL
	DROP TABLE Stg.dim_user;
GO

CREATE TABLE Stg.dim_user
(
	user_key			INT,
	user_id				NVARCHAR(100),
	gender				NVARCHAR(10),
	age_group			NVARCHAR(20),
	country				NVARCHAR(20),
	city				NVARCHAR(20),
	registration_date	DATE,
	email_domain		NVARCHAR(20),
	is_premium			NVARCHAR(10)
);

IF OBJECT_ID('Stg.fact_app_events','U') IS NOT NULL
	DROP TABLE Stg.fact_app_events;
GO

CREATE TABLE Stg.fact_app_events(
	fact_key			INT,
	date_key			INT,
	app_key				INT,
	user_key			INT,
	device_key			INT,
	region_key			INT,
	event_type			NVARCHAR(20),
	revenue_usd			FLOAT,
	session_minutes		FLOAT,
	rating				FLOAT,
	review_text_len		FLOAT,
	install_source		NVARCHAR(20),
	app_version			NVARCHAR(10),
	discount_pct		NVARCHAR(10)
);


