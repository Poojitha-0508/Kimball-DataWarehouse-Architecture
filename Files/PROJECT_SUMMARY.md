# 📋 Project Summary — App Store Analytics DWH

## Quick Reference Card

---

## 🔑 Key Concepts Used

### Kimball Architecture
| Concept | What it means | In this project |
|---|---|---|
| **Star Schema** | Fact table in center, dims around it | fact_app_events + 5 dim tables |
| **Fact Table** | Stores measurable events/numbers | revenue, sessions, ratings |
| **Dimension Table** | Stores descriptive context | who, what, where, when |
| **Data Mart** | Focused view for one department | 6 views for 6 teams |
| **Staging** | Raw data holding area | Stg schema |

---

## 🗂️ Schema Design Decisions

### Why Two Schemas?
```
Stg schema  → raw data (never modified after loading)
DW schema   → clean data (star schema with constraints)
```

### Why NVARCHAR in Staging?
```
CSV may have '2020.0' not '2020' for year
CSV may have 'True\r' not 'True' for boolean
NVARCHAR accepts anything safely
DW applies proper types during INSERT
```

### Why DELETE not TRUNCATE for fact table?
```
TRUNCATE is blocked on tables with FK constraints
DELETE works even with FK constraints
Fix: NOCHECK FK → TRUNCATE dims → INSERT → CHECK FK
```

---

## 🧹 Cleaning Rules Applied

### Text Columns → TRIM + Standardize
```sql
TRIM(column)                           -- remove spaces
UPPER/LOWER + CASE                     -- standardize casing
REPLACE(col, CHAR(13), '')             -- remove hidden \r
ISNULL(col, 'Unknown')                 -- NULL → Unknown
```

### Numeric Columns → Keep NULL or Fix
```sql
-- Discount: negative = impossible → 0
CASE WHEN discount_pct < 0 THEN 0 ELSE ISNULL(discount_pct,0) END

-- Revenue: negative = possible refund → keep as is
revenue_usd  -- no change

-- release_year: NULL = unknown → keep NULL
CASE WHEN release_year IS NULL THEN NULL ELSE CAST(release_year AS INT) END
```

---

## ⚡ SP1 — Staging Load
```
Create SP → TRUNCATE all staging → BULK INSERT each CSV
Features: timing per table, batch timing, TRY-CATCH
```

## ⚡ SP2 — DW Load
```
NOCHECK CONSTRAINT ALL (disable FK)
DELETE fact_app_events (empty fact first)
TRUNCATE + INSERT each dim table
INSERT fact_app_events last
CHECK CONSTRAINT ALL (re-enable FK)
Features: timing per table, batch timing, TRY-CATCH
```

---

## 📊 Data Profiling Checklist

For every TEXT column:
- [ ] DISTINCT with COLLATE Latin1_General_CS_AS
- [ ] GROUP BY COUNT to see distribution
- [ ] NULL count: COUNT(*)-COUNT(col)

For every NUMERIC column:
- [ ] MAX, MIN, AVG, COUNT(*), NULL count in one query
- [ ] Drill down on suspicious values (negatives etc)

---

## ✅ Data Validation Checklist

- [ ] Row count: Staging rows = DW rows (no data lost)
- [ ] Text columns: UNION ALL staging vs DW to see before/after
- [ ] NULL columns: Staging nulls → DW 'Unknown' count
- [ ] Numeric columns: MIN should not be negative in DW
- [ ] discount_pct: Staging negatives > 0 → DW negatives = 0
- [ ] is_weekend: Staging True/False → DW 1/0

---

## 🏪 Mart Selection Logic

| If query needs | Use this mart |
|---|---|
| User demographics + behaviour | Marketing_Mart |
| Revenue + discounts + region | Finance_Mart |
| App ratings + sessions + device | Product_Mart |
| Region + currency + tax | Regional_Mart |
| Device type + OS + manufacturer | Device_Mart |
| Overall KPIs for management | Executive_Mart |

---

## 📈 Advanced SQL Used

| Feature | Used for |
|---|---|
| `LAG()` | Year over year revenue growth |
| `CTE` | Discount impact comparison |
| `NULLIF()` | Safe division (avoid divide by zero) |
| `COLLATE` | Case-sensitive text comparison |
| `COALESCE` | NOT used for ratings (would distort AVG) |
| `CASE` | Pivot-style queries, standardization |
| `COUNT(DISTINCT)` | Unique user counts |
| `CHAR(13)` | Remove hidden carriage return from CSV |

---

## 🎯 Interview Talking Points

1. **Why Kimball?** Business-first design — star schema designed for how teams ask questions, not how data arrives

2. **Why manual cleaning?** Complex logic needs human verification — SELECT first, verify, then INSERT

3. **Why staging?** Safety net — original data preserved even if cleaning goes wrong

4. **FK loading order?** Dims first, fact last (FK constraint) — or use NOCHECK + DELETE + TRUNCATE approach

5. **Indexes?** Non-clustered on all FK columns + event_type — reduces full table scans on 120,500 rows

6. **Data Marts vs Warehouse?** Mart = focused VIEW for one team — no duplication, always fresh, true Kimball

7. **NULL handling?** Dimension NULLs → Unknown (for clean GROUP BY), Fact measure NULLs → kept (meaningful absence)
