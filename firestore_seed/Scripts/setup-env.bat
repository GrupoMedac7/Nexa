@echo off
REM Get the directory of the script
SET SCRIPT_DIR=%~dp0

REM Go to the project root (assumes scripts is a subfolder)
CD /D "%SCRIPT_DIR%\.."

REM Check if virtual environment exists
IF NOT EXIST ".env\Scripts\activate.bat" (
    echo Creating virtual environment ".env"...
    python -m venv .env
) ELSE (
    echo Virtual environment ".env" already exists.
)

REM Activate virtual environment
echo Activating virtual environment...
CALL ".env\Scripts\activate.bat"

REM Upgrade pip if needed
echo Upgrading pip...
python -m pip install --upgrade pip

REM Install dependencies
CALL "%SCRIPT_DIR%\install-dependencies.bat"

echo Setup complete!
pause
