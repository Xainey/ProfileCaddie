<#
.Notes

Comparing PSCustomObjects
-------------------------
Comparing with JSON in this case is ok
(List | ConvertTo-Json) | Should be ($gist | ConvertTo-Json)

Alternatives:
(Compare-Object $a $b -IncludeEqual).SideIndicator | Should Be "=="
foreach ($prop in ($a.psobject.properties)){$prop.value | Should Be $b."$($prop.name)"}

Other:
- https://www.powershellgallery.com/packages/Compare-ObjectProperty/1.0.0.0/DisplayScript
- https://github.com/nohwnd/Assertions
#>

$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        $pscaddie = "TestDrive:\.pscaddie"
        $pscaddieGists = "TestDrive:\.pscaddie\gists.json"

        $gist1 = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
        $gist2 = "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
        $gist3 = "https://gist.githubusercontent.com/Xainey/70caeb4f7d61f25db22bc07fb9e45264/raw/7f4307dca14c56d7260feca029600ca92fd507d3/Send-WakeOnLan.ps1"

        $testGists = @(
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

        $gist4 = "https://gist.githubusercontent.com/Xainey/8127ac4840b781f090c162dd97207626/raw/5e0172fdf6768f2660b9ad779c7d8c2d73fa5666/export.ps1"
        $gist5 = "https://gist.githubusercontent.com/Xainey/8127ac4840b781f090c162dd97207626/raw/5e0172fdf6768f2660b9ad779c7d8c2d73fa5666/one_liners.ps1"
        $gist6 = "https://gist.githubusercontent.com/Xainey/8127ac4840b781f090c162dd97207626/raw/5e0172fdf6768f2660b9ad779c7d8c2d73fa5666/touch.ps1"


        Mock Resolve-UncertainPath { return $pscaddie } -ParameterFilter { $Path -eq "~/.pscaddie" }
        Mock Resolve-UncertainPath { return $pscaddieGists } -ParameterFilter { $Path -eq "~/.pscaddie/gists.json" }

        Context "Removing Gists" {
            BeforeEach {
                Init -Force
                Add -Path $gist1
                Add -Path $gist2
                Add -Path $gist3
            }

            It "Removes items by id" {
                Remove -Id "70caeb4f7d61f25db22bc07fb9e45264"
                (List | ConvertTo-Json) | Should be ($testGists | ConvertTo-Json)
                (List).Count | Should BeExactly 2
            }
            It "Does not throw if ID is not found" {
                { Remove -Id "NON_EXISTENT_ID" } | Should Not Throw
            }
            It "Throws if ID is `$null or blank" {
                { Remove -Id $null } | Should Throw
                { Remove } | Should Throw
            }
        }
        Context "Specificity Conflicts" {
            BeforeEach {
                Init -Force
                Add -Path $gist4
                Add -Path $gist5
                Add -Path $gist6
            }

            It "Throws and error if ID is not specific enough" {
                { Remove -Id "8127ac4840b781f090c162dd97207626" } | Should Throw
            }
            It "Throws and error if ID+Sha is not specific enough" {
                { Remove -Id "8127ac4840b781f090c162dd97207626" -Sha "5e0172fdf6768f2660b9ad779c7d8c2d73fa5666" } | Should Throw
            }
            It "Should not throw given Id+Sha+File" {
                { Remove -Id "8127ac4840b781f090c162dd97207626" -Sha "5e0172fdf6768f2660b9ad779c7d8c2d73fa5666" -File "export.ps1" } | Should Not Throw
            }
        }

    }
}