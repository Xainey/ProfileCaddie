function Add
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    # if pscaddy/gists.ps1 doesnt exist should init?
    $gists = Force-ResolvePath "~/.pscaddy/gists.json"

    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = (Get-Content -Path $gists) | ConvertFrom-Json
    }

    $list += ParseGist $Uri

    $json = $list | Sort-Object -Property id, sha -Unique | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}

<# Using XML
function Add
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    # if pscaddy/gists.ps1 doesnt exist should init?
    $gists = Force-ResolvePath "~/.pscaddy/gists.xml"

    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = Import-CliXML -Path $gists
    }

    $list += ParseGist $Uri

    $list | Sort-Object -Property id, sha -Unique | Export-Clixml -Path $gists
}
#>