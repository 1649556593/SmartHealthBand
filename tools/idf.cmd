@echo off
setlocal EnableExtensions

rem ===========================================================================
rem  SmartHealthBand - one-click ESP-IDF environment launcher
rem
rem  Usage:  tools\idf.cmd            (from a cmd prompt)
rem          or double-click this file
rem
rem  Why this exists:
rem    ESP-IDF's export.bat guesses the Python virtualenv directory name from
rem    the version of the FIRST python.exe found in PATH
rem    (idf5.3_py{major}.{minor}_env). If the system Python is newer than the
rem    one ESP-IDF was installed with, it looks for a directory that does not
rem    exist and fails with:
rem      python_env\idf5.3_py3.14_env\Scripts\python.exe doesn't exist!
rem    This script points ESP-IDF at the correct environment directly.
rem
rem  NOTE: keep this file ASCII-only. cmd.exe parses .cmd files with the OEM
rem        code page, so UTF-8 Chinese text breaks the batch parser.
rem
rem  Changed machines or reinstalled ESP-IDF? Edit the paths below.
rem ===========================================================================

set "IDF_TOOLS_PATH=D:\Espressif"
set "IDF_PATH=D:\Espressif\frameworks\esp-idf-v5.3.5"
set "IDF_PYTHON_ENV_PATH=D:\Espressif\python_env\idf5.3_py3.11_env"

rem ------------------------------------------------------------- sanity checks
if not exist "%IDF_PATH%\export.bat" (
    echo [ERROR] ESP-IDF not found: %IDF_PATH%
    echo         Edit IDF_PATH at the top of this script, or install ESP-IDF 5.3.5.
    pause
    exit /b 1
)

rem ------------------------------- switch to the project root FIRST (important)
rem export.bat creates a temporary file named UNINSTALL_OUTPUT in the CURRENT
rem directory. If that directory is not writable (for example
rem C:\Windows\System32) it prints "Access is denied" plus confusing follow-up
rem errors. Run it from the project root instead.
cd /d "%~dp0.."

rem ------------------------------- python env: fall back to auto-detection
if not exist "%IDF_PYTHON_ENV_PATH%\Scripts\python.exe" (
    echo [INFO] %IDF_PYTHON_ENV_PATH% not found, auto-detecting...
    set "IDF_PYTHON_ENV_PATH="
    for /d %%D in ("%IDF_TOOLS_PATH%\python_env\idf*_env") do (
        if exist "%%D\Scripts\python.exe" set "IDF_PYTHON_ENV_PATH=%%D"
    )
)

if not defined IDF_PYTHON_ENV_PATH (
    echo [ERROR] No usable IDF Python environment under %IDF_TOOLS_PATH%\python_env
    echo         Please re-run the ESP-IDF installer.
    pause
    exit /b 1
)
echo [INFO] Python environment: %IDF_PYTHON_ENV_PATH%

rem ------------------------------------------------------- init ESP-IDF env
call "%IDF_PATH%\export.bat"
if errorlevel 1 (
    echo.
    echo [ERROR] ESP-IDF environment initialization failed. See the log above.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   ESP-IDF environment is ready
echo   Project dir: %CD%
echo.
echo   Common commands:
echo     idf.py build                     build the project
echo     idf.py -p COM3 flash monitor     flash + serial log (Ctrl+] to exit)
echo     idf.py menuconfig                change config (tell the team first)
echo ============================================================
echo.

rem ------------------------- keep an interactive shell for repeated commands
cmd /k
