@echo off
setlocal enabledelayedexpansion

rem Set base directory to script's folder
set "BASE=%~dp0"

title MultiTool Console
color 0F

echo ------------------------------------------
echo         MultiTool Console Launcher
echo ------------------------------------------
echo Type a file name (e.g. tool, game) to run it.
echo Type HELP to list tools.
echo Type EXIT to quit.
echo ------------------------------------------
echo.

:loop
set "NAME="
set "FILE_NAME="
set "ARGS="

set /p NAME=MT-CMD^> 
if "%NAME%"=="" goto loop
if /i "%NAME%"=="exit" goto :eof

rem === HELP COMMAND ===
if /i "%NAME%"=="help" (
    echo.
    echo Available tools in "%BASE%":
    echo ------------------------------------------
    for %%F in ("%BASE%*.exe" "%BASE%*.bat" "%BASE%*.cmd" "%BASE%*.ps1" "%BASE%*.hta" "%BASE%*.vbs" "%BASE%*.js" "%BASE%*.py") do (
        if /i not "%%~nxF"=="%~nx0" echo   %%~nF
    )
    echo ------------------------------------------
    echo.
    goto loop
)

rem === Split name and arguments ===
for /f "tokens=1,*" %%a in ("%NAME%") do (
    set "FILE_NAME=%%a"
    set "ARGS=%%b"
)

rem === Try direct match ===
if exist "%BASE%%FILE_NAME%" (
    set "FOUND_FILE=%BASE%%FILE_NAME%"
    goto :run_file
)

rem === Try with extensions ===
set "FOUND_FILE="
for %%E in (.exe .bat .cmd .ps1 .hta .vbs .js .py) do (
    if exist "%BASE%%FILE_NAME%%%E" (
        set "FOUND_FILE=%BASE%%FILE_NAME%%%E"
        goto :run_file
    )
)

echo ERROR: Could not find "%FILE_NAME%" in "%BASE%"
goto loop


:run_file
if not defined FOUND_FILE (
    echo ERROR: No file specified.
    goto loop
)

echo Found: !FOUND_FILE! - launching...

set "EXT="
for %%X in (!FOUND_FILE!) do set "EXT=%%~xX"

rem === Batch or Cmd files: use CALL ===
if /i "!EXT!"==".bat" (
    call "!FOUND_FILE!" !ARGS!
    goto loop
)
if /i "!EXT!"==".cmd" (
    call "!FOUND_FILE!" !ARGS!
    goto loop
)

rem === PowerShell ===
if /i "!EXT!"==".ps1" (
    start "" powershell -ExecutionPolicy Bypass -File "!FOUND_FILE!" !ARGS!
    goto loop
)

rem === Everything else ===
start "" "!FOUND_FILE!" !ARGS!

echo ------------------------------------------
goto loop

:eof
endlocal
