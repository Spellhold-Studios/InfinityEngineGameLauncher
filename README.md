Infinity Engine Game Launcher is a tool for fixing *.ini files and registry entries for each game based on the Infinity Engine like BG, BG II, IWD, IWD II, and Planescape:Torment when the main game directory was moved to a different folder after installation.
 
So for eg: if "Icewind Dale" was installed in C:\Program Files\Icewind Dale\ and you moved the game directory to F:\Games\Icewind Dale, you will get an error when trying to run the game. This tool will fix such errors by modifying *.ini file and/or registry for BG/BGII launchers. You can always do those steps manually but why bother?
 
How to use:
1. If you want to fix *.ini file and registry run InfinityLauncher.exe as Admin from the game directory
2. If you don't care or don't want to change registry/don't have admin rights run InfinityLauncherNoReg.exe from the game directory
 
Features:
- comes in two versions, one that doesn't require admin rights but it won't fix registry
- support every game version like CD, DVD, polish "Saga Baldur's Gate", GoG.com
- support games without installed extension
- support games without installed patches
- doesn't prevent BGII:ToB installation if you moved the initial BGII install directory and then use this tool
- it will modify *.ini file only when the paths are not correct
- it will modify the registry only when the entries aren't correct and only for the current game
- it will create a backup for the first time when *.ini file is modified, no more backups will be made
- if there is nothing to do, it will start the game

Requirements:
XP: SP3 (Windows Update), NET Framework 2.0 (Windows Update), NET Framework 2.0 SP2, Windows Management Framework
Vista: SP1 (Windows Update), NET Framework 3.5 SP1 (Windows Update), Powershell 2.0 x32/x64
Windows 7,8,10: nothing
