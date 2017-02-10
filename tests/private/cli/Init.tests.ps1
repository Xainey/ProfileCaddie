$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Private/cli/Init" {
        Context "Scaffolds files" {
            It "Creates `$Profile if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $profile }
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