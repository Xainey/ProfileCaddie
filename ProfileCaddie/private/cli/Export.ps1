<#
.Synopsis
    Export a Copy of gists.json.
#>
function Export {
    [cmdletbinding()]
    param (
        [string] $Path
    )

    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    $gists = Join-Path $psCaddie "gists.json"

    if (!(Test-Path $psCaddie)) {
        return ($LocalizedData.ProfileDirectoryNotFound)
    }

    if (!(Test-Path $gists)) {
        return ($LocalizedData.GistJsonNotFound)
    }

    Copy-Item -Path $gists -Destination $Path
}