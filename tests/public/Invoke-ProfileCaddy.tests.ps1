$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

#since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Public/Invoke-ProfileCaddy" {
        Context "Help" {
            It "gets the docs" {
                {Invoke-ProfileCaddy -Help } | Should Not Throw
            }
        }
    }
}