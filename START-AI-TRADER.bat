@echo off
setlocal EnableExtensions
title AI Trader - setup and start
color 0B

rem ============================================================
rem  AI Trader one-click launcher for Windows
rem  First run : installs everything, then starts the program
rem  Next runs : just starts the program
rem ============================================================

set "ROOT=%~dp0"
if exist "%ROOT%backend\main.py" (
    set "BACKEND=%ROOT%backend"
) else if exist "%ROOT%ai-trader\backend\main.py" (
    set "BACKEND=%ROOT%ai-trader\backend"
) else (
    echo [ERROR] Cannot find the "backend" folder.
    echo Put this file in the same folder that contains "backend" and "frontend".
    echo.
    pause
    exit /b 1
)
cd /d "%BACKEND%"

echo.
echo  ==========================================
echo    AI Trader - setup and start
echo  ==========================================
echo.

rem ---------- 1. find Python ----------
echo [1/4] Looking for Python...
set "PY="
for %%V in (3.12 3.13 3.11 3.10) do (
    if not defined PY (
        py -%%V -c "import sys" >nul 2>&1
        if not errorlevel 1 set "PY=py -%%V"
    )
)
if defined PY goto :have_python
python -c "import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)" >nul 2>&1
if not errorlevel 1 set "PY=python"
if defined PY goto :have_python

echo       Python 3.10 or newer was not found.
where winget >nul 2>&1
if errorlevel 1 goto :no_python
echo       Trying to install Python 3.12 automatically. Accept any Windows prompt.
winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
echo.
echo  Python was installed. Please CLOSE this window and double-click
echo  START-AI-TRADER.bat again so Windows can find the new Python.
echo.
pause
exit /b 0

:no_python
echo.
echo [ERROR] Please install Python 3.12 from https://www.python.org/downloads/
echo         Tick "Add python.exe to PATH" in the installer, then run this file again.
echo.
pause
exit /b 1

:have_python
%PY% --version
echo.

rem ---------- 2. private environment ----------
echo [2/4] Preparing the Python environment...
if not exist ".venv\Scripts\python.exe" (
    if exist ".venv" rmdir /s /q ".venv"
    %PY% -m venv .venv
    if errorlevel 1 goto :venv_fail
)
echo       Ready.
echo.

rem ---------- 3. libraries ----------
echo [3/4] Installing libraries. The first time this takes a few minutes...
if exist ".venv\installed.flag" goto :deps_done
".venv\Scripts\python.exe" -m pip install --upgrade pip >nul 2>&1
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 goto :pip_fail
echo ok> ".venv\installed.flag"
:deps_done
echo       Ready.
echo.

rem ---------- 4. settings ----------
echo [4/4] Checking settings...
if not exist ".env" (
    copy ".env.example" ".env" >nul
    echo       Created the settings file .env
)
set "PORT=8000"
set "MODE=paper"
for /f "tokens=2 delims== " %%P in ('findstr /b /c:"PORT=" ".env"') do set "PORT=%%P"
for /f "tokens=2 delims== " %%M in ('findstr /b /c:"TRADING_MODE=" ".env"') do set "MODE=%%M"
echo       Trading mode: %MODE%
if /i "%MODE%"=="live" (
    echo.
    echo       WARNING: LIVE mode uses REAL MONEY.
)
echo.

rem ---------- open the dashboard as soon as the server answers ----------
start "" /min powershell -WindowStyle Hidden -NoProfile -Command "for($i=0;$i -lt 60;$i++){try{Invoke-WebRequest -UseBasicParsing 'http://127.0.0.1:%PORT%/api/state' -TimeoutSec 2 | Out-Null;break}catch{Start-Sleep 1}};Start-Process 'http://127.0.0.1:%PORT%'"

echo  ------------------------------------------------------------
echo   Starting AI Trader. Your browser will open by itself.
echo   Dashboard: http://127.0.0.1:%PORT%
echo   KEEP THIS WINDOW OPEN. Close it, or press Ctrl+C, to stop.
echo  ------------------------------------------------------------
echo.
set PYTHONUNBUFFERED=1
".venv\Scripts\python.exe" main.py

echo.
echo  AI Trader has stopped. Any error message is shown above.
echo.
pause
exit /b 0

:venv_fail
echo.
echo [ERROR] Could not create the Python environment.
echo         Install Python 3.12 from python.org and run this file again.
echo.
pause
exit /b 1

:pip_fail
echo.
echo [ERROR] Library installation failed. Scroll up to read the reason.
echo         Common fixes: check your internet connection, or install
echo         Python 3.12 from python.org and run this file again.
echo.
pause
exit /b 1
