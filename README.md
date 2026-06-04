# 🏗️ App Store Analytics — Kimball Data Warehouse
### Built with SQL Server | Kimball Dimensional Modelling | Star Schema

---

## 📌 Project Overview

A complete **end-to-end Kimball Data Warehouse** built on **Microsoft SQL Server** for App Store Analytics. This project covers the full data engineering lifecycle — from raw CSV ingestion to business-ready analytical queries across 6 data marts.

> **Goal:** Transform raw app store data into a clean, performant, queryable star schema that answers real business questions for marketing, finance, product, regional, device and executive teams.

---

## 🏛️ Architecture

```
📂 CSV Source Files
        │
        ▼
┌─────────────────┐
│   Staging Layer  │  ← Raw data loaded via Stored Procedure (SP1)
│  (Stg schema)   │  ← NVARCHAR columns — accepts everything safely
└────────┬────────┘
         │
         ▼  [Data Profiling → Data Cleaning]
         │
┌─────────────────┐
│   DW Layer      │  ← Cleaned data loaded via Stored Procedure (SP2)
│  (DW schema)    │  ← Star Schema with PK/FK constraints
│                 │
│  ┌───────────┐  │
│  │ dim_date  │  │
│  │ dim_app   │  │
│  │ dim_user  │──┼──→  fact_app_events
│  │ dim_device│  │
│  │ dim_region│  │
│  └───────────┘  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│              Data Marts (Views)          │
│  Marketing | Finance | Product          │
│  Regional  | Device  | Executive        │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  60 Analytical  │
│    Queries      │
└─────────────────┘
```

---

## ⭐ Star Schema

```
                    DW.dim_date
                    (date_key PK)
                         │
                         │
DW.dim_user ─────────────┼─────────── DW.dim_app
(user_key PK)            │            (app_key PK)
                         │
              DW.fact_app_events
              (fact_key PK)
              ├── date_key FK
              ├── app_key FK
              ├── user_key FK
              ├── device_key FK
              ├── region_key FK
              ├── revenue_usd
              ├── session_minutes
              ├── rating
              ├── discount_pct
              └── event_type
                         │
DW.dim_device ───────────┼─────────── DW.dim_store_region
(device_key PK)                       (region_key PK)
```

---

## 📁 Project Structure

```
App-Store-Analytics-DWH/
│
├── 📄 README.md
│
├── 📂 1_Database_Schema_Creation/
│     └── create_database_schemas.sql
│         └── Creates: AppAnalytics DB, Stg schema, DW schema
│
├── 📂 2_Staging/
│     ├── create_staging_tables.sql
│     │   └── 6 staging tables with NVARCHAR types for safe loading
│     └── SP1_load_staging.sql
│         └── Stored Procedure: TRUNCATE → BULK INSERT with timing + TRY-CATCH
│
├── 📂 3_Data_Profiling/
│     └── data_profiling.sql
│         └── DISTINCT, COUNT, NULL checks, MAX/MIN/AVG for all columns
│
├── 📂 4_Data_Cleaning/
│     └── cleaning_queries.sql
│         └── SELECT statements tested before INSERT into DW
│
├── 📂 5_DW_Layer/
│     ├── create_dw_tables.sql
│     │   └── Star schema with PRIMARY KEY + FOREIGN KEY constraints
│     └── SP2_load_dw.sql
│         └── Stored Procedure: NOCHECK FK → DELETE fact → TRUNCATE dims → INSERT
│
├── 📂 6_Data_Validation/
│     └── data_validation.sql
│         └── Staging vs DW comparison using UNION ALL
│
├── 📂 7_Indexes/
│     └── indexes.sql
│         └── Non-clustered indexes on all FK columns + event_type
│
├── 📂 8_Data_Marts/
│     └── data_marts.sql
│         └── 6 Views: Marketing, Finance, Product, Regional, Device, Executive
│
└── 📂 9_Analytical_Queries/
      └── analytical_queries.sql
          └── 60 business queries across 6 data marts
```

---

## 📊 Dataset

| Table | Rows | Description |
|---|---|---|
| `fact_app_events` | 120,500 | Core events: download, purchase, review, update, uninstall |
| `dim_user` | 10,000 | User demographics and premium status |
| `dim_app` | 30 | App metadata, categories, platforms |
| `dim_date` | 1,461 | Calendar table (2021–2024) |
| `dim_device` | 10 | Device types, OS versions, manufacturers |
| `dim_store_region` | 5 | Regional store info, currencies, tax rates |

---

## 🔧 Tech Stack

| Tool | Purpose |
|---|---|
| **SQL Server** | Database engine |
| **SSMS** | Development environment |
| **T-SQL** | All data engineering code |
| **GitHub** | Version control |

---

## 🚀 How to Run This Project

### Step 1 — Create Database & Schemas
```sql
-- Run: 1_Database_Schema_Creation/create_database_schemas.sql
```

### Step 2 — Create Staging Tables
```sql
-- Run: 2_Staging/create_staging_tables.sql
```

### Step 3 — Load Raw Data into Staging
```sql
-- Update CSV file paths in SP, then run:
EXEC Stg.load_data;
```

### Step 4 — Data Profiling
```sql
-- Run: 3_Data_Profiling/data_profiling.sql
-- Understand every column before cleaning
```

### Step 5 — Data Cleaning
```sql
-- Run: 4_Data_Cleaning/cleaning_queries.sql
-- Review SELECT results before loading to DW
```

### Step 6 — Create DW Tables
```sql
-- Run: 5_DW_Layer/create_dw_tables.sql
```

### Step 7 — Load Cleaned Data into DW
```sql
EXEC DW.load_data;
```

### Step 8 — Validate Data Quality
```sql
-- Run: 6_Data_Validation/data_validation.sql
```

### Step 9 — Create Indexes
```sql
-- Run: 7_Indexes/indexes.sql
```

### Step 10 — Create Data Marts
```sql
-- Run: 8_Data_Marts/data_marts.sql
```

### Step 11 — Run Analytical Queries
```sql
-- Run: 9_Analytical_Queries/analytical_queries.sql
```

---

## 🧹 Data Cleaning Summary

| Column | Issue Found | Fix Applied |
|---|---|---|
| `gender` | male, MALE, M mixed | Standardized to Male/Female/Other/Unknown |
| `is_premium` | 0, 1, yes, no mixed | Converted to BIT (0/1) |
| `platform` | android, ANDROID mixed | Standardized to Android/iOS/Both |
| `device_type` | smartphone, TABLET mixed | Standardized to Smartphone/Tablet/PC/Smartwatch |
| `age_group` | 25_34, 25 to 34 mixed | Standardized to 25-34 format |
| `city` | NULL, empty, N/A | Replaced with 'Unknown' |
| `email_domain` | NULL values | Replaced with 'Unknown' |
| `content_rating` | NULL values | Replaced with 'Not Rated' |
| `release_year` | FLOAT with NULLs | Cast to INT, NULLs preserved |
| `discount_pct` | Negative values | Replaced with 0 |
| `is_weekend` | True/False string | Converted to BIT (1/0) |
| `install_source` | NULL values | Replaced with 'Unknown' |
| `app_version` | NULL values | Replaced with 'Unknown' |

---

## 🏪 Data Marts

| Mart | Target Team | Key Columns |
|---|---|---|
| `vw_Marketing_mart` | Marketing | gender, age_group, install_source, session_minutes |
| `vw_Finance_mart` | Finance | revenue_usd, discount_pct, region, price_usd |
| `vw_Product_mart` | Product | rating, session_minutes, device_type, app_name |
| `vw_Regional_mart` | Regional Managers | region_name, currency, tax_rate, revenue |
| `vw_Device_mart` | Tech/Engineering | device_type, os_version, manufacturer, screen_size |
| `vw_Executive_mart` | Management | All KPIs — revenue, rating, session, downloads |

---

## 📈 Sample Analytical Queries

### Which install source brings highest quality users?
```sql
SELECT install_source,
       COUNT(DISTINCT user_key) users_count,
       ROUND(AVG(revenue_usd),2) avg_revenue,
       ROUND(AVG(session_minutes),2) avg_session
FROM DW.vw_Marketing_mart
GROUP BY install_source
ORDER BY avg_revenue DESC
```

### Year over year revenue growth?
```sql
SELECT YEAR, revenue_usd,
       LAG(revenue_usd,1,0) OVER(ORDER BY YEAR) AS prev_year,
       revenue_usd - LAG(revenue_usd,1,0) OVER(ORDER BY YEAR) AS growth
FROM (
    SELECT YEAR, SUM(revenue_usd) AS revenue_usd
    FROM DW.vw_Finance_mart
    GROUP BY YEAR
) T
```

### Which manufacturer has lowest uninstall rate?
```sql
SELECT manufacturer,
       SUM(CASE WHEN event_type='Uninstall' THEN 1 ELSE 0 END) uninstall_rate
FROM DW.vw_Device_mart
GROUP BY manufacturer
ORDER BY uninstall_rate ASC
```

---

## ⚡ Performance Optimizations

```sql
-- Non-clustered indexes on all FK columns
CREATE INDEX IX_fact_date_key   ON DW.fact_app_events(date_key);
CREATE INDEX IX_fact_app_key    ON DW.fact_app_events(app_key);
CREATE INDEX IX_fact_user_key   ON DW.fact_app_events(user_key);
CREATE INDEX IX_fact_device_key ON DW.fact_app_events(device_key);
CREATE INDEX IX_fact_region_key ON DW.fact_app_events(region_key);
CREATE INDEX IX_fact_event_type ON DW.fact_app_events(event_type);
```

---

## 💡 Key Design Decisions

| Decision | Reason |
|---|---|
| NVARCHAR in staging | Accept any format safely — staging job is safe loading |
| Manual cleaning (no SP) | Complex business logic needs human verification at each step |
| DELETE before TRUNCATE | FK constraints block TRUNCATE — DELETE fact first to free dims |
| NOCHECK CONSTRAINT | Temporarily disable FK to allow TRUNCATE on dim tables |
| NULL → Unknown in dims | Business queries group by dimensions — NULL causes confusion |
| NULL kept in fact measures | revenue NULL = event didn't generate revenue — meaningful! |
| Views for Data Marts | No data duplication, always fresh, true Kimball approach |

---

## 🎓 What I Learned

- **Kimball Architecture** — Star schema design principles
- **ETL Pipeline** — Staging → Cleaning → DW loading with stored procedures
- **Data Profiling** — Systematic column analysis using COLLATE, COUNT, MAX/MIN
- **Data Quality** — Handling NULLs, casing issues, negative values, encoding issues
- **SQL Server Internals** — FK constraints, TRUNCATE vs DELETE, NOCHECK, COLLATE
- **Window Functions** — LAG for trend analysis
- **CTEs** — Complex comparisons like discount impact
- **Indexing Strategy** — Non-clustered indexes on FK and filter columns

---

## 👤 Author

**Kanishka** — Data Engineering Project | 2026

---

*Built with ❤️ using SQL Server and Kimball dimensional modelling*
