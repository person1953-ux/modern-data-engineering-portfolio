# ETL Pipeline: Oracle to Tableau

## Overview
This project implements an ETL pipeline that reads inventory data from a CSV file, loads it into an Oracle database, and provides the data for Tableau dashboards. The goal is to automate inventory data integration for real-time manufacturing analytics and reporting.

## Architecture / Workflow

flowchart TD
  subgraph Data_Source
    A[Inventory CSV File]
  ```mermaid
  flowchart LR
    A([Inventory CSV File])
    B([Python ETL Script])
    C([Oracle Table: inventorylot])
    D([Tableau Dashboard])
    E([Manufacturing Analytics])

    A -->|Extract & Transform| B
    B -->|Load| C
    C -->|Data Source| D
    D -->|Visualization| E
  ```
1. Install Python 3.x.
2. Install dependencies:
   ```
   pip install pandas oracledb
   ```
3. Configure Oracle database connection in the script.
4. Place `inventorylot.csv` in the project directory.
5. Schedule the ETL job using cron (or Task Scheduler on Windows) to run at 7:05 am and 7:05 pm daily.

## Process
1. **Extract**: Read inventory data from the CSV file.
2. **Transform**: Clean and normalize data to match the Oracle table schema.
3. **Load**: Insert the transformed data into the Oracle `inventorylot` table.
4. **Dashboard**: Tableau connects to the Oracle table to visualize inventory status.

## Output / Results
- Data available in:
  - **Oracle Table**: `inventorylot` (used by Tableau)
  - **Tableau Dashboard**: Visualizes lot inventory, arrival date, and estimated ship date
- Log file: `log_file.txt` for monitoring ETL steps.

## Technologies Used
- Python (pandas, oracledb)
- Oracle Database
- Tableau
- UNIX cron (for scheduling)
