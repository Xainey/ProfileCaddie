$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Scaffolds files" {
            Mock Resolve-UncertainPath { return "TestDrive:\.pscaddie" } -ParameterFilter { "~/.pscaddie" } -Verifiable

            It "Creates `$Profile if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $profilePath }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $profile -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddie if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $pscaddie }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $pscaddie -and $ItemType -eq "Container" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddie/private.ps1 if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $private }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $private -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddie/gists.json if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $gists }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $gists -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
        }
    }
}