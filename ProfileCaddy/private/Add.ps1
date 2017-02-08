function Add
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    # if pscaddy/gists.ps1 doesnt exist should init?
    $psCaddy = Force-ResolvePath "~/.pscaddy"

    $gists = Join-Path $psCaddy "gists.json"
    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = (Get-Content -Path $gists) | ConvertFrom-Json
    }

    $list += ParseGist $Uri

    $json = $list | Sort-Object -Property id, sha -Unique | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}