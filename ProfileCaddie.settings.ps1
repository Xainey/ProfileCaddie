###############################################################################
# Customize these properties and tasks
###############################################################################
param(
    $Artifacts = './artifacts',
    $ModuleName = 'ProfileCaddie',
    $ModulePath = './ProfileCaddie',
    $BuildNumber = $env:BUILD_NUMBER,
    $UseNextPSGalleryVersion = $false,
    $PercentCompliance  = '0'
)

###############################################################################
# Static settings -- no reason to include these in the param block
###############################################################################

Enter-Build {
    # Skip Setup if Installing Dependencies
    if($BuildTask -eq 'InstallDependencies') { return }

    Set-BuildEnvironment

    $Settings = @{
        Author = "Michael Willis"
        Owners = "Michael Willis"
        LicenseUrl = "https://github.com/Xainey/ProfileCaddie/blob/master/LICENSE"
        ProjectUrl = "https://github.com/Xainey/ProfileCaddie"
        Repository = "https://github.com/Xainey/ProfileCaddie.git"
        PackageDescription = "Use github gists to manage and share your PowerShell profile."
        Tags = "profile,gist,github"
        GitRepo = "Xainey/ProfileCaddie"
        CIUrl = "http://appveyor.com/"
        Timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
        PSVersion = $PSVersionTable.PSVersion.Major
        ProjectRoot = $PSScriptRoot
        Verbose = @{}
    }

    if($ENV:BHCommitMessage -match "!verbose")
    {
        $Settings.Verbose = @{Verbose = $True}
    }

    if($ENV:BHProjectPath)
    {
        $Settings.ProjectRoot = $ENV:BHProjectPath
    }
}

###############################################################################
# Add format line between tasks.
###############################################################################
Enter-BuildJob { "-" * 80 }

###############################################################################
# Before/After Hooks for the Core Task: Clean
###############################################################################

# Synopsis: Executes before the Clean task.
# task BeforeClean -Before Clean {}

# Synopsis: Executes after the Clean task.
# task AfterClean -After Clean {}

###############################################################################
# Before/After Hooks for the Core Task: Analyze
###############################################################################

# Synopsis: Executes before the Analyze task.
# task BeforeAnalyze -Before Analyze {}

# Synopsis: Executes after the Analyze task.
# task AfterAnalyze -After Analyze {}

###############################################################################
# Before/After Hooks for the Core Task: Archive
###############################################################################

# Synopsis: Executes before the Archive task.
# task BeforeArchive -Before Archive {}

# Synopsis: Executes after the Archive task.
# task AfterArchive -After Archive {}

###############################################################################
# Before/After Hooks for the Core Task: Publish
###############################################################################

# Synopsis: Executes before the Publish task.
# task BeforePublish -Before Publish {}

# Synopsis: Executes after the Publish task.
# task AfterPublish -After Publish {}

###############################################################################
# Before/After Hooks for the Core Task: Test
###############################################################################

# Synopsis: Executes before the Test Task.
# task BeforeTest -Before Test {}

# Synopsis: Executes after the Test Task.
# task AfterTest -After Test {}