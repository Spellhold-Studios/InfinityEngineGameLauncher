
Set-Location (Split-Path $MyInvocation.MyCommand.Path)

# At beginning of .ps1
if ($PSVersionTable.PSVersion.Major -ne 5 -and $PSVersionTable.PSVersion.Minor -ne 1 ) {
  # Re-launch as version 5 if we're not already
  Write-Host "This script requires PowerShell 5.1."
  exit
}

$Config = Import-PowerShellDataFile -Path "$PSScriptRoot\BuildConfig.psd1"

$OutputFile = 'InfinityLauncher' + '-Old' + '.exe'

# using old PS2EXE v0.5.0.0 because new version are missing -Runtime20 switch
& ".\build-ps2exe-v0.5.0.0.ps1" -NoConsole -NoOutput -NoError -x86 -Runtime20 `
    -Version $Config.Version `
    -Title $Config.Title `
    -Description $Config.Description `
    -Product $Config.Product `
    -Copyright $Config.Copyright `
    -InputFile $Config.InputFile `
    -IconFile $Config.IconFile `
    -OutputFile $OutputFile
