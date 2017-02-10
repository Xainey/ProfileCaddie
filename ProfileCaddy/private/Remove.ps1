<#
.Synopsis
    Remove a Gist from Profile.
#>
function Remove
{
    [cmdletbinding()]
    param(
        [string] $Id
    )

    if($Id -eq $null -or $Id -eq "")
    {
        throw ("Must provide a gist ID to remove. View All with -List.")
    }

    $gists = Force-ResolvePath "~/.pscaddy/gists.json"

    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = (Get-Content -Path $gists) | ConvertFrom-Json
    }


    $json = $list | Sort-Object -Property id, sha -Unique | Where-Object { $_.id -ne $id } | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}