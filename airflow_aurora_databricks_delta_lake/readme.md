# Airflow + Databricks CDC ETL Project: Hands-On Summary

## Project Overview
This project demonstrates how to orchestrate a Databricks ETL job (Aurora Delta CDC) using Apache Airflow in a containerized environment. Airflow schedules and triggers a Databricks job via the DatabricksRunNowOperator, enabling automated, reliable data pipeline execution.

## Architecture & Components

- **Apache Airflow**: Workflow orchestration, scheduling, and monitoring.
- **Docker Compose**: Container management for Airflow, PostgreSQL, and Redis.
- **Databricks**: Cloud platform for running the Aurora Delta CDC ETL job.
- **PostgreSQL**: Metadata database for Airflow.
- **Redis**: Celery broker for distributed task execution.
- **DAGs Folder**: Contains Python DAG files, including aurora_delta_cdc_dag.py.

## Flow Chart

```
flowchart TD
    A[Airflow Scheduler] -->|Triggers DAG| B[DatabricksRunNowOperator]
    B -->|API Call| C[Databricks Job: Aurora Delta CDC]
    C -->|Job Status| D[Airflow Web UI]
```

## Task Execution Order

1. Airflow Scheduler triggers the DAG (aurora_delta_cdc_5min) every 5 minutes.
2. The DAG executes the DatabricksRunNowOperator task (run_databricks_etl_job).
3. DatabricksRunNowOperator sends an API request to Databricks to start the Aurora Delta CDC job (using the specified job_id).
4. Databricks runs the ETL job and returns the job status to Airflow.
5. Airflow Web UI displays the status and logs of the task execution.


- **Access Airflow Web UI:**
  Open http://localhost:8090 in browser

### CHECK AIRGLOW SCHEDULER TO CALL DATABRICKS JOB VERY 5 MINS ON CDC TYPE######

select *  from workspace.nhan_schema.eqp_status

BEORE RUN 

EQP_ID	STATUS	STEP	DEPARTMENT	LOT_ID	EVENT_TIME
EQP001	ONLINE	STEP1	Assembly	LOT1001	2024-02-01T09:10:00.000Z
EQP002	OFFLINE	STEP2	Testing	LOT1002	2024-02-02T10:00:00.000Z
EQP003	MAINTENANCE	STEP3	Repair	LOT1003	2024-02-03T08:15:23.000Z
EQP004	ONLINE	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z
EQP005	OFFLINE	STEP1	Logistics	LOT1005	2024-02-05T15:22:30.000Z

AFTER RUN 

EQP_ID	STATUS	STEP	DEPARTMENT	LOT_ID	EVENT_TIME  -->  NO CHANGE 
EQP003	MAINTENANCE	STEP3	Repair	LOT1003	2024-02-03T08:15:23.000Z
EQP014	NEW TOOL	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z  --> INSERT NEW TOOL 
EQP005	OFFLINE	STEP1	Logistics	LOT1005	2024-02-05T15:22:30.000Z   --> NO CHANGE 
EQP001	ONLINE	STEP1	Assembly	LOT1001	2024-02-01T09:10:00.000Z   --> NO CHANGE
EQP004	ONLINE	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z   --> NO CHANGE
EQP002	OFFLINE	STEP2	Testing	LOT1002	2024-02-02T10:00:00.000Z     --> NO CHANGE 

update workspace.nhan_schema.eqp_status set status = 'OK' 
WHERE EQP_ID <> 'EQP014'

AFTER UPDATE: 
EQP_ID	STATUS	STEP	DEPARTMENT	LOT_ID	EVENT_TIME
EQP001	OK	STEP1	Assembly	LOT1001	2024-02-01T09:10:00.000Z
EQP002	OK	STEP2	Testing	LOT1002	2024-02-02T10:00:00.000Z
EQP003	OK	STEP3	Repair	LOT1003	2024-02-03T08:15:23.000Z
EQP004	OK	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z
EQP005	OK	STEP1	Logistics	LOT1005	2024-02-05T15:22:30.000Z
EQP014	NEW TOOL	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z

NEXT RUN - CDC APPLIED 
EQP_ID	STATUS	STEP	DEPARTMENT	LOT_ID	EVENT_TIME
EQP003	MAINTENANCE	STEP3	Repair	LOT1003	2024-02-03T08:15:23.000Z
EQP014	NEW TOOL	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z
EQP005	OFFLINE	STEP1	Logistics	LOT1005	2024-02-05T15:22:30.000Z
EQP001	ONLINE	STEP1	Assembly	LOT1001	2024-02-01T09:10:00.000Z
EQP004	ONLINE	STEP4	Assembly	LOT1004	2024-02-04T13:45:05.000Z
EQP002	OFFLINE	STEP2	Testing	LOT1002	2024-02-02T10:00:00.000Z


