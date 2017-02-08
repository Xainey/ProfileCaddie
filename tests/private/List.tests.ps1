<#
.Notes

Comparing PSCustomObjects
-------------------------
Comparing with JSON in this case is ok
(List | ConvertTo-Json) | Should be ($gist | ConvertTo-Json)

Alternatives:
(Compare-Object $a $b -IncludeEqual).SideIndicator | Should Be "=="
foreach($prop in ($a.psobject.properties)){$prop.value | Should Be $b."$($prop.name)"}

Other:
- https://www.powershellgallery.com/packages/Compare-ObjectProperty/1.0.0.0/DisplayScript
- https://github.com/nohwnd/Assertions
#>

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/List" {

        $pscaddy = "TestDrive:\.pscaddy"
        $pscaddyGists = "TestDrive:\.pscaddy\gists.json"

        $gist1 = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
        $gist2 = "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"

        $gists = @(
            [PSCustomObject]@{
                "user" =  "Xainey"
                "file" =  "export.ps1"
                "id"   = "a8793a62dcb6d613bf0482ee6deec36f"
                "sha"  = "f965f317fe4c13cc7224484d7494e7e1c9334b38"
            },
            [PSCustomObject]@{
                "user" =  "Xainey"
                "file" =  "touch.ps1"
                "id"   = "bc4e497435b440f6699a4f778c89a0c5"
                "sha"  = "cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68"
            }
        )

        Mock Force-ResolvePath { return $pscaddy } -ParameterFilter { $Path -eq "~/.pscaddy" }
        Mock Force-ResolvePath { return $pscaddyGists } -ParameterFilter { $Path -eq "~/.pscaddy/gists.json" }

        Context "Gists" {
            It "List should be empty if list is blank or non-existant" {
                (List).Count | Should BeExactly 0
            }
            It "Returns the correct single object from the list" {
                Init
                Add -Uri $gist1
                (List | ConvertTo-Json) | Should be ($gists[0] | ConvertTo-Json)
            }
            It "Returns the correct multiple objects from the list" {
                Init
                Add -Uri $gist1
                Add -Uri $gist2
                (List | ConvertTo-Json) | Should be ($gists | ConvertTo-Json)
            }
        }
    }
}