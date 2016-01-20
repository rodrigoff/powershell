## ![PowerShell](https://i-technet.sec.s-msft.com/en-us/Powershell/ux/library/dn966235.Powershell_32.png?Segments=http%3a%2f%2ftechnet.microsoft.com%2flibrary&isLibrary=true&OverwriteHostBase=https%3a%2f%2fmsdn.microsoft.com%2f&isMtpsRequest=true&ThemeBranding=Powershell&HideProfileLink=false&HideProfileText=false) PowerShell IIS scripts

#### CreateSite.ps1
```
Powershell script to create a new website and application pool.
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

#### IISExpressCleanup.ps1
```
Powershell script to cleanup IIS Express configurations.
````