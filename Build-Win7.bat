cd %~dp0
powershell -NoLogo -NoProfile -NoExit -Command "& { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force ; & '%~dp0Build-Win7.ps1' }"
