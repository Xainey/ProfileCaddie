$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Create a Profile from Gists" {

            $localGists = @(
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

            Mock List { return $localGists } -Verifiable
            Mock Resolve-UncertainPath { return "TestDrive:\.pscaddie" } -ParameterFilter { "~/.pscaddie" } -Verifiable
            Mock Get-ProfilePath { return "TestDrive:\.pscaddie\PowerShellProfile.ps1" } -Verifiable

            Init
            Make

            It "Generates a Profile" {
                "TestDrive:\.pscaddie\Profile.ps1" | Should Exist
            }
            It "Adds a marker to `$Profile if missing" {
                $marker = "ProfileCaddie Generated Profile"
                Get-ProfilePath | Should ContainExactly $marker
            }
            It "Verifies all Mocks" {
                Assert-VerifiableMocks
            }
        }
    }
}