function Export
{
    [cmdletbinding()]
    param(
        [string] $Path
    )

    $psCaddy = Force-ResolvePath "~/.pscaddy"

    $gists = Join-Path $psCaddy "gists.json"

    Copy-Item -Path $gists -Destination $Path
}