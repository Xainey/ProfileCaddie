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

    $type = Get-UriType -Uri $Path

    if ($type -eq [UriType]::File) {
        Write-Verbose ($LocalizedData.LoadListFromFile -f $Path)
        if (Test-Path -Path $Path) {
            [System.Array] $list = (Get-Content -Path $Path) | ConvertFrom-Json
        } else {
            throw ($LocalizedData.ListDoesNotExist -f $Path)
        }
    } else {
        Write-Verbose ($LocalizedData.LoadListFromUri -f $Path)

        if (!(Test-Uri -Type $type -Uri $Path)) {
            throw ($LocalizedData.BadResponseFromUri -f $Path)
        }

        $content = (Invoke-WebRequest $Path).Content
        [System.Array] $list = $content | ConvertFrom-Json
    }

    return $list
}