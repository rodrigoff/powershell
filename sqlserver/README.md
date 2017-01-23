## ![PowerShell](https://i-technet.sec.s-msft.com/en-us/Powershell/ux/library/dn966235.Powershell_32.png?Segments=http%3a%2f%2ftechnet.microsoft.com%2flibrary&isLibrary=true&OverwriteHostBase=https%3a%2f%2fmsdn.microsoft.com%2f&isMtpsRequest=true&ThemeBranding=Powershell&HideProfileLink=false&HideProfileText=false) SQL Server scripts

#### CreateDatabase.ps1
```
Script to create a new SQL Server database.
Usage: CreateDatabase.ps1
```

---

#### BackupDatabase.ps1
```
Script to backup a SQL Server database.
Usage: BackupDatabase.ps1
  -ServerName [ServerName]
  -DatabaseName [DatabaseName]
  -BackupPath [BackupPath]
```

---

#### RestoreBackup.ps1
```
Script to restore a SQL Server database.
Usage: RestoreBackup.ps1
  -ServerName [ServerName]
  -DatabaseName [DatabaseName]
  -BackupPath [BackupPath]
```