Set-Location $PSScriptRoot

# If module is imported we are good to go
if (Get-Module | Where-Object Name -eq 'ps2exe') {
    # If module is not imported, but available on disk then import
} elseif (Get-Module -ListAvailable | Where-Object Name -eq 'ps2exe') {
    Import-Module 'ps2exe' -Force -PassThru
} else {
    # If module is not imported, not available on disk, but is in online gallery then install and import
    if (Find-Module -Name 'ps2exe' | Where-Object Name -eq 'ps2exe' ) {
        # Remove-Module PowerShellGet
        # Import-Module "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\PowerShellGet.psd1"
        Install-PSResource -Name 'ps2exe' -Scope CurrentUser -Repository PSGallery -TrustRepository -Quiet -PassThru
        Import-Module 'ps2exe' -Force #| Out-Null
    } else {
        # If module is not imported, not available and not in online gallery then abort
        Write-Host "Module 'ps2exe' not imported, not available and not in online gallery, exiting."
        Exit -1
    }
}

$Config = Import-PowerShellDataFile -Path "$PSScriptRoot\BuildConfig.psd1"

$EditionList = 'InfinityLauncher','InfinityLauncherNoReg'

$EditionList | % {
    $Edition = $_
    Invoke-PS2exe -winFormsDPIAware -lcid 1033 -NoConsole -NoOutput -NoError -x86 `
        -Version $Config.Version `
        -Title $Config.Title `
        -Description $Config.Description `
        -Product $Config.Product `
        -Copyright $Config.Copyright `
        -IconFile $Config.IconFile `
        -InputFile  "$Edition.ps1" `
        -OutputFile "$Edition.exe"
}
