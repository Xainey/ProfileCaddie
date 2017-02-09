function Add
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    # if pscaddy/gists.ps1 doesnt exist should init?
    $psCaddy = Force-ResolvePath "~/.pscaddy"

    $gists = Join-Path $psCaddy "gists.json"

    [System.Array] $list = List

    $list += ParseGist $Uri

    $json = $list | Sort-Object -Property id, sha -Unique | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}