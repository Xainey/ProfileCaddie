function Get-GistUri
{
    [cmdletbinding()]
    param(
        [string] $user,
        [string] $id,
        [string] $sha,
        [string] $file
    )

    return ("https://gist.githubusercontent.com/{0}/{1}/raw/{2}/{3}" -f $User, $Id, $Sha, $File)
}