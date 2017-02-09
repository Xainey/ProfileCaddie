$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/Get-ProfilePath" {
        Context "Returns a list or string" {
            It "returns a string if profile is requested by name" {
                (Get-ProfilePath -Name AllUsersAllHosts) | Should BeOfType String
                (Get-ProfilePath -Name AllUsersCurrentHost) | Should BeOfType String
                (Get-ProfilePath -Name CurrentUserAllHosts) | Should BeOfType String
                (Get-ProfilePath -Name CurrentUserCurrentHost) | Should BeOfType String
            }
            It "returns a PSCustomObject List of all Profiles if `$Name is not included" {
                (Get-ProfilePath) | Should BeOfType PSCustomObject
            }
        }
    }
}