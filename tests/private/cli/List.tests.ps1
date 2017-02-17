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

        $localGists = @(
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

        $githubGist = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/profilecaddie.json"

        $githubGists = @(
            [PSCustomObject]@{
                "user" =  "Xainey"
                "id"   = "a8793a62dcb6d613bf0482ee6deec36f"
                "sha"  = "f965f317fe4c13cc7224484d7494e7e1c9334b38"
                "file" =  "profilecaddie.json"
            }
        )

        Mock Resolve-UncertainPath { return $pscaddie } -ParameterFilter { $Path -eq "~/.pscaddie" }
        Mock Resolve-UncertainPath { return $pscaddieGists } -ParameterFilter { $Path -eq "~/.pscaddie/gists.json" }

        Context "Local Json" {
            It "List should throw if path does not exist" {
                { List } | Should Throw
            }
            It "List should return 0 objects if list is blank" {
                Init -Force
                (List).Count | Should BeExactly 0
            }
            It "Returns the correct single object from the list" {
                Init -Force
                Add -Path $gist1
                (List | ConvertTo-Json) | Should Be ($localGists[0] | ConvertTo-Json)
            }
            It "Returns the correct multiple objects from the list" {
                Init -Force
                Add -Path $gist1
                Add -Path $gist2
                (List | ConvertTo-Json) | Should Be ($localGists | ConvertTo-Json)
            }
        }
        Context "Github Gist Json" {
            It "Returns a list gist json" {
                $json = ($githubGists[0] | ConvertTo-Json -Compress)
                Mock Invoke-WebRequest { return @{Content = $json} } -Verifiable
                ((List -Path $githubGist) | ConvertTo-Json -Compress) | Should Be $json
                Assert-VerifiableMocks
            }
        }
    }
}