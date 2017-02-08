function Init
{
    [cmdletbinding()]
    param(
        [switch] $Force = $false
    )

    # Creates `$Profile if it doesnt exist
    if (!(Test-Path -Path $profile))
    {
        New-Item -Path $profile -ItemType File
    }

    # Creates ~/.pscaddy if it doesnt exist
    $pscaddy = Force-ResolvePath "~/.pscaddy"

    if($Force)
    {
        Remove-Item -Path $pscaddy -Recurse -Force
    }


    if (!(Test-Path -Path $pscaddy))
    {
        New-Item -Path $pscaddy -ItemType Container
    }

    # Creates ~/.pscaddy/private.ps1 if it doesnt exist
    $private = Force-ResolvePath "~/.pscaddy/private.ps1"
    if (!(Test-Path -Path $private))
    {
        New-Item -Path $private -ItemType File
    }

    # Creates ~/.pscaddy/gists.json if it doesnt exist
    $gists = Force-ResolvePath "~/.pscaddy/gists.json"
    if (!(Test-Path -Path $gists))
    {
        New-Item -Path $gists -ItemType File
    }
}