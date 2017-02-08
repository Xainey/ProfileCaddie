function List
{
    $gists = Force-ResolvePath "~/.pscaddy/gists.json"

    if ((Test-Path -Path $gists))
    {
        [System.Array] $list = (Get-Content -Path $gists) | ConvertFrom-Json
    }

    return $list
}
