$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Private/Make" {
        Context "Create a Profile from Gists" {
            Mock Resolve-UncertainPath { return "TestDrive:\.pscaddie" } -ParameterFilter { $Path -eq "~/.pscaddie" }
            Mock Get-ProfilePath { return "TestDrive:\.pscaddie\PowerShellProfile.ps1" }

            Init -Force
            Add -Uri "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            Add -Uri "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
            Make

            It "Generates a Profile" {
                "TestDrive:\.pscaddie\Profile.ps1" | Should Exist
            }
            It "Adds a marker to `$Profile if missing" {
                $marker = "ProfileCaddie Generated Profile"
                Get-ProfilePath | Should ContainExactly $marker
            }
        }
    }
}