cd %~dp0
powershell -NoLogo -NoProfile -NoExit -Command { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; .\build.ps1 }
