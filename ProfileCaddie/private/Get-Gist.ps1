function Get-Gist {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True, ParameterSetName="Parse")]
        [string] $Uri,
        [Parameter(Mandatory=$False, ParameterSetName="Parse")]
        [switch] $isValid,

        [Parameter(Mandatory=$True, ParameterSetName="Link")]
        [string] $User,
        [string] $Id,
        [string] $Sha,
        [string] $File
    )

    if($PsCmdlet.ParameterSetName -eq "Link"){
        return ("https://gist.githubusercontent.com/{0}/{1}/raw/{2}/{3}" -f $User, $Id, $Sha, $File)
    }

    # May want to restrict to only .ps1 Files
    $regex = [regex] "https:\/\/gist.githubusercontent.com\/(\w+)\/([a-f0-9]+)\/raw\/([a-f0-9]{40})\/([^/\n]*)$"

    if (!$regex.IsMatch($Uri)){
        if($isValid){
            return $false
        }
            throw "Invalid Gist Uri."
    }
    elseif($isValid){
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