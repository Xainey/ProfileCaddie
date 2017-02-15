# Madness lies down this path :)
param($currentPath)

# Walk to Module root
$scriptpath = $currentPath
$leaf = (Split-Path -Leaf $currentPath)
$walker = [System.Collections.ArrayList]::new()
while($leaf -ne "tests") {
    $scriptpath = Split-Path -Parent $scriptpath
    $leaf = Split-Path -Leaf $scriptpath

    if($leaf -eq "tests"){
        break
    }

    $walker.Add($leaf) | Out-Null
}

# Split and Replace Hell
$ModuleRootDirectory = Split-Path $scriptPath -Parent
$ModuleName = Split-Path (Split-Path $scriptPath -Parent) -Leaf
$PathFromModuleRoot = ($walker | Sort-Object -Descending) -join "\"

$TestFile = $currentPath
$TestFileName = Split-Path -Leaf $currentPath
$TestDirectory = Split-Path -Parent $currentPath

$SourceFileName = (Split-Path -Leaf $currentPath) -replace '\.Tests\.', '.'
$SourceDirectory = $TestDirectory -replace 'tests', $ModuleName
$SourceFile = Join-Path $SourceDirectory $SourceFileName

# Form the return output
$output = [PSCustomObject]@{
    'TestFile' =  $TestFile
    'TestFileName' = $TestFileName
    'TestDirectory' = $TestDirectory
    'ModuleRootDirectory' = $ModuleRootDirectory
    'ModuleName' = $ModuleName
    'SourceFile' = $SourceFile
    'SourceFileName' = $SourceFileName
    'SourceDirectory' = $SourceDirectory
    'PathFromModuleRoot' = $PathFromModuleRoot
    'Namespace' = "$PathFromModuleRoot\$SourceFileName"
    'ManifestPath' = "$ModuleRootDirectory\$ModuleName\$ModuleName.psm1"
}

# Load the Source script
. $output.SourceFile

# Import the Module for the Pester Test
Import-Module $output.ManifestPath -Force

return $output