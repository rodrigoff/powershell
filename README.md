# powershell-iis
PowerShell IIS scripts

#### CreateSite.ps1
```
Powershell script to create a local website and application pool.
Usage: CreateSite.ps1
  -SiteName [SiteName]
  -ApplicationPoolName [ApplicationPoolName]
  -Port [Port]
  -Path [Path]
  (-Username [domain\user])
  (-Password[password])
``` 

---

#### CreateApplication.ps1
```
Powershell script to create a new application in a site.
Usage: CreateApplication.ps1
  -SiteName [SiteName]
  -ApplicationPoolName [ApplicationPoolName]
  -ApplicationName [Port]
  -Path [Path]
```
