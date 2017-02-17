<#
.Synopsis
    Remove a Gist from Profile.
#>
function Remove {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Id,

        [Parameter(Mandatory=$False, Position=1)]
        [string] $Sha,

        [Parameter(Mandatory=$False, Position=2)]
        [string] $File
    )

    $gists = Resolve-UncertainPath "~/.pscaddie/gists.json"

    [System.Array] $list = List

    $filtered = $list | Sort-Object -Property id, sha, file -Unique | Where-Object { $_.id -ne $id }

    if ($Sha) {
        $filtered = $filtered | Where-Object { $_.sha -ne $Sha }
    }

    if ($File) {
        $filtered = $filtered | Where-Object { $_.file -ne $File }
    }

    if (($filtered | Sort-Object | Get-Unique).Count -gt 1) {
        Write-Host $filtered
        throw "Multiple matches please use sha and/or file arguments."
    }

    $filtered | ConvertTo-Json | Out-File -FilePath $gists -Force
}