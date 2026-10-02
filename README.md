# App Store Analytics: Kimball Data Warehouse

**SQL Server | T-SQL | Kimball Dimensional Modelling | Star Schema**

An end-to-end data warehouse built on Microsoft SQL Server for app-store analytics. It takes six raw CSV files through a staging layer, data profiling, cleaning and loading into a star schema, validation, indexing, six department-level data mart views, and 60 analytical queries.

---

## Table of Contents
1. [Architecture](#architecture)
2. [Star Schema](#star-schema)
3. [Dataset](#dataset)
4. [Project Structure](#project-structure)
5. [How to Run](#how-to-run)
6. [Data Cleaning Rules](#data-cleaning-rules)
7. [Data Marts](#data-marts)
8. [Analytical Queries](#analytical-queries)
9. [Key Design Decisions](#key-design-decisions)
10. [Known Limitations](#known-limitations)
11. [Possible Improvements](#possible-improvements)
12. [Author](#author)

---

## Architecture

```
CSV source files (6)
        |
        v
+--------------------+
|   Staging (Stg)    |  Raw copy of the CSVs, loosely typed
|  Stg.Load_Stg      |  TRUNCATE + BULK INSERT, timing, TRY...CATCH
+---------+----------+
          |
          v   Data Profiling (read-only)
          |
+---------+----------+
|   Warehouse (dw)   |  Star schema with PK/FK constraints
|  dw.Load_DW        |  Cleans and loads: dimensions first, fact last
+---------+----------+
          |
          v   Data Validation (staging vs DW) + Indexes
          |
+---------+------------------------------------------+
|  Data Marts (6 views)                              |
|  Marketing | Finance | Product | Regional |        |
|  Device | Executive                                |
+---------+------------------------------------------+
          |
          v
   60 analytical queries (10 per mart)
```

See also `Files/architecture_diagram.html` and `Images/`.

---

## Star Schema

One fact table surrounded by five dimension tables (see `Images/Star Schema.png`).

```
                 dim_date                       dim_app
               (date_key PK)                  (app_key PK)
                      \                          /
                       \                        /
 dim_user ------------ fact_app_events ------------ dim_store_region
(user_key PK)           (fact_key PK)              (region_key PK)
                              |
                         dim_device
                       (device_key PK)
```

**Grain of the fact table:** one row per app event (a user performs an action on an app, on a date, on a device, in a store region).

**fact_app_events columns**

| Column | Type | Notes |
|---|---|---|
| fact_key | INT, PK | Unique event ID |
| date_key, app_key, user_key, device_key, region_key | INT, NOT NULL, FK | Reference the five dimensions |
| event_type | NVARCHAR(15) | Download, Purchase, Review, Update, Uninstall |
| revenue_usd | DECIMAL(12,2) | Additive measure; negative values kept (possible refunds) |
| session_minutes | DECIMAL(10,2) | Additive measure |
| rating | INT | Non-additive; averaged |
| review_text_len | INT | Measure |
| install_source | NVARCHAR(15) | Organic, Paid, Referral |
| app_version | NVARCHAR(10) | e.g. 1.0, 1.1, 2.0, 2.0.1, 2.1 |
| discount_pct | DECIMAL(5,2) | Non-additive; averaged |

---

## Dataset

Six CSV files in the `Datasets/` folder.

| Table | Rows | Description |
|---|---|---|
| fact_app_events | 120,500 | Events: download, purchase, review, update, uninstall |
| dim_user | 10,000 | User demographics and premium flag |
| dim_app | 30 | App name, category, developer, platform, price, content rating, release year, size |
| dim_date | 1,461 | Calendar days, 2021-01-01 to 2024-12-31 |
| dim_device | 10 | Device type, OS version, manufacturer, screen size |
| dim_store_region | 5 | Region name, store currency, tax rate |

The raw files contain realistic data quality problems (mixed casing, inconsistent formats, NULLs, blank values, invalid numbers), which is what the profiling and cleaning steps address.

> **Note:** values in the dataset are close to uniformly distributed (for example, average session length is about 60 minutes in every age group). The analytical queries therefore demonstrate SQL technique and the warehouse design; they are not evidence of real business trends.

---

## Project Structure

```
Kimball-DataWarehouse-Architecture/
|
|-- README.md
|-- Datasets/
|     |-- dim_app.csv
|     |-- dim_date.csv
|     |-- dim_device.csv
|     |-- dim_store_region.csv
|     |-- dim_user.csv
|     `-- fact_app_events.csv
|-- Files/
|     |-- PROJECT_SUMMARY.md
|     `-- architecture_diagram.html
|-- Images/
|     |-- Kimball.jpeg
|     `-- Star Schema.png
`-- Scripts/
      |-- 01_Database_Schema_Creation/
      |     `-- DB and Schema creation.sql
      |-- 02_Staging/
      |     |-- 01_ddl_staging.sql
      |     `-- 02_procLoad_Staging.sql
      |-- 03_Data_Profiling/
      |     `-- Data Profiling.sql
      |-- 04_DW_Layer/
      |     |-- 01_ddl_dw.sql
      |     `-- 02_procLoad_dw.sql
      |-- 05_Data_Validation/
      |     `-- Data Validation.sql
      |-- 06_Indexes/
      |     `-- Indexes.sql
      |-- 07_Data_Marts/
      |     `-- DataMarts.sql
      `-- 08_Analytical_Queries/
            `-- Analytical Queries.sql
```

---

## How to Run

**Prerequisites:** Microsoft SQL Server and SSMS. Copy the six CSV files from `Datasets/` to the root of the `C:\` drive (the staging procedure reads `C:\dim_app.csv`, `C:\dim_user.csv`, etc.), or edit the paths inside `02_procLoad_Staging.sql`.

Run the scripts in this order:

| Step | Script | What it does |
|---|---|---|
| 1 | `01_Database_Schema_Creation/DB and Schema creation.sql` | Creates database `AppAnalytics` and schemas `Stg` and `dw` |
| 2 | `02_Staging/01_ddl_staging.sql` | Creates the six staging tables |
| 3 | `02_Staging/02_procLoad_Staging.sql` | Creates `Stg.Load_Stg` and executes it (the script ends with `EXEC Stg.Load_Stg;`) |
| 4 | `03_Data_Profiling/Data Profiling.sql` | Read-only profiling of every column (no data is modified) |
| 5 | `04_DW_Layer/01_ddl_dw.sql` | Creates five dimensions and the fact table with PK/FK constraints |
| 6 | `04_DW_Layer/02_procLoad_dw.sql` | Creates `dw.Load_DW` and executes it (the script ends with `EXEC dw.Load_DW;`) |
| 7 | `05_Data_Validation/Data Validation.sql` | Compares staging and DW |
| 8 | `06_Indexes/Indexes.sql` | Creates six non-clustered indexes on the fact table |
| 9 | `07_Data_Marts/DataMarts.sql` | Creates six mart views |
| 10 | `08_Analytical_Queries/Analytical Queries.sql` | 60 business queries |

### Staging load (`Stg.Load_Stg`)
For each of the six tables: `TRUNCATE TABLE`, then `BULK INSERT` with `FIRSTROW = 2`, `FIELDTERMINATOR = ','`, `ROWTERMINATOR = '0x0a'`. Prints the load duration per table. Wrapped in `TRY...CATCH`, which prints the error message, number and state.

### Warehouse load (`dw.Load_DW`)
1. Disable constraints (`NOCHECK CONSTRAINT ALL`)
2. `DELETE` from the fact table first, then from each dimension
3. Re-enable constraints (`WITH CHECK CHECK CONSTRAINT ALL`)
4. `INSERT ... SELECT` from staging into the five dimensions, then into the fact table last, applying the cleaning rules below
5. Prints the load duration per table, with `TRY...CATCH` error handling

Because the load is a full delete-and-reload, running it again gives the same result.

---

## Data Cleaning Rules

Profiling (`Data Profiling.sql`) identified the issues. The rules below are exactly what `dw.Load_DW` applies.

| Table | Column | Issue found | Rule applied |
|---|---|---|---|
| dim_app | app_name | Inconsistent casing | `TRIM`, first letter upper-case, rest lower-case |
| dim_app | platform | android / ANDROID / ios / IOS / both ... | Mapped to Android, iOS, else Both |
| dim_app | price_usd, size_mb | Float values | Rounded to 2 decimals (DECIMAL) |
| dim_app | release_year | Float (`2020.0`) with NULLs | Cast to SMALLINT; NULL kept |
| dim_app | content_rating | NULLs | Not changed (NULL kept) |
| dim_device | device_type | smartphone / TABLET ... | Mapped to Smartphone, Tablet, PC, Smartwatch; unmatched or NULL stays NULL |
| dim_date | month_name | Casing | First letter upper-case, rest lower-case |
| dim_date | is_weekend | `True` / `False` strings | Converted to BIT (1/0) |
| dim_user | gender | male / MALE / M / F / Other / O / blank | M and male become Male; F and female become Female; everything else, including Other and NULL, becomes Unknown |
| dim_user | age_group | `25 to 34`, `25_34`, leading spaces, NULL | `TRIM`, `_` and ` to ` replaced by `-`; NULL becomes Unknown |
| dim_user | city | NULL, blank, `N/A` | Replaced with Unknown |
| dim_user | email_domain | NULLs | Not changed (NULL kept) |
| dim_user | is_premium | 0, 1, yes, Yes, NO, NULL | yes / true / 1 become 1; everything else, including NULL, becomes 0 |
| fact | event_type | download / DOWNLOAD / Download ... | `TRIM`, first letter upper-case, rest lower-case (12 spellings become 5 values) |
| fact | install_source | Mixed casing, NULLs | Same casing rule; NULL kept |
| fact | app_version | `v2.0` vs `2.0`, NULLs | `v` removed and trimmed; NULL kept |
| fact | discount_pct | Negative values, NULLs | Negative becomes 0; NULL becomes 0 |
| fact | revenue_usd, session_minutes, rating, review_text_len | NULLs | Not changed. A NULL means "not recorded"; replacing it with 0 would distort averages |

Negative `revenue_usd` values are kept on purpose, since they may represent refunds.

---

## Data Marts

Each mart is a **view** over the star schema, pre-joined for one team. Views avoid duplicating data and are always current.

| View | Team | Joins fact to | Key columns |
|---|---|---|---|
| `dw.vw_Marketing_mart` | Marketing | user, date, app | gender, age_group, country, city, install_source, session_minutes, revenue |
| `dw.vw_Finance_mart` | Finance | user, date, app, region | revenue, discount_pct, app_version, price, region, tax rate |
| `dw.vw_Product_mart` | Product | user, date, app, device | rating, session_minutes, review_text_len, device type, OS, app size |
| `dw.vw_Regional_mart` | Regional managers | user, date, app, region | region, currency, tax rate, revenue, discount, country |
| `dw.vw_Device_mart` | Technology | device, user, date, app | device type, OS, manufacturer, screen size, rating, session |
| `dw.vw_Executive_mart` | Management | user, date, app, region | revenue, session, rating, discount, region, platform, demographics |

---

## Analytical Queries

`Analytical Queries.sql` contains **60 queries, 10 per mart**.

SQL techniques used: `GROUP BY` aggregation, `COUNT(DISTINCT)`, `CASE` for bucketing and pivot-style output, `NULLIF` for safe division, the **`LAG()`** window function (year-over-year and monthly revenue), and a **CTE** (discount versus no-discount purchases).

Example queries:

```sql
-- Which install source brings the highest-quality users?
SELECT install_source,
       COUNT(DISTINCT user_key)       AS users_count,
       ROUND(AVG(revenue_usd), 2)     AS revenue_usd,
       ROUND(AVG(session_minutes), 2) AS session_mins
FROM dw.vw_Marketing_mart
GROUP BY install_source
ORDER BY revenue_usd DESC, session_mins DESC;

-- Year-over-year revenue growth
SELECT YEAR, revenue_usd,
       LAG(revenue_usd, 1, 0) OVER (ORDER BY YEAR) AS prevSales,
       revenue_usd - LAG(revenue_usd, 1, 0) OVER (ORDER BY YEAR) AS RevenueGrowth
FROM (
    SELECT YEAR, SUM(revenue_usd) AS revenue_usd
    FROM dw.vw_Finance_mart
    GROUP BY YEAR
) T;
```

---

## Performance: Indexes

Created after the data load (`Indexes.sql`):

```sql
CREATE INDEX IX_fact_date       ON dw.fact_app_events(date_key);
CREATE INDEX IX_fact_app        ON dw.fact_app_events(app_key);
CREATE INDEX IX_fact_user       ON dw.fact_app_events(user_key);
CREATE INDEX IX_fact_device     ON dw.fact_app_events(device_key);
CREATE INDEX IX_fact_region     ON dw.fact_app_events(region_key);
CREATE INDEX IX_fact_event_type ON dw.fact_app_events(event_type);
```

The primary key on `fact_key` also provides a clustered index.

---

## Key Design Decisions

| Decision | Reason |
|---|---|
| Separate `Stg` and `dw` schemas | Raw data stays untouched; cleaning can be re-run from staging |
| Loose types in staging (NVARCHAR, FLOAT) | The CSVs contain values like `2020.0`, `True`, `yes`; loading must not fail |
| Proper types in the DW (DECIMAL, BIT, SMALLINT) | Exact money values and compact, typed columns |
| Case-sensitive collation (`Latin1_General_CS_AS`) when profiling | SQL Server's default collation is case-insensitive and would hide `male` vs `MALE` |
| `DELETE` instead of `TRUNCATE` in the DW load | TRUNCATE is blocked on any table referenced by a foreign key |
| Dimensions loaded before the fact table | Fact foreign keys must already exist in the dimensions |
| Descriptive NULLs to `Unknown` (city, age_group, gender) | Cleaner GROUP BY output |
| Fact measure NULLs kept | NULL means "not recorded"; 0 would distort averages |
| Negative discount set to 0 | A negative discount is not valid |
| Negative revenue kept | May represent refunds |
| Data marts as views | No duplicate storage, always up to date |
| Indexes created after loading | Faster load than inserting into indexed tables |

---

## Known Limitations

Documented here so the project description stays honest.

- **Full reload only.** No incremental loading and no slowly changing dimensions (all dimensions behave as Type 1).
- **Surrogate keys come from the source CSVs**, not generated by the warehouse.
- **Out-of-range ratings are not cleaned.** The 1-5 scale contains values 0 and 6 (4,877 rows).
- **Duplicate business keys.** `user_id` USR000001 and USR000002 each appear twice in `dim_user` (different `user_key`); they are not de-duplicated.
- **Unknown handling is partial.** `email_domain`, `install_source`, `app_version`, `content_rating` and device attributes keep NULL; `is_premium` NULL becomes 0 (non-premium); "Other" gender becomes Unknown.
- **Descriptors in the fact table.** `event_type`, `install_source` and `app_version` are text columns on the fact; a junk dimension would be the stricter Kimball design.
- **Error handling is print-only.** No logging table, no re-throw and no transaction around the load.
- **Validation is manual.** Staging-versus-DW comparisons are queries you inspect, not automated pass/fail checks.
- **Hard-coded file paths** in the staging procedure.
- **Some query wording versus logic:** a few questions say "rate" or "highest" but return counts or ascending order, and the monthly-revenue `LAG` in the Executive mart orders by `month_name` rather than `month`.
- **Synthetic-looking data.** Results across groups are nearly identical, so the queries are not business findings.

## Possible Improvements

Incremental loads with a watermark and `MERGE`; SCD Type 2 for users and apps; a junk dimension for event type, install source and app version; unknown-member rows in each dimension; quarantine table for invalid rows (for example ratings outside 1-5); automated validation assertions with a data-quality log; SQL Server Agent or Azure Data Factory scheduling; clustered columnstore index for larger volumes; Power BI on top of the marts.

---

## Author

**Poojitha**: Data Engineering Project, 2026

*Built with SQL Server and Kimball dimensional modelling.*
