#!/bin/bash

set -e  # Exit on error

# Define the base project directory
BASE_DIR="C:/Users/User/nhan/modern-data-engineering-portfolio/docker_create_staging_database"

echo "Creating main project directory..."
mkdir -p "$BASE_DIR/db-release-testing"

# Create Docker directory and its contents
echo "Creating Docker directory and files..."
mkdir -p "$BASE_DIR/db-release-testing/docker/config/postgresql"

cat > "$BASE_DIR/db-release-testing/docker/Dockerfile" <<EOL
# Use the official PostgreSQL image as the base
FROM postgres:15

# Set environment variables
ENV POSTGRES_DB=test
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=admin

# Optional: Copy custom configuration files
COPY config/postgresql/postgresql.conf /etc/postgresql/postgresql.conf
COPY config/postgresql/pg_hba.conf /etc/postgresql/pg_hba.conf

# Expose PostgreSQL port
EXPOSE 5432
EOL

cat > "$BASE_DIR/db-release-testing/docker/docker-compose.yml" <<EOL
version: '3.8'

services:
  db-postgres:
    build:
      context: ..
      dockerfile: docker/Dockerfile
    container_name: test-postgres
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=test
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=admin
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - db-network

networks:
  db-network:
    driver: bridge

volumes:
  postgres_data:
EOL

echo "Docker files created."

# Create PostgreSQL config files
echo "Creating PostgreSQL config files..."
mkdir -p "$BASE_DIR/db-release-testing/docker/config/postgresql"
cat > "$BASE_DIR/db-release-testing/docker/config/postgresql/postgresql.conf" <<EOL
# PostgreSQL custom config file
# Add your custom configurations here
EOL

cat > "$BASE_DIR/db-release-testing/docker/config/postgresql/pg_hba.conf" <<EOL
# PostgreSQL Host-Based Authentication configuration file
# Add your authentication rules here
EOL

echo "PostgreSQL config files created."

# Create schema directory with sample SQL files
echo "Creating schema directory and baseline SQL files..."
mkdir -p "$BASE_DIR/db-release-testing/schema/baseline"
cat > "$BASE_DIR/db-release-testing/schema/baseline/01_create_tablespaces.sql" <<EOL
-- Script to create tablespaces
CREATE TABLESPACE my_tablespace LOCATION '/var/lib/postgresql/data/my_tablespace';
EOL

cat > "$BASE_DIR/db-release-testing/schema/baseline/02_create_users.sql" <<EOL
-- Script to create users
CREATE USER my_user WITH PASSWORD 'password';
EOL

echo "Schema baseline files created."

# Create migrations directory
echo "Creating migrations directory with sample files..."
mkdir -p "$BASE_DIR/db-release-testing/schema/migrations/2024_01"
cat > "$BASE_DIR/db-release-testing/schema/migrations/2024_01/001_add_new_column.sql" <<EOL
-- Migration to add a new column
ALTER TABLE test_table ADD COLUMN new_column VARCHAR(255);
EOL

echo "Migrations directory created."

# Create data directories
echo "Creating data and reference_data directories..."
mkdir -p "$BASE_DIR/db-release-testing/data/reference_data"
cat > "$BASE_DIR/db-release-testing/data/reference_data/01_lookup_tables.sql" <<EOL
-- Sample lookup tables
INSERT INTO lookup_table (id, name) VALUES (1, 'Lookup1'), (2, 'Lookup2');
EOL

mkdir -p "$BASE_DIR/db-release-testing/data/production_snapshot"
cat > "$BASE_DIR/db-release-testing/data/production_snapshot/prod_data_sanitized.sql" <<EOL
-- Sample production data snapshot
INSERT INTO sample_table (column1, column2) VALUES ('Sample1', 'Data1');
EOL

echo "Data directories created."

# Create releases directory with sample content
echo "Creating releases directory..."
mkdir -p "$BASE_DIR/db-release-testing/releases/release_2024_01/01_migrations"
cat > "$BASE_DIR/db-release-testing/releases/release_2024_01/01_migrations/001_create_new_feature.sql" <<EOL
-- Release migration script
CREATE TABLE new_feature (id SERIAL PRIMARY KEY, feature_name VARCHAR(255));
EOL

mkdir -p "$BASE_DIR/db-release-testing/releases/release_2024_01/02_data"
cat > "$BASE_DIR/db-release-testing/releases/release_2024_01/02_data/001_insert_reference_data.sql" <<EOL
-- Sample data insertion for new feature
INSERT INTO new_feature (feature_name) VALUES ('Feature1'), ('Feature2');
EOL

echo "Releases directory created."

mkdir -p "$BASE_DIR/db-release-testing/releases/release_2024_02"
cat > "$BASE_DIR/db-release-testing/releases/release_2024_02/README.md" <<EOL
# Release 2024_02
## This folder contains migration scripts and data for Release 2024_02.
EOL

# Create scripts directory with sample scripts
echo "Creating scripts directory..."
mkdir -p "$BASE_DIR/db-release-testing/scripts/build"
cat > "$BASE_DIR/db-release-testing/scripts/build/build_image.sh" <<EOL
#!/bin/bash
# Script to build Docker image
docker-compose build
EOL

chmod +x "$BASE_DIR/db-release-testing/scripts/build/build_image.sh"

cat > "$BASE_DIR/db-release-testing/scripts/build/export_import_data.sh" <<EOL
#!/bin/bash
# Script to export and import data

# Variables
DB_NAME=test
USER=postgres
OUTPUT_FILE="../data/production_snapshot/prod_data_sanitized.sql"

# Export production schema and data
pg_dump -U \$USER -d \$DB_NAME --no-owner --schema-only > "\$OUTPUT_FILE"
EOL

chmod +x "$BASE_DIR/db-release-testing/scripts/build/export_import_data.sh"

mkdir -p "$BASE_DIR/db-release-testing/scripts/test"
cat > "$BASE_DIR/db-release-testing/scripts/test/run_tests.sh" <<EOL
#!/bin/bash
# Script to run tests
echo "Running tests..."
# Add your testing commands here
EOL

chmod +x "$BASE_DIR/db-release-testing/scripts/test/run_tests.sh"

# Create tests directory
mkdir -p "$BASE_DIR/db-release-testing/tests/unit"
mkdir -p "$BASE_DIR/db-release-testing/tests/integration"
mkdir -p "$BASE_DIR/db-release-testing/tests/validation"

# Create logs directory
mkdir -p "$BASE_DIR/db-release-testing/logs"

# Create reports directory
mkdir -p "$BASE_DIR/db-release-testing/reports"

# Create docs directory with sample docs
mkdir -p "$BASE_DIR/db-release-testing/docs"
cat > "$BASE_DIR/db-release-testing/docs/SETUP.md" <<EOL
# Setup Documentation
## Instructions to set up the environment...
EOL

cat > "$BASE_DIR/db-release-testing/docs/USAGE.md" <<EOL
# Usage Documentation
## Instructions for using the system...
EOL

cat > "$BASE_DIR/db-release-testing/docs/TROUBLESHOOTING.md" <<EOL
# Troubleshooting
## Common issues and their solutions...
EOL

echo "Directory structure and initial files created successfully at $BASE_DIR/db-release-testing!"
