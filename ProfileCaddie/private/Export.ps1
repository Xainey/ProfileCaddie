<#
.Synopsis
    Export a Copy of gists.json.
#>
function Export
{
    [cmdletbinding()]
    param(
        [string] $Path
    )

    $psCaddie = Force-ResolvePath "~/.pscaddie"

    $gists = Join-Path $psCaddie "gists.json"

    Copy-Item -Path $gists -Destination $Path
}