<#
.Synopsis
    List all of the Gists added to profile.
#>
function List {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$False, Position=0)]
        [string] $Path = (Resolve-UncertainPath "~/.pscaddie/gists.json")
    )

    $Type = Get-UriType -Uri $Path

    if ($Type -eq "File") {
        if (Test-Path -Path $Path) {
            [System.Array] $list = (Get-Content -Path $Path) | ConvertFrom-Json
        } else {
            throw "TODO:List at $Path does not exist."
        }
    } else {
        $testUri = Get-Gist -Uri $Path
        Write-Verbose $testUri
        $content = (Invoke-WebRequest $Path).Content
        [System.Array] $list = $content | ConvertFrom-Json
    }

    return $list
}