$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        $pscaddie = "TestDrive:\.pscaddie"
        $pscaddiePrivate = "TestDrive:\.pscaddie\private.ps1"

        $gist1 = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
        $gist2 = "https://gist.githubusercontent.com/Xainey/daf4525b896306fe55fafd3f97091e9e/raw/a7a6e1964c803c0d9703f5e2e6d669052400a105/coreos-hello-world"

        Mock Resolve-UncertainPath { return $pscaddie } -ParameterFilter { "~/.pscaddie" }

        Context "Add Gists" {
            It "Returns message if ~./pscaddie does not exist" {
                Mock Test-Path { return $false } -ParameterFilter { $psCaddie }
                (Add -Uri $gist1) | Should Be "ProfileCaddie directory does not exist. Run -Init."
            }
            It "Should not throw errors" {
                { Add -Uri $gist1 } | Should Not Throw
            }
            It "Should not throw errors for duplicates" {
                { Add -Uri $gist1 } | Should Not Throw
                { Add -Uri $gist1 } | Should Not Throw
            }
            It "Should change from single to multiple" {
                { Add -Uri $gist2 } | Should Not Throw
            }
        }
    }
}