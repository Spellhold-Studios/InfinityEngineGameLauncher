Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

function Get-InfinityEngineIniConfiguration {
    param( $arg )
    $iniFileContent = Get-Content $arg
    $iniFileContent | ForEach-Object {
        if ( $_ -match "HD0:=.*" ) {
            if (( $_ -replace "HD0:=" ) -notmatch "$scriptPath" ) {
                Write-Host "  Game Path:$scriptPath"
                Write-Host "Config Path:$( $_ -replace 'HD0:=' )"
                Set-InfinityEngineIniConfiguration $arg
            }
            else { Write-Host "$arg configuration ok." }
        }
    }
}

function Set-InfinityEngineIniConfiguration {
    param( $arg )
    if (( Test-Path $iniFileBackup ) -eq $false ) { Copy-Item -Path $arg -Destination $iniFileBackup -Force }
    $iniFileContent = Get-Content $arg | ForEach-Object {
        $_ -replace "HD0:=.*", "HD0:=$scriptPath\;$scriptPath\Data" `
           -replace "CD1:=.*", "CD1:=$scriptPath\;$scriptPath\CD1\" `
           -replace "CD2:=.*", "CD2:=$scriptPath\;$scriptPath\CD2\" `
           -replace "CD3:=.*", "CD3:=$scriptPath\;$scriptPath\CD3\" `
           -replace "CD4:=.*", "CD4:=$scriptPath\;$scriptPath\CD4\" `
           -replace "CD5:=.*", "CD5:=$scriptPath\;$scriptPath\CD5\" `
           -replace "CD6:=.*", "CD6:=$scriptPath\;$scriptPath\CD6\" `
    } 
    $iniFileContent | Set-Content $arg | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName( 'System.Windows.Forms' ) | Out-Null
    [Windows.Forms.MessageBox]::Show( "The $arg file was corrected.", 'Information', [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information ) | Out-Null
}

function New-AdministratorWarning {
    if (( Test-Administrator ) -eq $false ) {
        [System.Reflection.Assembly]::LoadWithPartialName( 'System.Windows.Forms' ) | Out-Null
        [Windows.Forms.MessageBox]::Show( 'Wrong registry entries detected. In order to fix them, run this program as Administrator.', 'Information', [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information ) | Out-Null
        exit -1
    }
}

function Test-Administrator {  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    ( New-Object Security.Principal.WindowsPrincipal $user ).IsInRole( [Security.Principal.WindowsBuiltinRole]::Administrator )  
}

$gameExeFileNames = 'BGMain.exe', 'BGMain2.exe', 'IDMain.exe', 'IWD2.exe', 'Torment.exe'
$detectGameExeFileNames = 'Config.exe', 'BGConfig.exe', 'IDMain.exe', 'IWD2.exe', 'Torment.exe'
$gameIniFileNames = 'Baldur.ini', 'Icewind.ini', 'Icewind2.ini', 'Torment.ini'
$gameExecutable = ( $gameExeFileNames | Get-ChildItem -Include $_ <#-ErrorAction SilentlyContinue#> | Select-Object -Last 1 ).Name

if ( $null -eq $gameExecutable ) { 
    [System.Reflection.Assembly]::LoadWithPartialName( 'System.Windows.Forms' ) | Out-Null
    [Windows.Forms.MessageBox]::Show( 'Run this application from you Infinity Engine game directory, where CHITIN.KEY file is located. ', 'Information', [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information ) | Out-Null
    exit -1
}

$detectGameExe = ( $detectGameExeFileNames | Get-ChildItem -Include $_ -ErrorAction SilentlyContinue | Select-Object -Last 1 ).Name
$scriptPath = ( $gameExeFileNames | Get-ChildItem -Include $_ -ErrorAction SilentlyContinue | Select-Object Directory -First 1 ).Directory.FullName
$iniFile = ( $gameIniFileNames | Get-ChildItem -Include $_ -ErrorAction SilentlyContinue ).Name
$iniFileBackup = "$iniFile.backup"

Get-InfinityEngineIniConfiguration $iniFile | Out-Null

switch ( $detectGameExe ) {
    'Config.exe' {
        $regBGTest11 = ( Get-ItemProperty "HKLM:\SOFTWARE\BioWare Corp.\Baldur's Gate\1.03.5512" -ErrorAction SilentlyContinue ).Version
        $regBGTest21 = ( Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\DirectPlay\Applications\Baldur's Gate" -ErrorAction SilentlyContinue ).CurrentDirectory
        $regBGTest22 = ( Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\DirectPlay\Applications\Baldur's Gate" -ErrorAction SilentlyContinue ).File
        $regBGTest23 = ( Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\DirectPlay\Applications\Baldur's Gate" -ErrorAction SilentlyContinue ).Path
        $regBGTest31 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BGMain.exe' -ErrorAction SilentlyContinue ).'(Default)'
        $regBGTest32 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BGMain.exe' -ErrorAction SilentlyContinue ).Path
       
        if ( $null -eq $regBGTest11 -or $regBGTest21 -ne ( $scriptPath + '\' ) -or $regBGTest22 -ne 'BGMain.exe' -or $regBGTest23 -ne ( $scriptPath + '\' ) -or $regBGTest31 -ne ( $scriptPath + '\BGMain.exe' ) -or $regBGTest32 -ne ( $scriptPath + '\' )) {
            New-AdministratorWarning
            $regBG1Path1 = "HKLM:\SOFTWARE\BioWare Corp.\Baldur's Gate\1.03.5512"
            $regBG1Path2 = "HKLM:\SOFTWARE\Microsoft\DirectPlay\Applications\Baldur's Gate"
            $regBG1Path3 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BGMain.exe'
            New-Item -Path $regBG1Path1
            New-Item -Path $regBG1Path2
            New-Item -Path $regBG1Path3
            Set-ItemProperty -Path $regBG1Path1 -name Version -Value 1.03.5512 -Force
            Set-ItemProperty -Path $regBG1Path2 -name CurrentDirectory -Value ( $scriptPath + '\' ) -Force
            Set-ItemProperty -Path $regBG1Path2 -name File -Value BGMain.exe -Force
            Set-ItemProperty -Path $regBG1Path2 -name Path -Value ( $scriptPath + '\' ) -Force
            Set-ItemProperty -Path $regBG1Path3 -name '(Default)' -Value ( $scriptPath + '\BGMain.exe' ) -Force
            Set-ItemProperty -Path $regBG1Path3 -name Path -Value ( $scriptPath + '\' ) -Force
        }
        else { 'Registry ok' }
    }
    'BGConfig.exe' {
        $regBG2Test11 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe' ).BG25GUID
        $regBG2Test12 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe' ).BG2LOCATION
        $regBG2Test13 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe' ).Install
        $regBG2Test14 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe' ).Path
        $regBG2Test15 = ( Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe' ).'(Default)'
        
        if ( $null -eq $regBG2Test11 -or $regBG2Test12 -ne $scriptPath -or $regBG2Test13 -ne $scriptPath -or $regBG2Test14 -ne $scriptPath -or $regBG2Test15 -ne ( $scriptPath + '\BGMain.exe' )) {
            New-AdministratorWarning
            $regBG2Path1 = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\BG2Main.exe'
            New-Item -Path $RegBG2Path1
            if ((( Test-Path ($scriptPath + '\CD5\Movies\25Movies.bif' )) -eq $true ) -or (( Test-Path ( $scriptPath + '\data\Movies\25Movies.bif' )) -eq $true )) {
                if ( $null -eq $regBG2Test11 ) { Set-ItemProperty -Path $regBG2Path1 -name BG25GUID -Value '<PRODUCT_GUID>' } 
            }
            Set-ItemProperty -Path $regBG2Path1 -name BG2LOCATION -Value $scriptPath -Force
            Set-ItemProperty -Path $regBG2Path1 -name Install -Value $scriptPath -Force
            Set-ItemProperty -Path $regBG2Path1 -name Path -Value $scriptPath -Force
            Set-ItemProperty -Path $regBG2Path1 -name '(Default)' -Value ( $scriptPath + '\BGMain.exe' )
        }
        else { 'Registry ok' }
    }
    'IDMain.exe' { 'Nothing to do' }
    'IWD2.exe' { 'Nothing to do' }
    'Torment.exe' { 'Nothing to do' }
}

#Invoke-Item -Path $gameExecutable
# & .\$gameExecutable
