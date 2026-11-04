@echo off
title Nuvio Max'd (Torrent Edition) - 1-Click PS5 Builder
echo =====================================================================
echo   Nuvio Max'd (Torrent Stream Edition) - 1-Click Windows PS5 Builder
echo =====================================================================
echo.

REM Check if WSL is installed
wsl --status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [!] Windows Subsystem for Linux ^(WSL^) is not installed yet.
    echo [*] Installing WSL Ubuntu now... ^(Click YES if Windows asks for permission^)
    wsl --install -d Ubuntu
    echo.
    echo =====================================================================
    echo [!] IMPORTANT: Please RESTART your PC to finish installing WSL Ubuntu,
    echo     then double-click this file ^(DOUBLE_CLICK_TO_BUILD_PS5_APP.bat^) again!
    echo =====================================================================
    pause
    exit /b 0
)

echo [*] Converting Windows path to WSL path and starting automated build...
echo [*] First-time setup downloads the PS5 SDK and takes ~15-25 minutes.
echo [*] When finished, a folder named READY_FOR_PS5 will open automatically!
echo.

for /f "delims=" %%i in ('wsl wslpath -a "%~dp0source/native-app/auto_build_ps5.sh"') do set WSL_SCRIPT=%%i
wsl bash -c "sed -i 's/\r$//' \"%WSL_SCRIPT%\" && bash \"%WSL_SCRIPT%\""

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =====================================================================
    echo   SUCCESS! Opening READY_FOR_PS5 folder now...
    echo =====================================================================
    if exist "%~dp0READY_FOR_PS5" explorer "%~dp0READY_FOR_PS5"
) else (
    echo.
    echo [!] Build encountered an error. Scroll up to see details.
)
pause
