function ParseGist
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    $s = $Uri -split '/'

    return $gist = [PSCustomObject]@{
        'user' = $s[3]
        'file' = $s[7]
        'id'   = $s[4]
        'sha'  = $s[6]
    }
}