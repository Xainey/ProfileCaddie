$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/Make" {
        Context "..." {
            Mock Force-ResolvePath { return "TestDrive:\.pscaddy" } -ParameterFilter { $Path -eq "~/.pscaddy" }
            Mock Get-ProfilePath { return "TestDrive:\.pscaddy\PowerShellProfile.ps1" }

            Init -Force
            Add -Uri "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            Add -Uri "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
            Make

            It "Generates a Profile" {
                "TestDrive:\.pscaddy\Profile.ps1" | Should Exist
            }
            It 'Adds a marker to `$Profile if missing' {
                $marker = "ProfileCaddy Generated Profile"
                (Select-String -Path (Get-ProfilePath) -Pattern $marker).count | Should Be 1
            }
        }
    }
}