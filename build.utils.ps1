<#
    .SYNOPSIS
        Create a Zip Archive Build Artifact
#>
function Publish-ArtifactZip
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string] $ModuleName,

        [Parameter(Mandatory=$true)]
        [int] $BuildNumber
    )

    # Creating project artifact
    $artifactDirectory = Join-Path $pwd "artifacts"
    $moduleDirectory = Join-Path $pwd "$ModuleName"
    $manifest = Join-Path $moduleDirectory "$ModuleName.psd1"
    $zipFilePath = Join-Path $artifactDirectory "$ModuleName.zip"

    $version = (Get-Module -FullyQualifiedName $manifest -ListAvailable).Version | Select-Object Major, Minor
    $newVersion = New-Object Version -ArgumentList $version.major, $version.minor, $BuildNumber
    Update-ModuleManifest -Path $manifest -ModuleVersion $newVersion

    Add-Type -assemblyname System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($moduleDirectory, $zipFilePath)
}

<#
    .SYNOPSIS
        Create a Nuget Package for the Build Artifact
        Simple wrapper around DscResourceTestHelper Module
#>
function Publish-NugetPackage
{
   param
    (
        [Parameter(Mandatory=$true)]
        [string] $packageName,
        [Parameter(Mandatory=$true)]
        [string] $author,
        [Parameter(Mandatory=$true)]
        [int] $BuildNumber,
        [Parameter(Mandatory=$true)]
        [string] $owners,
        [string] $licenseUrl,
        [string] $projectUrl,
        [string] $iconUrl,
        [string] $packageDescription,
        [string] $releaseNotes,
        [string] $tags,
        [Parameter(Mandatory=$true)]
        [string] $destinationPath
    )

    $CurrentVersion = (Get-Module -FullyQualifiedName "./$ModuleName" -ListAvailable).Version | Select-Object Major, Minor
    $version = New-Object Version -ArgumentList $CurrentVersion.major, $CurrentVersion.minor, $BuildNumber

    $moduleInfo = @{
        packageName = $packageName
        version =  ($version.ToString())
        author =  $author
        owners = $owners
        licenseUrl = $licenseUrl
        projectUrl = $projectUrl
        packageDescription = $packageDescription
        tags = $tags
        destinationPath = $destinationPath
    }

    # Creating NuGet package artifact
    Import-Module -Name DscResourceTestHelper
    New-Nuspec @moduleInfo

    $nuget = "$env:ProgramData\Microsoft\Windows\PowerShell\PowerShellGet\nuget.exe"
    . $nuget pack "$destinationPath\$packageName.nuspec" -outputdirectory $destinationPath
}

<#
    .SYNOPSIS
        Used to address problem running Publish-Module in NonInteractive Mode when Nuget is not present.

    .NOTES
        https://github.com/OneGet/oneget/issues/173
        https://github.com/PowerShell/PowerShellGet/issues/79

        If Build Agent does not have permission to ProgramData Folder, may want to use the user specific folder.

        Package Provider Expected Locations (x86):
            C:\Program Files (x86)\PackageManagement\ProviderAssemblies
            C:\Users\{USER}\AppData\Local\PackageManagement\ProviderAssemblies
#>
function Install-Nuget
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false)]
        [switch] $Force = $false
    )

    # Force Update Provider
    Install-PackageProvider Nuget -Force

    $sourceNugetExe = "http://nuget.org/nuget.exe"
    $powerShellGetDir = "$env:ProgramData\Microsoft\Windows\PowerShell\PowerShellGet"

    if(!(Test-Path -Path $powerShellGetDir))
    {
        New-Item -ItemType Directory -Path $powerShellGetDir -Force
    }

    if(!(Test-Path -Path "$powerShellGetDir\nuget.exe") -or $Force)
    {
        Invoke-WebRequest $sourceNugetExe -OutFile "$powerShellGetDir\nuget.exe"
    }
}