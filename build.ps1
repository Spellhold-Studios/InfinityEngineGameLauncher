Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# If module is imported say that and do nothing
if (Get-Module | Where-Object Name -eq 'ps2exe') {
    # If module is not imported, but available on disk then import
} elseif (Get-Module -ListAvailable | Where-Object Name -eq 'ps2exe') {
    Import-Module 'ps2exe' -Force -PassThru
} else {
    # If module is not imported, not available on disk, but is in online gallery then install and import
    if (Find-Module -Name 'ps2exe' | Where-Object Name -eq 'ps2exe' ) {
        Install-Module -Name 'ps2exe' -Scope CurrentUser -Force | Out-Null
        Import-Module 'ps2exe' -Force | Out-Null
    } else {
        # If module is not imported, not available and not in online gallery then abort
        Write-Host "Module 'ps2exe' not imported, not available and not in online gallery, exiting."
        Exit -1
    }
}

Set-Location $PSScriptRoot

$Version = '2.0.0.5'
$InputFile = 'InfinityLauncher' + '.ps1'
$OutputFile = 'InfinityLauncher' + '-New' + '.exe'
$IconFile = 'InfinityLauncher-Icon.ico'
$Title = $Product = $Description = 'Infinity Engine Game Launcher'
$Copyright = 'alienquake@hotmail.com'

# New PS2EXE-GUI v0.5.0.26
Invoke-PS2exe -NoConsole -NoOutput -NoError -x86 -Version $Version -Title $Title -Description $Description -Product $Product -Copyright $Copyright -InputFile $InputFile -OutputFile $OutputFile -IconFile $IconFile
