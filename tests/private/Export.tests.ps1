$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Private/Export" {
        Context "Basic Export" {
            It "Copies the gist.json file to target path" {
                Mock Copy-Item {} -Verifiable
                Export -Path "./gists.json"
                Assert-VerifiableMocks
            }
        }
    }
}