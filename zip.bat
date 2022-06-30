@echo off
setlocal enableextensions

rem Source pathname
set "_source=%1"
rem Target pathname (.zip extension only)
set "_target=%2"
cd /d %~dp0

rem Compresses files (zip) using PowerShell
powershell.exe Compress-Archive -Path "%_source%" -Update -DestinationPath "%_target%"
