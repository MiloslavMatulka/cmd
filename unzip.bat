@echo off
setlocal enableextensions

rem Source pathname (.zip extension only)
set "_source=%1"
rem Destination directory
set "_destination=%2"
cd /d %~dp0

rem Extracts files (unzip) using PowerShell
powershell.exe Expand-Archive -Path "%_source%" -DestinationPath "%_destination%"
