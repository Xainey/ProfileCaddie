$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Private/Import" {

        $gists = @(
            [PSCustomObject]@{
                "user" =  "Xainey"
                "id"   = "a8793a62dcb6d613bf0482ee6deec36f"
                "sha"  = "f965f317fe4c13cc7224484d7494e7e1c9334b38"
                "file" =  "export.ps1"
            },
            [PSCustomObject]@{
                "user" =  "Xainey"
                "id"   = "bc4e497435b440f6699a4f778c89a0c5"
                "sha"  = "cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68"
                "file" =  "touch.ps1"
            }
        )

        Context "Imports Gists from File or Github" {
            Mock List { return $gists } -ParameterFilter {$Gist -eq $True -and $Path -eq $Path} -Verifiable
            Mock List { return $gists } -ParameterFilter {$File -eq $True -and $Path -eq $Path} -Verifiable
            It "Loads json from github gist" {
                Mock Add {}
                { Import -Gist "Test.json" } | Should Not Throw
                Assert-MockCalled Add -Times 2
            }
            It "Loads json from local system" {
                Mock Add {}
                { Import -File "Test.json" } | Should Not Throw
                Assert-MockCalled Add -Times 2
            }
            It "Asserts all Verifiable Mocks" {
                Assert-VerifiableMocks
            }
        }
    }
}