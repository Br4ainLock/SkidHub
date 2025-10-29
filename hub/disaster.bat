@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Running ALL executables except "disaster"
echo ========================================
echo.

REM Define all executable file types
set "extensions=.exe .vbs .ps1 .hta"

REM Loop through each file type
for %%e in (%extensions%) do (
    for %%f in (*%%e) do (
        set "filename=%%f"
        if /i not "!filename!"=="disaster%%e" (
            echo [STARTING] !filename!
            start "" "!filename!"
            echo.
        ) else (
            echo [SKIPPING] !filename!
            echo.
        )
    )
)

echo ========================================
echo ALL FILES PROCESSED!
echo ========================================
pause