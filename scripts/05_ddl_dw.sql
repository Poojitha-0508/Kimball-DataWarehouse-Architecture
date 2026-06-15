USE AppAnalytics;

IF OBJECT_ID('dw.fact_app_events','U') IS NOT NULL
	DROP TABLE dw.fact_app_events;
GO

IF OBJECT_ID('dw.dim_app','U') IS NOT NULL
	DROP TABLE dw.dim_app;
GO

CREATE TABLE dw.dim_app(
	app_key				INT PRIMARY KEY,
	app_id				NVARCHAR(20),
	app_name			NVARCHAR(100),
	category			NVARCHAR(50),
	developer			NVARCHAR(100),
	platform			NVARCHAR(20),
	price_usd			DECIMAL(10,2),
	content_rating		NVARCHAR(20),
	release_year		SMALLINT,
	size_mb				DECIMAL(10,2)
);

IF OBJECT_ID('dw.dim_date','U') IS NOT NULL
	DROP TABLE dw.dim_date;
GO

CREATE TABLE dw.dim_date(
	date_key			INT PRIMARY KEY,
	full_date			DATE NOT NULL,
	day					TINYINT,
	month				TINYINT,
	month_name			NVARCHAR(15),
	quarter				TINYINT,
	year				SMALLINT,
	week_of_year		TINYINT,
	day_of_week			NVARCHAR(20),
	is_weekend			BIT
);

IF OBJECT_ID('dw.dim_device','U') IS NOT NULL
	DROP TABLE dw.dim_device;
GO


CREATE TABLE dw.dim_device(
	device_key			INT PRIMARY KEY,
	device_type			NVARCHAR(20),
	os_version			NVARCHAR(20),
	manufacturer		NVARCHAR(20),
	screen_size_inch	DECIMAL(10,2)
);

IF OBJECT_ID('dw.dim_store_region','U') IS NOT NULL
	DROP TABLE dw.dim_store_region;
GO

CREATE TABLE dw.dim_store_region(
	region_key			INT PRIMARY KEY,
	region_name			NVARCHAR(20),
	store_currency		NVARCHAR(10),
	tax_rate_pct		DECIMAL(10,2)
);

IF OBJECT_ID('dw.dim_user','U') IS NOT NULL
	DROP TABLE dw.dim_user;
GO

CREATE TABLE dw.dim_user
(
	user_key			INT PRIMARY KEY,
	user_id				NVARCHAR(20),
	gender				NVARCHAR(10),
	age_group			NVARCHAR(20),
	country				NVARCHAR(50),
	city				NVARCHAR(50),
	registration_date	DATE,
	email_domain		NVARCHAR(50),
	is_premium			BIT
);

IF OBJECT_ID('dw.fact_app_events','U') IS NOT NULL
	DROP TABLE dw.fact_app_events;
GO

CREATE TABLE dw.fact_app_events(
	fact_key			INT PRIMARY KEY,
	date_key			INT NOT NULL REFERENCES dw.dim_date(date_key),
	app_key				INT NOT NULL REFERENCES dw.dim_app(app_key),
	user_key			INT NOT NULL REFERENCES dw.dim_user(user_key),
	device_key			INT NOT NULL REFERENCES dw.dim_device(device_key),
	region_key			INT NOT NULL REFERENCES dw.dim_store_region(region_key),
	event_type			NVARCHAR(15),
	revenue_usd			DECIMAL(12,2),
	session_minutes		DECIMAL(10,2),
	rating				INT,
	review_text_len		INT,
	install_source		NVARCHAR(15),
	app_version			NVARCHAR(10),
	discount_pct		DECIMAL(5,2)
);