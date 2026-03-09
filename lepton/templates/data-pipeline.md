# CLAUDE.md — Data Pipeline

<!-- Lepton Template: Data Pipeline v1.0 -->
<!-- For ETL, analytics, ML pipelines, and data engineering -->
<!-- Replace all [BRACKETS] with your project specifics -->

## Project

[PROJECT_NAME] — [one-line description].

- **Language**: [e.g., Python 3.13 | SQL + dbt | Scala + Spark]
- **Orchestrator**: [e.g., Airflow 2.x | Prefect 3 | Dagster | dbt Cloud | cron]
- **Storage**: [e.g., BigQuery | Snowflake | PostgreSQL | S3 + Parquet | DuckDB]
- **Processing**: [e.g., Pandas | Polars | PySpark | dbt | Beam]
- **Environment**: [e.g., venv | conda | Docker | Poetry]

## Pipeline Architecture

```
[PROJECT_NAME]/
  dags/                 # Orchestration DAGs (Airflow) or flows (Prefect)
    daily_etl.py
    weekly_reports.py
  pipelines/
    extract/            # Source connectors and extraction logic
    transform/          # Cleaning, validation, aggregation
    load/               # Destination writers
  models/               # dbt models / SQL transformations
    staging/            # 1:1 source mirrors, rename + retype
    intermediate/       # Joins, business logic
    marts/              # Final analytical tables
  schemas/              # Data contracts (JSON Schema, Pydantic, Great Expectations)
  tests/                # Pipeline tests (unit + integration)
  notebooks/            # Exploratory analysis (NOT production code)
  config/               # Environment configs, connection strings
  scripts/              # One-off utilities, backfills
```

## Code Standards

### Pipeline Design
- Every pipeline step is idempotent — safe to rerun without duplicating data
- Use UPSERT or MERGE, never INSERT without dedup logic
- Partition by date — every table has a `loaded_at` or `event_date` column
- Each step reads from one source and writes to one destination — no side effects
- Backfill-friendly: every pipeline accepts a date range parameter

### Data Quality
- Validate data at boundaries: after extraction (schema check) and before loading (quality check)
- Use [e.g., Great Expectations | Pydantic | dbt tests | Pandera] for data validation
- Required checks: null counts, uniqueness constraints, referential integrity, value ranges
- Alert on quality failures — don't silently load bad data
- Schema evolution: add columns freely, never remove or rename without migration

### SQL Style
- Keywords UPPERCASE: `SELECT`, `FROM`, `WHERE`, `JOIN`, `GROUP BY`
- Table/column names lowercase_snake: `user_events`, `created_at`
- CTEs over subqueries — one logical step per CTE
- Every query has a `WHERE` on the partition key for cost control
- Comments for business logic: `-- Exclude trial users (plan_type != 'trial')`
- Qualify all column references with table alias: `u.email`, not just `email`

### Python Style
- Type hints on all function signatures
- Docstrings on public functions: what it does, parameters, returns, raises
- Pandas/Polars: chain operations, avoid iterating rows
- Use `pathlib.Path` for file paths, never string concatenation
- Logging over print — structured logging with context (table name, row count, duration)

### Notebooks
- Notebooks are for exploration ONLY — never run notebooks in production
- If a notebook proves a concept, extract the logic into a proper pipeline module
- Notebooks are gitignored or committed as reviewed artifacts (clear outputs before commit)
- Never put credentials in notebooks

## Data Contracts

### Schema Definitions
- Define expected schemas for every source and destination table
- Schemas live in `schemas/` as [e.g., JSON Schema | Pydantic models | dbt schema.yml]
- Upstream schema changes detected by validation — pipeline fails fast, not silently

### Naming Conventions
- Sources: `raw_[source]_[entity]` (e.g., `raw_stripe_invoices`)
- Staging: `stg_[source]_[entity]` (e.g., `stg_stripe_invoices`)
- Intermediate: `int_[domain]_[description]` (e.g., `int_finance_monthly_revenue`)
- Marts: `[domain]_[entity]` (e.g., `finance_revenue`, `marketing_attribution`)

## Testing

- **Unit tests**: Transform functions with known input → expected output
- **Integration tests**: Full pipeline run against test dataset
- **Data tests**: Row counts, null checks, uniqueness, freshness (dbt tests or custom)
- Test data lives in `tests/fixtures/` — small, representative samples
- Run `[TEST_COMMAND]` before merging

## Credentials & Security

- Connection strings in environment variables — never in code or config files
- Use [e.g., AWS Secrets Manager | GCP Secret Manager | Vault | env vars] for production credentials
- Service accounts with least-privilege access — read-only for sources, write for destinations
- PII handling: mask or hash PII in staging tables, restrict access to raw tables
- Audit trail: log who ran what pipeline, when, how many rows affected

## Monitoring

- Every pipeline logs: start time, end time, rows extracted, rows loaded, errors
- Alert on: pipeline failure, SLA breach (didn't finish by expected time), data quality failure
- Dashboard: pipeline run history, data freshness per table, row count trends
- [e.g., Airflow UI | Prefect Cloud | Dagster Cloud | custom dashboard]

## Communication

- Describe changes in terms of data flow: "Extracts from [source], transforms [how], loads to [destination]"
- Reference table names and column names explicitly
- After schema changes, list downstream consumers that may be affected
- When adding sources, specify: refresh frequency, expected volume, SLA requirements
