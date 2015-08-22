## Intro: Powershell script to restore a SQL Server database.
## Usage: BackupDatabase.ps1
##   -ServerName [ServerName]
##   -DatabaseName [DatabaseName]
##   -BackupPath [BackupPath]

param(
    [string]$ServerName = "",
    [string]$DatabaseName = "",
    [string]$BackupPath = ""
    )

Import-Module "sqlps" -DisableNameChecking

if($ServerName -eq "")   { throw "Argument -ServerName is missing." }
if($DatabaseName -eq "") { throw "Argument -DatabaseName is missing." }
if($BackupPath -eq "")   { throw "Argument -BackupPath is missing." }

try {
    Write-Host "INFO: Verifying if backup path exists '$BackupPath'." -BackgroundColor "black" -ForegroundColor "blue"
    if (-Not (Test-Path $BackupPath)) {
        Write-Host "WARNING: Invalid backup path '$BackupPath'." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    $Server = New-Object ("Microsoft.SqlServer.Management.Smo.Server") $ServerName
    if ($Server -eq $null)
    {
        Write-Host "WARNING: Invalid server name '$ServerName'." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    $Database = $Server.Databases[$DatabaseName]
    if ($Database -eq $null)
    {
        Write-Host "WARNING: Invalid database name '$DatabaseName'." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    Write-Host "INFO: Starting restore for '$ServerName\$DatabaseName'." -BackgroundColor "black" -ForegroundColor "blue"

    Restore-SqlDatabase -ServerInstance $ServerName -Database $DatabaseName -BackupFile $BackupPath -ReplaceDatabase

    Write-Host "SUCCESS: Backup restored from '$BackupPath'." -BackgroundColor "black" -ForegroundColor "green"

} catch {
    Write-Host "ERROR: Error restoring backup." -BackgroundColor "black" -ForegroundColor "yellow"
    throw
}
