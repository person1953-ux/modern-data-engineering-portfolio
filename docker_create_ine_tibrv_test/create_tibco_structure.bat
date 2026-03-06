@echo off
setlocal enabledelayedexpansion

REM Define the base project directory
set "BASE_DIR=C:\Users\User\nhan\modern-data-platform-codebase\docker_create_ine_tibrv_test\tibco_rv_testing"

REM Create main project directory
mkdir "%BASE_DIR%"
mkdir "%BASE_DIR%\docker"
mkdir "%BASE_DIR%\docker\config"
mkdir "%BASE_DIR%\data\reference_data"
mkdir "%BASE_DIR%\data\production_snapshot"
mkdir "%BASE_DIR%\releases\release_2026_01"
mkdir "%BASE_DIR%\releases\release_2026_02"
mkdir "%BASE_DIR%\releases\release_2026_03"
mkdir "%BASE_DIR%\releases\release_2026_04"
mkdir "%BASE_DIR%\scripts\build"
mkdir "%BASE_DIR%\scripts\test"
mkdir "%BASE_DIR%\scripts\utils"
mkdir "%BASE_DIR%\docs"

REM Create Dockerfile
(
echo # TIBCO RV Dockerfile
echo FROM tibco/rendezvous:latest
echo.
echo # Copy configuration files
echo COPY config/* /etc/rendezvous/
echo.
echo # Expose necessary ports
echo EXPOSE 7500
) > "%BASE_DIR%\docker\Dockerfile"

REM Create docker-compose.yml
(
echo version: '3.8'
echo.
echo services:
echo   tibco-rv:
echo     build:
echo       context: .
echo       dockerfile: Dockerfile
echo     ports:
echo       - "7500:7500"
echo     environment:
echo       - RVR_HOST=0.0.0.0
echo       - RVR_PORT=7500
) > "%BASE_DIR%\docker\docker-compose.yml"

REM Create TIBCO RV Configuration Files
(
echo # TIBCO RV Configuration File
echo RVR_HOST      = 105.194.18.233
echo RVR_PORT      = 7500
echo # Additional configurations
) > "%BASE_DIR%\docker\config\rvp.cfg"

REM Skipping SQL and reference data file creation as only RV message testing is needed.

REM Create Release Notes
(
echo # Release Notes for 2026_01
echo ## Details about the features and fixes.
) > "%BASE_DIR%\releases\release_2024_01\README.md"

(
echo # Release Notes for 2026_02
echo ## Details about the features and fixes.
) > "%BASE_DIR%\releases\release_2024_02\README.md"

REM Create Build Script
(
echo #!/bin/bash
echo # Script to build the TIBCO RV Docker image
echo docker-compose build
) > "%BASE_DIR%\scripts\build\build_image.sh"

REM Create Test Script
(
echo #!/bin/bash
echo # Script to run tests
echo echo "Running RV message tests..."
echo # Add testing commands here
) > "%BASE_DIR%\scripts\test\run_tests.sh"

REM Create Documentation Files
(
echo # Setup Documentation
echo ## Instructions to set up the TIBCO RV environment.
) > "%BASE_DIR%\docs\SETUP.md"

(
echo # Usage Documentation
echo ## Instructions for using the TIBCO RV setup.
) > "%BASE_DIR%\docs\USAGE.md"

(
echo # Troubleshooting
echo ## Common issues and solutions.
) > "%BASE_DIR%\docs\TROUBLESHOOTING.md"

REM Final message
echo Directory structure and initial files created successfully at %BASE_DIR%!

endlocal
