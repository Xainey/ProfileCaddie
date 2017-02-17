$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Mock Resolve-UncertainPath { return "TestDrive:/.pscaddie" } -ParameterFilter { "~/.pscaddie" }
        $gist1 = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
        $gistjson = "https://gist.githubusercontent.com/Xainey/8127ac4840b781f090c162dd97207626/raw/5e0172fdf6768f2660b9ad779c7d8c2d73fa5666/gists.json"

        $gists = @(
            [PSCustomObject]@{
                "user" =  "Xainey"
                "id"   = "a8793a62dcb6d613bf0482ee6deec36f"
                "sha"  = "f965f317fe4c13cc7224484d7494e7e1c9334b38"
                "file" =  "export.ps1"
            },
            [PSCustomObject]@{
                "user" =  "Xainey"
                "id"   = "bc4e497435b440f6699a4f778c89a0c5"
                "sha"  = "cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68"
                "file" =  "touch.ps1"
            }
        )
        Context "Help" {
            It "Gets the docs" {
                { Invoke-ProfileCaddie -Help } | Should Not Throw
            }
            It "Adds gists" {
                { Invoke-ProfileCaddie -Add $gist1 } | Should Not Throw
            }
            It "Exports gists.json" {
                { Invoke-ProfileCaddie -Export "TestDrive:/exported.json" } | Should Throw $LocalizedData.ProfileDirectoryNotFound

                mkdir "TestDrive:\.pscaddie"
                { Invoke-ProfileCaddie -Export "TestDrive:/exported.json" } | Should Throw $LocalizedData.GistJsonNotFound

                Invoke-ProfileCaddie -Init
                Invoke-ProfileCaddie -Export "TestDrive:\.pscaddie\exported.json"
                "TestDrive:\.pscaddie\exported.json" | Should Exist
            }
            It "Imports gists.json" {
                Mock List { return $gists }
                { Invoke-ProfileCaddie -Import } | Should Throw
                { Invoke-ProfileCaddie -Import "TestDrive:/imports/gists.json" } | Should Not Throw
                { Invoke-ProfileCaddie -Import -Path "TestDrive:/imports/gists.json" } | Should Not Throw
                { Invoke-ProfileCaddie -Import -Path $gistjson } | Should Not Throw
            }
            It "Inits the Profile Directory" {
                { Invoke-ProfileCaddie -Init } | Should Not Throw
                { Invoke-ProfileCaddie -Init -Force } | Should Not Throw
            }
            It "Shows a List" {
                { Invoke-ProfileCaddie -List } | Should Not Throw
            }
            It "Makes the output files." {
                Mock Out-File -ParameterFilter { $FilePath -eq $profilePath -and $Force -eq $true }
                { Invoke-ProfileCaddie -Make } | Should Not Throw
            }
            It "Removes a gist" {
                { Invoke-ProfileCaddie -Remove } | Should Throw
            }
        }
    }
}