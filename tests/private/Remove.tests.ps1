$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/Remove" {
        Context "..." {
            It "..." {

            }
        }
    }
}