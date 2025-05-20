Set-Location $PSScriptRoot

# At beginning of .ps1
if ($PSVersionTable.PSVersion.Major -ne 5 -and $PSVersionTable.PSVersion.Minor -ne 1 ) {
  # Re-launch as version 5 if we're not already
  Write-Host "This script requires PowerShell 5.1."
  exit
}

$Config = Import-PowerShellDataFile -Path "$PSScriptRoot\BuildConfig.psd1"

$EditionList = 'InfinityLauncher','InfinityLauncherNoReg'

$EditionList | % {
    $Edition = $_
    # using old PS2EXE v0.5.0.0 because new version are missing -Runtime20 switch, icon and version details has to be added manually
    & ".\Build-Win7-ps2exe-v0.5.0.0.ps1" -NoConsole -NoOutput -NoError -x86 -Runtime20 -inputFile "$PSScriptRoot\$Edition.ps1" -OutputFile "$($Edition)Win7.exe" -verbose
}
