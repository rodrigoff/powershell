## Intro: Powershell script to create a local website and application pool.
## Usage: CreateSite.ps1
##   -SiteName [SiteName]
##   -ApplicationPoolName [ApplicationPoolName]
##   -Port [Port]
##   -Path [Path]
##  (-Username [domain\user])
##  (-Password[password])

param(
    [string]$SiteName = "",
    [string]$ApplicationPoolName = "",
    [int]$Port = 0,
    [string]$Path = "",
    [string]$Username = "",
    [string]$Password = ""
    )

Import-Module WebAdministration

if($SiteName -eq "")            { throw "Argument -SiteName is missing." }
if($ApplicationPoolName -eq "") { throw "Argument -ApplicationPoolName is missing." }
if($Port -eq 0)                 { throw "Argument -Port is missing." }
if($Path -eq "")                { throw "Argument -Path is missing." }

$backupName = "$(Get-date -format "yyyyMMdd-HHmmss")-$SiteName"
Write-Host "INFO: Backing up IIS config to backup named '$backupName'." -BackgroundColor "black" -ForegroundColor "blue"
$backup = Backup-WebConfiguration $backupName

try {
    Write-Host "INFO: Verifying if website exists '$SiteName'." -BackgroundColor "black" -ForegroundColor "blue"
    if (Test-Path "IIS:\Sites\$SiteName") {
        Write-Host "WARNING: Website '$SiteName' already exists." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    Write-Host "INFO: Verifying if application pool exists '$ApplicationPoolName'." -BackgroundColor "black" -ForegroundColor "blue"
    if (Test-Path "IIS:\AppPools\$ApplicationPoolName") {
        Write-Host "WARNING: Application Pool '$ApplicationPoolName' already exists." -BackgroundColor "black" -ForegroundColor "yellow"
        return
    }

    foreach($site in Get-ChildItem IIS:\Sites) {
        if($site.Bindings.Collection.bindingInformation -eq ("*:" + $Port + ":")){
            Write-Host "WARNING: Found an existing site '$($site.Name)' already using port $Port." -BackgroundColor "black" -ForegroundColor "yellow"
            return
        }
    }

    Write-Host "INFO: Creating application pool named '$ApplicationPoolName' under v4.0 runtime, default (Integrated) pipeline." -BackgroundColor "black" -ForegroundColor "blue"
    $pool = New-WebAppPool $ApplicationPoolName
    $pool.managedRuntimeVersion = "v4.0"
    $pool.processModel.identityType = 2 #NetworkService

	if ($Username -ne $null -AND $Password -ne $null) {
	    Write-Host "INFO: Setting application pool to run as '$Username'." -BackgroundColor "black" -ForegroundColor "blue"
		$pool.processmodel.identityType = 3
		$pool.processmodel.username = $Username
		$pool.processmodel.password = $Password
	}

    $pool | Set-Item

    if ((Get-WebAppPoolState -Name $ApplicationPoolName).Value -ne "Started") {
        throw "ERROR: Application pool '$ApplicationPoolName' was created but did not start automatically."
    }

    "INFO: Creating website '$SiteName' from directory '$Path' on port '$Port'."
    $website = New-Website -Name $SiteName -PhysicalPath $Path -ApplicationPool $ApplicationPoolName -Port $Port

    if ((Get-WebsiteState -Name $SiteName).Value -ne "Started") {
        throw "ERROR: Website '$SiteName' was created but did not start automatically."
    }

    Write-Host "SUCCESS: Website and application pool created and started sucessfully." -BackgroundColor "black" -ForegroundColor "green"
} catch {
    Write-Host "ERROR: Error detected, restoring the web server to its initial state. Please wait..." -BackgroundColor "black" -ForegroundColor "yellow"
    Restore-WebConfiguration $backupName
    throw
}
