$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Private/Force-ResolvePath" {
        Context "Non-Existant Path" {
            It "It does not thow if the path does not exist" {
                { Force-ResolvePath "~/.example/does/not/exist.ps1" } | Should Not Throw
            }
        }
    }
}