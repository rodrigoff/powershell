## Intro: Powershell script to create a new application in a site.
## Usage: CreateApplication.ps1
##   -SiteName [SiteName]
##   -ApplicationPoolName [ApplicationPoolName]
##   -ApplicationName [Port]
##   -Path [Path]

param(
    [string]$SiteName = "",
    [string]$ApplicationPoolName = "",
    [string]$ApplicationName = "",
    [string]$Path = ""
    )

Import-Module WebAdministration

if($SiteName -eq "")            { throw "Argument -SiteName is missing." }
if($ApplicationPoolName -eq "") { throw "Argument -ApplicationPoolName is missing." }
if($ApplicationName -eq "")     { throw "Argument -ApplicationName is missing." }
if($Path -eq "")                { throw "Argument -Path is missing." }

$backupName = "$(Get-date -format "yyyyMMdd-HHmmss")-$SiteName"
Write-Host "INFO: Backing up IIS config to backup named '$backupName'." -BackgroundColor "black" -ForegroundColor "blue"
$backup = Backup-WebConfiguration $backupName

try {
    Write-Host "INFO: Verifying if website exists '$SiteName'." -BackgroundColor "black" -ForegroundColor "blue"
    if (-Not (Test-Path "IIS:\Sites\$SiteName")) {
        Write-Host "WARNING: Invalid website '$SiteName'." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    Write-Host "INFO: Verifying if application pool exists '$ApplicationPoolName'." -BackgroundColor "black" -ForegroundColor "blue"
    if (-Not (Test-Path "IIS:\AppPools\$ApplicationPoolName")) {
        Write-Host "WARNING: Invalid application pool '$ApplicationPoolName'." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    "Creating application $applicationName on site $SiteName"
    Write-Host "INFO: Creating application named '$ApplicationName' under site '$SiteName'." -BackgroundColor "black" -ForegroundColor "blue"
    $application = New-WebApplication -Name $applicationName -Site $SiteName -PhysicalPath $path -ApplicationPool $ApplicationPoolName

    Write-Host "SUCCESS: Application created successfully." -BackgroundColor "black" -ForegroundColor "green"
} catch {
    Write-Host "ERROR: Error detected, restoring the web server to its initial state. Please wait..." -BackgroundColor "black" -ForegroundColor "yellow"
    Restore-WebConfiguration $backupName
    throw
}
