@echo off
setlocal enableextensions

rem Tests if the current session is elevated
rem Returns ERRORLEVEL 0 if elevated
fsutil dirty query %SystemDrive%>nul
