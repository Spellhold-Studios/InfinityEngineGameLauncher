cd %~dp0
pwsh -NoLogo -NoProfile -NoExit -Command "& { Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force ; & '%~dp0Build.ps1' }"
