function ParseGist
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    $regex = [regex] "https:\/\/gist.githubusercontent.com\/(\w+)\/([a-f0-9]+)\/raw\/([a-f0-9]{40})\/([^/\n]*)$"

    if (!($uri -match $regex))
    {
        return $true
    }

    $s = $Uri -split '/'

    return $gist = [PSCustomObject]@{
        'user' = $s[3]
        'file' = $s[7]
        'id'   = $s[4]
        'sha'  = $s[6]
    }
}