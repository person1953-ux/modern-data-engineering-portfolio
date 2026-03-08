
## Modern Data Platform: 1000+ ETL Jobs Automation
This project leverages Apache Airflow to orchestrate and automate the execution of up to 1000+ ETL jobs on Databricks (Using Job Clusters)
Instead of pre-building 1000 individual Databricks jobs, the Airflow DAG dynamically creates and manages Databricks jobs at runtime based on configuration files, 
enabling scalable and maintainable ETL automation.

## Tech Stack
- **Apache Airflow**: Workflow orchestrator to manage and schedule ETL pipelines.
- **Databricks**: Executes ETL jobs dynamically; jobs are created on-the-fly by Airflow at runtime, so there is no need to pre-build or maintain 1000 static Databricks jobs.
- **Python**: Primary language for Airflow DAGs and automation scripts.
- **YAML**: Used for configuration (e.g., job parameters in jobs.yaml).
- **SQL**: For data transformation and reporting logic.

## Key Features
- **Dynamic Job Generation**: Jobs are created at runtime using Airflow's `DatabricksSubmitRunOperator`. 
- **Concurrent Scheduling**: Airflow can schedule and execute multiple jobs in parallel, leveraging queue and parallelism settings.
- **Flexible Data Sources**: Supports extracting from various schemas and databases (e.g., production, reporting warehouse), including support for multiple sources in a single job.
- **ETL Query Types**:
  - **Simple**: 1 source → 1 target (same columns, inline query)
  - **SQL File**: Complex joins, SQL stored in files
  - **SQL Inline**: Quick aggregations, SQL defined in config
---
## Project Structure
```
config/
  jobs.yaml                # Job configurations (1000+ jobs)
sql/
  curated/
    order_details.sql      # Complex SQL joins
    customer_360.sql
    eqp_performance.sql
    eqp_summary.sql
    order_detail.sql
reporting/
  sales_summary.sql
  ...
dags/
  etl_dag.py              # Airflow DAGs
notebooks/
  etl_dynamic_pipeline.py          # Databricks notebook / etl pipeline jobs
```
---

## Hands-On Guide
## 1.Each job can specify source, target, schedule, and query type (simple, sql_file, sql_inline).
## 2. SQL Files
- Place complex SQL queries in `sql/curated/` or `sql/reporting/`.
- Reference these files in your job config for SQL_FILE jobs.
## 3. Airflow DAGs
- DAGs are auto-generated for each job using `DatabricksSubmitRunOperator`.
- Example DAG: `dags/etl_dag.py`
- Supports parallel execution and dynamic scheduling.
## 4. Databricks Notebook
- Use `notebooks/etl_dynamic_pipeline.py` for ETL logic.
- Notebooks are triggered by Airflow and receive parameters (env, run_date, job_name).
## 5. Run the Pipeline
- Start Airflow scheduler: `airflow scheduler`
- Trigger DAGs manually or let them run on schedule.
- Monitor job execution in Airflow UI and Databricks workspace.
---
## Example Job Config (YAML)
```yaml
jobs:
  - job_name: "etl_customers"
    source: "raw.customers"
    target: "curated.customers"
    type: "simple"
    schedule: "0 1 * * *"
  - job_name: "etl_order_details"
    sql_file: "sql/curated/order_details.sql"
    target: "curated.order_details"
    type: "sql_file"
    schedule: "0 2 * * *"
  - job_name: "etl_metrics"
    sql_inline: "SELECT COUNT(*) AS total_orders FROM raw.orders WHERE order_date >= '{{ ds }}'"
    target: "reporting.metrics"
    type: "sql_inline"
    schedule: "0 3 * * *"
```
---
## Airflow Parallelism Settings
Edit `airflow.cfg` to optimize parallel execution:
```
parallelism = 200
max_active_runs_per_dag = 10
dag_concurrency = 50
```
---

## ETL Query Types
| Type         | Source                        | Use Case                  |
|--------------|-------------------------------|---------------------------|
| simple       | Delta Table                   | Same columns, basic clean |
| jdbc         | PostgreSQL/MySQL/SQL Server   | External DBs              |
| s3/adls      | AWS S3/Azure ADLS             | Cloud files               |
| sql_file     | SQL file with joins           | Complex transformations   |
| sql_inline   | Inline SQL                    | Quick aggregations        |

---

## Scheduling Examples
| Type             | Mode     | Use Case                | Schedule      |
|------------------|----------|-------------------------|---------------|
| simple           | OVERWRITE| Full refresh            | Daily         |
| insert           | APPEND   | History tables          | Hourly        |
| upsert           | MERGE    | CDC tables              | Every 5 mins  |
| sql_file         | OVERWRITE| Complex joins           | Daily         |
| sql_inline       | OVERWRITE| Quick aggregations      | Daily         |

---

## Monitoring & Troubleshooting
- Check Airflow logs for job status and errors.
- Review Databricks job runs for execution details.
- Validate data in target tables after ETL completion.

---

## Extending the Framework
- Add new job types or sources by updating `jobs.yaml` and SQL files.
- Scale parallelism by tuning Airflow and Databricks cluster settings.
- Integrate additional data quality checks or notifications as needed.
---

-LEGACY STACK
Year 1: $2,346,000 (mid-range)                                
Year 2: $2,346,000                                            
Year 3: $2,346,000 
Total : $7,038,000
  

-MODERN STACK
Year 1: $1,067,000 (includes migration: $200K)                
Year 2: $867,000                                              
Year 3: $867,000
Total : $2,801,000
  
ROI = (Net Savings - Migration Cost) / Migration Cost × 100
ROI = ($4,237,000 - $300,000) / $300,000 × 100
ROI = 1,312%

-3-Year ROI: 1,200% - 1,400%

-SAVING :  $7,038,000 - $2,801,000 = $4,237,000

Achieved 65-70% performance increase leveraging Databricks Photon engine, 
Delta Lake optimizations, and Airflow parallel orchestration

## References
- [Airflow Docs](https://airflow.apache.org/docs/)
- [Databricks Docs](https://docs.databricks.com/)







