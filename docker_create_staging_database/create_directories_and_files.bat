@echo off
setlocal enabledelayedexpansion
REM Define the base project directory
set "BASE_DIR=C:\Users\User\nhan\modern-data-platform-codebase\docker_create_staging_database"

REM Creating main project directory...
mkdir "%BASE_DIR%\db-release-testing"

REM Create Docker directory and its contents
mkdir "%BASE_DIR%\db-release-testing\docker\config\postgresql"

REM Create Dockerfile

echo # Use the official PostgreSQL image as the base > "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo FROM postgres:15 >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo. >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo # Set environment variables >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo ENV POSTGRES_DB=test >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo ENV POSTGRES_USER=postgres >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo ENV POSTGRES_PASSWORD=admin >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo. >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo # Optional: Copy custom configuration files >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo COPY config/postgresql/postgresql.conf /etc/postgresql/postgresql.conf >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo COPY config/postgresql/pg_hba.conf /etc/postgresql/pg_hba.conf >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo. >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo # Expose PostgreSQL port >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"
echo EXPOSE 5432 >> "%BASE_DIR%\db-release-testing\docker\Dockerfile"

REM Create docker-compose.yml

echo version: '3.8' > "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo. >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo services: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo   db-postgres: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     build: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       context: .. >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       dockerfile: docker/Dockerfile >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     container_name: test-postgres >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     ports: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - "5432:5432" >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     environment: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - POSTGRES_DB=test >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - POSTGRES_USER=postgres >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - POSTGRES_PASSWORD=admin >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     volumes: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - postgres_data:/var/lib/postgresql/data >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     networks: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo       - db-network >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo. >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo networks: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo   db-network: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo     driver: bridge >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo. >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo volumes: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"
echo   postgres_data: >> "%BASE_DIR%\db-release-testing\docker\docker-compose.yml"

REM Create PostgreSQL config files

echo # PostgreSQL custom config file > "%BASE_DIR%\db-release-testing\docker\config\postgresql\postgresql.conf"
echo # Add your custom configurations here >> "%BASE_DIR%\db-release-testing\docker\config\postgresql\postgresql.conf"

echo # PostgreSQL Host-Based Authentication configuration file > "%BASE_DIR%\db-release-testing\docker\config\postgresql\pg_hba.conf"
echo # Add your authentication rules here >> "%BASE_DIR%\db-release-testing\docker\config\postgresql\pg_hba.conf"

REM Create schema directory with sample SQL files
mkdir "%BASE_DIR%\db-release-testing\schema\baseline"
echo -- Script to create tablespaces > "%BASE_DIR%\db-release-testing\schema\baseline\01_create_tablespaces.sql"
echo CREATE TABLESPACE my_tablespace LOCATION '/var/lib/postgresql/data/my_tablespace'; >> "%BASE_DIR%\db-release-testing\schema\baseline\01_create_tablespaces.sql"

echo -- Script to create users > "%BASE_DIR%\db-release-testing\schema\baseline\02_create_users.sql"
echo CREATE USER my_user WITH PASSWORD 'password'; >> "%BASE_DIR%\db-release-testing\schema\baseline\02_create_users.sql"

REM Create migrations directory
mkdir "%BASE_DIR%\db-release-testing\schema\migrations\2024_01"
echo -- Migration to add a new column > "%BASE_DIR%\db-release-testing\schema\migrations\2024_01\001_add_new_column.sql"
echo ALTER TABLE test_table ADD COLUMN new_column VARCHAR(255^); >> "%BASE_DIR%\db-release-testing\schema\migrations\2024_01\001_add_new_column.sql"

REM Create data directories
mkdir "%BASE_DIR%\db-release-testing\data\reference_data"
echo -- Sample lookup tables > "%BASE_DIR%\db-release-testing\data\reference_data\01_lookup_tables.sql"
echo INSERT INTO lookup_table ^(id, name^) VALUES ^(1, 'Lookup1'^), ^(2, 'Lookup2'^); >> "%BASE_DIR%\db-release-testing\data\reference_data\01_lookup_tables.sql"

mkdir "%BASE_DIR%\db-release-testing\data\production_snapshot"
echo -- Sample production data snapshot > "%BASE_DIR%\db-release-testing\data\production_snapshot\prod_data_sanitized.sql"
echo INSERT INTO sample_table ^(column1, column2^) VALUES ^('Sample1', 'Data1'^); >> "%BASE_DIR%\db-release-testing\data\production_snapshot\prod_data_sanitized.sql"

REM Create releases directory with sample content
mkdir "%BASE_DIR%\db-release-testing\releases\release_2024_01\01_migrations"
echo -- Release migration script > "%BASE_DIR%\db-release-testing\releases\release_2024_01\01_migrations\001_create_new_feature.sql"
echo CREATE TABLE new_feature ^(id SERIAL PRIMARY KEY, feature_name VARCHAR(255^^)^); >> "%BASE_DIR%\db-release-testing\releases\release_2024_01\01_migrations\001_create_new_feature.sql"

mkdir "%BASE_DIR%\db-release-testing\releases\release_2024_01\02_data"
echo -- Sample data insertion for new feature > "%BASE_DIR%\db-release-testing\releases\release_2024_01\02_data\001_insert_reference_data.sql"
echo INSERT INTO new_feature ^(feature_name^) VALUES ^('Feature1'^), ^('Feature2'^); >> "%BASE_DIR%\db-release-testing\releases\release_2024_01\02_data\001_insert_reference_data.sql"

mkdir "%BASE_DIR%\db-release-testing\releases\release_2024_02"
echo # Release 2024_02 > "%BASE_DIR%\db-release-testing\releases\release_2024_02\README.md"
echo ## This folder contains migration scripts and data for Release 2024_02. >> "%BASE_DIR%\db-release-testing\releases\release_2024_02\README.md"

REM Create scripts directory with sample scripts
mkdir "%BASE_DIR%\db-release-testing\scripts\build"
echo @echo off > "%BASE_DIR%\db-release-testing\scripts\build\build_image.bat"
echo REM Script to build Docker image >> "%BASE_DIR%\db-release-testing\scripts\build\build_image.bat"
echo docker-compose build >> "%BASE_DIR%\db-release-testing\scripts\build\build_image.bat"

echo @echo off > "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo REM Script to export and import data >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo REM Variables >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo set DB_NAME=test >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo set USER=postgres >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo set OUTPUT_FILE=..\data\production_snapshot\prod_data_sanitized.sql >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo REM Export production schema and data >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"
echo REM pg_dump -U %%USER%% -d %%DB_NAME%% --no-owner --schema-only ^> "%%OUTPUT_FILE%%" >> "%BASE_DIR%\db-release-testing\scripts\build\export_import_data.bat"

mkdir "%BASE_DIR%\db-release-testing\scripts\test"
echo @echo off > "%BASE_DIR%\db-release-testing\scripts\test\run_tests.bat"
echo REM Script to run tests >> "%BASE_DIR%\db-release-testing\scripts\test\run_tests.bat"
echo echo Running tests... >> "%BASE_DIR%\db-release-testing\scripts\test\run_tests.bat"
echo REM Add your testing commands here >> "%BASE_DIR%\db-release-testing\scripts\test\run_tests.bat"

REM Create tests directory
mkdir "%BASE_DIR%\db-release-testing\tests\unit"
mkdir "%BASE_DIR%\db-release-testing\tests\integration"
mkdir "%BASE_DIR%\db-release-testing\tests\validation"

REM Create logs directory
mkdir "%BASE_DIR%\db-release-testing\logs"

REM Create reports directory
mkdir "%BASE_DIR%\db-release-testing\reports"

REM Create docs directory with sample docs
mkdir "%BASE_DIR%\db-release-testing\docs"
echo # Setup Documentation > "%BASE_DIR%\db-release-testing\docs\SETUP.md"
echo ## Instructions to set up the environment... >> "%BASE_DIR%\db-release-testing\docs\SETUP.md"

echo # Usage Documentation > "%BASE_DIR%\db-release-testing\docs\USAGE.md"
echo ## Instructions for using the system... >> "%BASE_DIR%\db-release-testing\docs\USAGE.md"

echo # Troubleshooting > "%BASE_DIR%\db-release-testing\docs\TROUBLESHOOTING.md"
echo ## Common issues and their solutions... >> "%BASE_DIR%\db-release-testing\docs\TROUBLESHOOTING.md"

REM Final message
echo Directory structure and initial files created successfully at %BASE_DIR%\db-release-testing!
endlocal
