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
        
        REM Skip if filename contains "disaster" (case-insensitive)
        echo !filename! | findstr /i "disaster" >nul
        if errorlevel 1 (
            echo [STARTING] !filename!
            
            REM Handle each file type differently
            if /i "%%e"==".ps1" (
                REM SPECIAL HANDLING FOR PS1 - Always works!
                powershell.exe -NoProfile -ExecutionPolicy Bypass -File "!filename!"
            ) else (
                REM Standard launch for other files
                start "" "!filename!"
            )
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