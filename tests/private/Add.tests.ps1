$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/Add" {

        $profile = "TestDrive:\profile.ps1"
        $pscaddy = "TestDrive:\.pscaddy"
        $pscaddyPrivate = "TestDrive:\.pscaddy\private.ps1"

        Context "Gists" {
            It "Should not throw errors" {
                $gist = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
                { Add -Uri $gist } | Should Not Throw
            }
            It "Should not throw errors for duplicates" {
                $gist = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
                { Add -Uri $gist } | Should Not Throw
                { Add -Uri $gist } | Should Not Throw
            }
            It "Should change from single to multiple" {
                $gist = "https://gist.githubusercontent.com/Xainey/daf4525b896306fe55fafd3f97091e9e/raw/a7a6e1964c803c0d9703f5e2e6d669052400a105/coreos-hello-world"
                { Add -Uri $gist } | Should Not Throw
            }
        }
    }
}