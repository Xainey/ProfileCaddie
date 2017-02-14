# madness lies down this path

param($currentPath)

$leaf = (Split-Path -Leaf $currentPath)
$scriptpath = $currentPath

$root = [System.Collections.ArrayList]::new()
while($leaf -ne "tests")
{
    $scriptpath = (Split-Path -Parent $scriptpath)
    $leaf = (Split-Path -Leaf $scriptpath)
    $root.Add($leaf) | Out-Null
}
#don't need this piece
$root.Remove("tests")

$moduleName = Split-Path (Split-Path $scriptPath -Parent) -Leaf
$here = Split-Path -Parent $currentPath
$SourceFileName = (Split-Path -Leaf $currentPath) -replace '\.Tests\.', '.'
$TestFile = (Split-Path -Leaf $currentPath)
$here2 = $here -replace 'tests', $moduleName

$output = [PSCustomObject]@{
    "TestFile"  = $currentPath
    "SourceFile" = "$here2\$SourceFileName"
    "Namespace"  = (($root | Sort-Object -Descending) -join "\") + "\" + ($SourceFileName)
    "ModuleName"    = $moduleName
}

#load that pesky thing
. $output.SourceFile

Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

return $output