function ParseGist
{
    [cmdletbinding()]
    param(
        [string] $Uri,
        [switch] $Test
    )

    # May want to restrict to only .ps1 Files
    $regex = [regex] "https:\/\/gist.githubusercontent.com\/(\w+)\/([a-f0-9]+)\/raw\/([a-f0-9]{40})\/([^/\n]*)$"

    if (!$regex.IsMatch($Uri))
    {
        if($Test){
            return $false
        }

        throw "Invalid Gist Uri."
    }
    elseif($Test){
        return $true
    }

    $matches = $regex.Match($Uri)

    return [PSCustomObject]@{
        'user' = $matches.Groups[1].Value
        'id'   = $matches.Groups[2].Value
        'sha'  = $matches.Groups[3].Value
        'file' = $matches.Groups[4].Value
    }
}