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
    
    Write-Host "> Sorting $projectFile entries " -Foreground Green

    if (!$xml.Project.ItemGroup.Compile) {
        return;
    }

    $compileParentNode = $xml.Project.ItemGroup.Compile.ParentNode | Select-Object -First 1
    if ($compileParentNode) {

    $xml.Project.ItemGroup.Compile `
        | Sort-Object Include `
        | ForEach-Object { 
            $compileParentNode.AppendChild($_) | Out-Null 
        }
    }

    $contentParentNode = $xml.Project.ItemGroup.Content.ParentNode | Select-Object -First 1
    if ($contentParentNode) {

    $xml.Project.ItemGroup.Content `
        | Sort-Object Include `
        | ForEach-Object { 
            $contentParentNode.AppendChild($_) | Out-Null 
        }
    }
    
    $xml.Save($projectFile) | Out-Null
}
