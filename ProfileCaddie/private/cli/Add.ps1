<#
.Synopsis
    Add a Raw Gist url to ProfileCaddie.
#>
function Add
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    # if pscaddie/gists.ps1 doesnt exist should init?
    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    $gists = Join-Path $psCaddie "gists.json"

    [System.Array] $list = List

    $list += ParseGist $Uri

    $json = $list | Sort-Object -Property id, sha, file -Unique | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}