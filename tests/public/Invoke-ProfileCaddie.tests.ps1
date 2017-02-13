$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

#since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Public/Invoke-ProfileCaddie" {
        Context "Help" {
            It "Gets the docs" {
                { Invoke-ProfileCaddie -Help } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Add } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Export } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Import } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Init } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -List } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Make } | Should Not Throw
            }
            It "..." {
                { Invoke-ProfileCaddie -Remove } | Should Not Throw
            }
        }
    }
}