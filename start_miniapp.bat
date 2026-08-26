@echo off
REM EarningMiniApp Startup Script
REM <environment_details>
REM Current time: 2026-08-26T12:21:15+05:30
REM Working directory: C:\Users\dhiresh\OneDrive\Desktop\bot_3
REM Workspace root folder: C:\Users\dhiresh\OneDrive\Desktop\bot_3
REM </environment_details>
cd /d c:\Users\dhiresh\OneDrive\Desktop\bot_3
set MONGO_URI=
echo Starting mini app server...
.venv\Scripts\python.exe -m flask --app app.mini_app run --port 5000 > server_log.txt 2>&1
echo Server stopped.


