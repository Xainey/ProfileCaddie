# Install Dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Install-Module InvokeBuild -Force
Invoke-Build -Task InstallDependencies

# Run Pipeline
Invoke-Build -Task . -UseNextPSGalleryVersion $true

# Publish Test Results
$testResultsFile = (Resolve-Path ".\artifacts\TestResults.xml")
(New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", $testResultsFile)

# Push All Artifacts
(Get-ChildItem .\artifacts\*.*) | % { Write-Host "Pushing package $_ as Appveyor artifact"; Push-AppveyorArtifact $_ }