###############################################################################
# Customize these properties and tasks when calling Invoke-Build
###############################################################################
param(
    $Artifacts = './artifacts',
    $ModuleName = 'ProfileCaddie',
    $ModulePath = './ProfileCaddie',
    $BuildNumber = $env:BUILD_NUMBER,
    $UseNextPSGalleryVersion = $false,
    $PercentCompliance  = '0'
)

# Include: Settings
. './ProfileCaddie.settings.ps1'

# Include: build.utils
. './build.utils.ps1'

# Synopsis: Run/Publish Tests and Fail Build on Error
task Test RunTests, ConfirmTestsPassed

# Synopsis: Run full Pipleline.
task . Init, Clean, Analyze, Test, Archive

# Synopsis: Show Debug data for CI and Set-Location
Task Init {
    Set-Location $Settings.ProjectRoot
    Get-Item ENV:BH*
}

# Synopsis: Install Build Dependencies
task InstallDependencies {
    # Cant run an Invoke-Build Task without Invoke-Build (Can Force to keep it up to date).
    # Install-Module -Name InvokeBuild -Force

    # May need this
    # Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    # Install-Nuget

    Install-Module -Name DscResourceTestHelper -Force
    Install-Module -Name Pester -Force
    Install-Module -Name PSScriptAnalyzer -Force
    Install-Module -Name PSDeploy -Force
    Install-Module -Name BuildHelpers -Force
}

# Synopsis: Clean Artifacts Directory
task Clean {
    if (Test-Path -Path $Artifacts)
    {
        Remove-Item "$Artifacts/*" -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Artifacts -Force

    # Temp
    $PSTestReportGit = "https://github.com/Xainey/PSTestReport.git"
    $PSTestReportDir = Join-Path (Resolve-Path .) "PSTestReport"
    if (-not (Test-Path -Path $PSTestReportDir))
    {
        & git @('clone',$PSTestReportGit, $PSTestReportDir) | Out-Null
    }
    else
    {
        & git @('-C',$PSTestReportDir,'pull') | Out-Null
    }
}

# Synopsis: Lint Code with PSScriptAnalyzer
task Analyze {
    $scriptAnalyzerParams = @{
        Path = $ModulePath
        Severity = @('Error', 'Warning')
        Recurse = $true
        Verbose = $false
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    # Save Analyze Results as JSON
    $saResults | ConvertTo-Json | Set-Content (Join-Path $Artifacts "ScriptAnalysisResults.json")

    if ($saResults)
    {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings were found."
    }

    "No PSScriptAnalyzer errors/warning were found."
}

# Synopsis: Test the project with Pester. Publish Test and Coverage Reports
task RunTests {
    $invokePesterParams = @{
        OutputFile =  (Join-Path $Artifacts "TestResults.xml")
        OutputFormat = 'NUnitXml'
        Strict = $true
        PassThru = $true
        Verbose = $false
        EnableExit = $false
        CodeCoverage = (Get-ChildItem -Path "$ModulePath\*.ps1" -Exclude "*.Tests.*" -Recurse).FullName
    }

    # Publish Test Results as NUnitXml
    $testResults = Invoke-Pester @invokePesterParams;

    # Save Test Results as JSON
    $testresults | ConvertTo-Json -Depth 5 | Set-Content  (Join-Path $Artifacts "PesterResults.json")

    # Temp: Publish Test Report
    $options = @{
        BuildNumber = $BuildNumber
        GitRepo = $Settings.GitRepo
        GitRepoURL = $Settings.ProjectUrl
        CiURL = $Settings.CiURL
        ShowHitCommands = $true
        Compliance = ($PercentCompliance / 100)
        ScriptAnalyzerFile = (Join-Path $Artifacts "ScriptAnalyzerResults.json")
        PesterFile =  (Join-Path $Artifacts "PesterResults.json")
        OutputDir = "$Artifacts"
    }

    . ".\PSTestReport\Invoke-PSTestReport.ps1" @options
}

# Synopsis: Throws and error if any tests do not pass for CI usage
task ConfirmTestsPassed {
    # Fail Build after reports are created, this allows CI to publish test results before failing
    [xml] $xml = Get-Content (Join-Path $Artifacts "TestResults.xml")
    $numberFails = $xml."test-results".failures
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)

    # Fail Build if Coverage is under requirement
    $json = Get-Content (Join-Path $Artifacts "PesterResults.json") | ConvertFrom-Json
    $overallCoverage = [Math]::Floor(($json.CodeCoverage.NumberOfCommandsExecuted / $json.CodeCoverage.NumberOfCommandsAnalyzed) * 100)
    assert($OverallCoverage -gt $PercentCompliance) ('A Code Coverage of "{0}" does not meet the build requirement of "{1}"' -f $overallCoverage, $PercentCompliance)
}

# Synopsis: Creates Archived Zip and Nuget Artifacts
task Archive {
    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions

    # Bump the module version from PSGallery
    if ($UseNextPSGalleryVersion)
    {
        $Version = Get-NextPSGalleryVersion -Name $env:BHProjectName
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version
    }

    $moduleInfo = @{
        ModuleName = $ModuleName
        BuildNumber = $BuildNumber
    }

    Publish-ArtifactZip @moduleInfo

    $nuspecInfo = @{
        packageName = $ModuleName
        author =  $Settings.Author
        owners = $Settings.Owners
        licenseUrl = $Settings.LicenseUrl
        projectUrl = $Settings.ProjectUrl
        packageDescription = $Settings.PackageDescription
        tags = $Settings.Tags
        destinationPath = $Artifacts
        BuildNumber = $BuildNumber
    }

    Publish-NugetPackage @nuspecInfo
}

# Synopsis: Publish to SMB File Share
task Publish {
    if (!$ENV:BHProjectName -and $ENV:BHProjectName.Count -ne 1)
    {
        throw '$ENV:BHProjectName not set'
    }

    # Credit RamblingCookieMonster: https://github.com/RamblingCookieMonster/PSDepend/blob/fb5cbe8372453d8e355dd63edad3ecd38a8697a3/psake.ps1#L73
    if (
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match '!deploy'
    )
    {
        $Params = @{
            Path = $Settings.ProjectRoot
            Force = $true
        }

        Invoke-PSDeploy @Params
    }
    else
    {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)"
    }
}