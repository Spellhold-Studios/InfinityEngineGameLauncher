Set-ExecutionPolicy bypass -Force
$gameExeFileNames = "BGMain.exe","IDMain.exe","IWD2.exe","Torment.exe"
$iniFileNames = "Baldur.ini","Icewind.ini","Icewind2.ini","Torment.ini"
$scriptPath = ( $gameExeFileNames | Get-ChildItem -Include $_ -ErrorAction SilentlyContinue | Select-Object Directory -First 1 ).Directory.FullName
    if ( $scriptPath -ne $null ) {
        $iniFile = ( $iniFileNames | Get-ChildItem -Include $_ -ErrorAction SilentlyContinue ).Name
        $iniFileBackup = "$IniFile.backup"
        $iniFileContent = Get-Content $iniFile
        $iniFileContent | % {
            if ( $_ -match "HD0:=.*" ) {
                if ( ( $_ -replace "HD0:=") -notlike "$scriptPath\" ) {
                    if ( ( Test-Path $iniFileBackup ) -eq $false ) { Copy-Item -Path $iniFile -Destination $iniFileBackup }
                $iniFileContent = Get-Content $iniFile
                $iniFileContent | % {
                    $_ -replace "HD0:=.*","HD0:=$scriptPath\" `
                    -replace "CD1:=.*","CD1:=$scriptPath\;$scriptPath\CD1\" `
                    -replace "CD2:=.*","CD2:=$scriptPath\;$scriptPath\CD2\" `
                    -replace "CD3:=.*","CD3:=$scriptPath\;$scriptPath\CD3\" `
                    -replace "CD4:=.*","CD4:=$scriptPath\;$scriptPath\CD4\" `
                    -replace "CD5:=.*","CD5:=$scriptPath\;$scriptPath\CD5\" `
                    -replace "CD6:=.*","CD6:=$scriptPath\;$scriptPath\CD6\" `
                    } | Set-Content $iniFile | Out-Null
                }
            }
        }
    } else {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [Windows.Forms.MessageBox]::Show("Run this application from you Infinity Engine game directory.", "Information", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
    exit -1
    }
Invoke-Item -Path $gameExeFileNames -ErrorAction SilentlyContinue
Exit 1