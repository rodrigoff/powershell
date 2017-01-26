<#  
.SYNOPSIS  
    Finds all csproj in the supplied path and removes all the duplicate entries.
.DESCRIPTION  
    This script finds all duplicate <content> and <compile> entries in csproj files,
    and removes them.
.NOTES  
    File Name  : RemoveCsProjDuplicates.ps1  
    Author     : Rodrigo F. Fernandes - github.com/rodrigoff
.LINK  
    https://github.com/rodrigoff/powershell/blob/master/csproj-utils/RemoveCsProjDuplicates.ps1
#>
Param(
    [string]$filePath = $(throw "You must supply a file path")
)

$filePath = Resolve-Path $filePath

"> Searching for project files in $filePath"

$projectFiles = Get-ChildItem -Path $filePath -Include *.csproj -Recurse `
| Where-Object { $_.FullName -notmatch "\\packages\\?" } `
| Select-Object -ExpandProperty FullName
 
"> Found $($projectFiles.Count) project files"
 
Foreach($projectFile in $projectFiles) {
    $xml = [xml] (Get-Content $projectFile)
    
    Write-Host "> $projectFile " -Foreground Green

    $entries = $xml.Project.ItemGroup.Compile + $xml.Project.ItemGroup.Content | Group-Object Include
    $duplicateEntries = $entries | Where-Object Count -gt 1

    "- Found $($duplicateEntries.Count) duplicate entries"

    if (!$duplicateEntries) {
        continue
    }
    
    foreach ($duplicateEntry in $duplicateEntries) {
        While ($duplicateEntry.Group.Count -gt 1) {
            $e = $duplicateEntry.Group[0]
            $e.ParentNode.RemoveChild($e) | Out-Null
            $duplicateEntry.Group.Remove($e) | Out-Null
        }
    }

    $xml.Save($projectFile) | Out-Null

    "- Removed $($duplicateEntries.Count) duplicate entries"
}

