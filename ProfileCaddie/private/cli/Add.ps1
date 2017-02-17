<#
.Synopsis
    Add a Raw Gist url to ProfileCaddie.
#>
function Add {
    [cmdletbinding()]
    param (
        [string] $Path
    )

    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    if (!(Test-Path $psCaddie)) {
        return ($LocalizedData.ProfileDirectoryNotFound)
    }

    $type = Get-UriType -Uri $Path

    if ($type -eq "Gist") {
        $gists = Join-Path $psCaddie "gists.json"

        [System.Array] $list = List

        $list += Get-Gist -Uri $Path

        $json = $list | Sort-Object -Property id, sha, file -Unique | ConvertTo-Json

        $json | Out-File -FilePath $gists -Force
    }
}