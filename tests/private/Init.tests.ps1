$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/Init" {
        Context "Scaffolds files" {
            It "Creates `$Profile if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $profile }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $profile -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddy if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $pscaddy }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $pscaddy -and $ItemType -eq "Container" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddy/private.ps1 if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $private }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $private -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
            It "Creates ~/.pscaddy/gists.json if it doesnt exist" {
                Mock Test-Path { return $false } -Verifiable -ParameterFilter {$Path -eq $gists }
                Mock New-Item {} -Verifiable -ParameterFilter {$Path -eq $gists -and $ItemType -eq "File" }
                Init
                Assert-VerifiableMocks
            }
        }
    }
}