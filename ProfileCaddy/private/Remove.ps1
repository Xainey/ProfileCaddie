function Remove
{
    [cmdletbinding()]
    param(
        [string] $id
    )

    $gists = Force-ResolvePath "~/.pscaddy/gists.json"

    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = (Get-Content -Path $gists) | ConvertFrom-Json
    }


    $json = $list | Sort-Object -Property id, sha -Unique | Where-Object { $_.id –ne $id } | ConvertTo-Json

    $json | Out-File -FilePath $gists -Force
}