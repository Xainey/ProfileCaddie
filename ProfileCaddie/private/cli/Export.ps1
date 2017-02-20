<#
.Synopsis
    Export a Copy of gists.json.
.Notes
    Only supports gists. Should Expand to support multiple types.
#>
function Export {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Path
    )

    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    $gists = Join-Path $psCaddie "gists.json"

    if (!(Test-Path $psCaddie)) {
        throw ($LocalizedData.ProfileDirectoryNotFound)
    }

    if (!(Test-Path $gists)) {
        throw ($LocalizedData.GistJsonNotFound)
    }

    Copy-Item -Path $gists -Destination $Path
}