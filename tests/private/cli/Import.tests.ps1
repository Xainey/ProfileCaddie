$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
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
            Mock List { return $gists } -ParameterFilter {$Path -eq $Path} -Verifiable
            It "Loads json from github gist" {
                Mock Add {}
                { Import -Path "Test.json" } | Should Not Throw
                Assert-MockCalled Add -Times 2
            }
            It "Loads json from local system" {
                Mock Add {}
                { Import -Path "Test.json" } | Should Not Throw
                Assert-MockCalled Add -Times 2
            }
            It "Asserts all Verifiable Mocks" {
                Assert-VerifiableMocks
            }
        }
    }
}