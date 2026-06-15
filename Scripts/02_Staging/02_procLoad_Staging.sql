-- Inserting records into staging tables
CREATE OR ALTER PROCEDURE Stg.Load_Stg AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_end_time=GETDATE();
		PRINT '---------------------------------------';
		PRINT 'Loading Staging tables';
		PRINT '---------------------------------------';

		-- Loading Stg.dim_app
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.dim_app';
		TRUNCATE TABLE Stg.dim_app;
		PRINT 'Inserting Data into Table: Stg.dim_app';

		BULK INSERT Stg.dim_app
		FROM 'C:\dim_app.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading Stg.dim_device
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.dim_device';
		TRUNCATE TABLE Stg.dim_device;
		PRINT 'Inserting Data into Table: Stg.dim_device';

		BULK INSERT Stg.dim_device
		FROM 'C:\dim_device.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading Stg.dim_date
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.dim_date';
		TRUNCATE TABLE Stg.dim_date;
		PRINT 'Inserting Data into Table: Stg.dim_date';
		
		BULK INSERT Stg.dim_date
		FROM 'C:\dim_date.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';
		
		-- Loading Stg.dim_user
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.dim_user';
		TRUNCATE TABLE Stg.dim_user;
		PRINT 'Inserting Data into Table: Stg.dim_user';

		BULK INSERT Stg.dim_user
		FROM 'C:\dim_user.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading Stg.dim_store_region
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.dim_store_region';
		TRUNCATE TABLE Stg.dim_store_region;
		PRINT 'Inserting Data into Table: Stg.dim_store_region';

		BULK INSERT Stg.dim_store_region
		FROM 'C:\dim_store_region.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		-- Loading Stg.fact_app_events
		SET @start_time=GETDATE();
		PRINT 'Truncating Table: Stg.fact_app_events';
		TRUNCATE TABLE Stg.fact_app_events;
		PRINT 'Inserting Data into Table: Stg.fact_app_events';

		BULK INSERT Stg.fact_app_events
		FROM 'C:\fact_app_events.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '0x0a'
		);

		SET @end_time=GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' seconds';

		SET @batch_end_time=GETDATE();
		PRINT '---------------------------------------';
		PRINT '>> Loaded batch with Duration: '+CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)+' seconds';
		PRINT '---------------------------------------';

	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING STAGING LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END

EXEC Stg.Load_Stg;