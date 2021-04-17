Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force


Set-Location (Split-Path $MyInvocation.MyCommand.Path)

$Version = '2.0.0.5'
$InputFile = 'InfinityLauncher' + '.ps1'
$OutputFile = 'InfinityLauncher' + '-old' + '.exe'
$IconFile = 'InfinityLauncher-Icon.ico'
$Title = $Product = $Description = 'Infinity Engine Game Launcher'
$Copyright = 'alienquake@hotmail.com'

# PS2EXE v0.5.0.0
.\ps2exe.ps1 -Runtime20 -NoConsole -NoOutput -NoError -x86 -Version $Version -Title $Title -Description $Description -Product $Product -Copyright $Copyright -InputFile $InputFile -OutputFile $OutputFile -IconFile $IconFile
