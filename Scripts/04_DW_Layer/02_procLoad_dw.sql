-- Inserting records into DW tables
CREATE OR ALTER PROCEDURE dw.Load_DW AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time=GETDATE();
		PRINT '---------------------------------------';
		PRINT 'Loading DW tables';
		PRINT '---------------------------------------';
				
		-- 1. Disable all FK constraints first
		ALTER TABLE dw.fact_app_events  NOCHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_app          NOCHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_date         NOCHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_device       NOCHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_store_region NOCHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_user         NOCHECK CONSTRAINT ALL;

		-- 2. Truncate in correct order (FACT first, then DIMS)
		DELETE FROM dw.fact_app_events;  -- child table first!
		DELETE FROM dw.dim_app;
		DELETE FROM  dw.dim_date;
		DELETE FROM dw.dim_device;
		DELETE FROM dw.dim_store_region;
		DELETE FROM dw.dim_user;

		-- ... all your inserts here ...

		-- 3. Re-enable after loading
		ALTER TABLE dw.fact_app_events  WITH CHECK CHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_app          WITH CHECK CHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_date         WITH CHECK CHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_device       WITH CHECK CHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_store_region WITH CHECK CHECK CONSTRAINT ALL;
		ALTER TABLE dw.dim_user         WITH CHECK CHECK CONSTRAINT ALL;
		
		-- Loading dw.dim_app
		SET @start_time=GETDATE();

		PRINT 'Inserting Data into Table: dw.dim_app';

		INSERT INTO dw.dim_app (
			app_key,
			app_id,
			app_name,
			category,
			developer,
			platform,
			price_usd,
			content_rating,
			release_year,
			size_mb
		)
		SELECT 
			app_key,
			app_id,
			UPPER(SUBSTRING(TRIM(app_name),1,1))+LOWER(SUBSTRING(TRIM(app_name),2,LEN(TRIM(app_name)))) AS app_name,
			TRIM(category) AS category,
			TRIM(developer) as developer,
			CASE
				WHEN LOWER(platform)='android' THEN 'Android'
				WHEN LOWER(platform)='ios' THEN 'iOS'
				ELSE 'Both'
			END AS Platform,
			ROUND(price_usd,2) AS price_usd,
			content_rating,
			CAST(release_year AS SMALLINT) AS release_year,
			ROUND(size_mb,2) AS size_mb
		FROM Stg.dim_app;

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading dw.dim_device
		SET @start_time=GETDATE();

		PRINT 'Inserting Data into Table: dw.dim_device';

		INSERT INTO dw.dim_device (
			device_key,
			device_type,
			os_version,
			manufacturer,
			screen_size_inch
		)
		SELECT 
			device_key,
			CASE
				WHEN LOWER(device_type)='smartphone' THEN 'Smartphone'
				WHEN LOWER(device_type)='pc' THEN 'PC'
				WHEN LOWER(device_type)='smartwatch' THEN 'Smartwatch'
				WHEN LOWER(device_type)='tablet' THEN 'Tablet'
			END AS device_type,
			os_version,
			manufacturer,
			ROUND(screen_size_inch,2) AS screen_size_inch
		FROM Stg.dim_device

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading Stg.dim_date
		SET @start_time=GETDATE();

		PRINT 'Inserting Data into Table: dw.dim_date';
		
		INSERT INTO dw.dim_date (
			date_key,
			full_date,
			day,
			month,
			month_name,
			quarter,
			year,
			week_of_year,
			day_of_week,
			is_weekend
		)
		SELECT
			date_key,
			full_date,
			day,
			month,
			UPPER(SUBSTRING(TRIM(month_name),1,1))+LOWER(SUBSTRING(TRIM(month_name),2,LEN(TRIM(month_name)))) as month_name,
			quarter,
			year,
			week_of_year,
			day_of_week,
			CASE
				WHEN is_weekend='True' THEN 1
				ELSE 0
			END AS is_weekend
		FROM Stg.dim_date
		
		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';
		
		-- Loading dw.dim_user
		SET @start_time=GETDATE();

		PRINT 'Inserting Data into Table: dw.dim_user';

		INSERT INTO dw.dim_user (
			user_key,
			user_id,
			gender,
			age_group,
			country,
			city,
			registration_date,
			email_domain,
			is_premium
		)
		SELECT 
			user_key,
			user_id,
			CASE 
				WHEN LOWER(gender) IN ('m','male') THEN 'Male'
				WHEN LOWER(gender) IN ('f','female') THEN 'Female'
				ELSE 'Unknown'
			END AS Gender,
			ISNULL(REPLACE(REPLACE(TRIM(age_group),'_','-'),' to ','-'),'Unknown') AS age_group,
			country,
			CASE 
				WHEN CITY IS NULL OR TRIM(CITY)='' OR CITY='N/A' THEN 'Unknown'
				ELSE city
			END AS city,
			registration_date,
			email_domain,
			CASE 
				WHEN is_premium IN ('yes','true','1') THEN 1
				ELSE 0
			END AS is_premium
		FROM Stg.dim_user;

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading dw.dim_store_region
		SET @start_time=GETDATE();
		
		PRINT 'Inserting Data into Table: dw.dim_store_region';

		INSERT INTO dw.dim_store_region (
			region_key,
			region_name,
			store_currency,
			tax_rate_pct
		)
		SELECT 
			region_key,
			region_name,
			store_currency,
			tax_rate_pct
		FROM Stg.dim_store_region;

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading dw.fact_app_events
		SET @start_time=GETDATE();
		
		PRINT 'Inserting Data into Table: dw.fact_app_events';

		INSERT INTO dw.fact_app_events (
			fact_key,
			date_key,
			app_key,
			user_key,
			device_key,
			region_key,
			event_type,
			revenue_usd,
			session_minutes,
			rating,
			review_text_len,
			install_source,
			app_version,
			discount_pct
		)
		SELECT 
			fact_key,
			date_key,
			app_key,
			user_key,
			device_key,
			region_key,
			UPPER(SUBSTRING(TRIM(event_type),1,1))+LOWER(SUBSTRING(TRIM(event_type),2,LEN(TRIM(event_type)))) AS event_type,
			revenue_usd,
			session_minutes,
			rating,
			review_text_len,
			UPPER(SUBSTRING(TRIM(install_source),1,1))+LOWER(SUBSTRING(TRIM(install_source),2,LEN(TRIM(install_source)))) AS install_source,
			TRIM(REPLACE(app_version,'v','')) AS app_version,
			CASE 
				WHEN CAST(discount_pct AS FLOAT)<0 THEN 0
				ELSE ISNULL(CAST(discount_pct AS FLOAT),0) 
			END AS discount_pct
		FROM Stg.fact_app_events;


		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		SET @batch_end_time=GETDATE();
		PRINT '---------------------------------------';
		PRINT '>> Loaded batch with Duration: '+CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)+' seconds';
		PRINT '---------------------------------------';

	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING DW LAYER'
		PRINT 'Error Message : ' + ERROR_MESSAGE();
		PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

EXEC dw.Load_DW;