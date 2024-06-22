@echo off

set flags=
set "debugFlag=false"
set "runFlag=false"

for %%i in (%*) do (
    if "%%i"=="--debug" set "debugFlag=true"
    if "%%i"=="--run" set "runFlag=true"
)

if %debugFlag%==true set flags=%flags% --debug
if %runFlag%==true set flags=%flags% --run

if not exist build mkdir build
if not exist build\resources mkdir build\resources

call scripts\clean.bat

if %debugFlag%==true (
    haxe debug.hxml
) else (
    haxe release.hxml
)

if errorlevel 1 (
    echo Build failed! Exiting script.
    pause
    exit /b 1
)

echo Build successful!

copy tmp\cpp\Main.exe build\Game.exe
echo Copied Build!

xcopy /S /Y /D resources build\resources
echo Copied resources!

if %runFlag%==true (
    build\Game.exe
    echo Exited with code %errorlevel%
)
