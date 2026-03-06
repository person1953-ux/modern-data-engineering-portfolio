# ETL Pipeline: REST API to MySQL

## Overview
This project implements an ETL pipeline that extracts data from a REST API, transforms it, and loads it into a MySQL database. The code is modular, making it reusable for other projects and data sources.

## Architecture / Workflow

```mermaid
flowchart LR
    A([REST API]) -->|Extract| B([extract.py])
    B -->|Transform| C([transform.py])
    C -->|Load| D([load.py])
    D -->|Insert| E([MySQL Database])
    E -->|Query| F([Downstream Apps / Analytics])
```

## Project Structure
- **etl_rest_mysql.py**: Main ETL script and Model class for DB operations.
- **extract.py**: Extracts relevant fields from API responses.
- **transform.py**: Cleans and normalizes extracted data.
- **load.py**: Loads transformed data into MySQL tables.
- **readme**: Project documentation.
- **REST API insert into employees.person table.png**: Example output screenshot.
- **REST API insert into table mySQL table authors.png**: Example output screenshot.

## Setup
1. Install Python 3.x and MySQL server.
2. Install dependencies:
   ```
   pip install mysql-connector-python
   ```
3. Configure database credentials in the scripts or via environment variables.
4. Ensure the MySQL server is running and accessible.

## Process
1. **Extract**: Fetch data from the REST API using `extract.py`.
2. **Transform**: Clean and normalize the data using `transform.py`.
3. **Load**: Insert the data into MySQL tables using `load.py` and the Model class.

## Output / Results

- Data is available in MySQL tables (e.g., `authors`, `employees.person`).
- Example screenshots provided for successful inserts.

### Example: Insert into employees.person table
![Insert into employees.person table](REST%20API%20insert%20into%20employees.person%20table.png)

select * from employees.author


## Technologies Used
- Python (mysql-connector-python)
- MySQL
- REST API
