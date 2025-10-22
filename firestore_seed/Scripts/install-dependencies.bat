@echo off
REM Get the directory of the script
SET SCRIPT_DIR=%~dp0

REM Go to the project root (assumes scripts is a subfolder)
CD /D "%SCRIPT_DIR%\.."

REM Install dependencies from requirements.txt if it exists
IF EXIST "requirements.txt" (
    echo Installing dependencies from requirements.txt...
    python -m pip install -r requirements.txt
) ELSE (
    echo No requirements.txt found. Creating a template...
    (
        echo # ---Dependencies here---
        echo # you can install them with the following command:
        echo #
        echo # python -m pip install -r requirements.txt
        echo #
        echo # or by running the script:
        echo #
        echo # scripts/install-dependencies.bat
    ) > requirements.txt
)