function Init
{
    [cmdletbinding()]
    param(
        [switch] $Force = $false
    )

    # Creates ~/.pscaddy if it doesnt exist
    $pscaddy = Force-ResolvePath "~/.pscaddy"
    if($Force)
    {
        Remove-Item -Path $pscaddy -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (!(Test-Path -Path $pscaddy))
    {
        New-Item -Path $pscaddy -ItemType Container
    }

    # Creates ~/.pscaddy/private.ps1 if it doesnt exist
    $private = Join-Path $pscaddy "private.ps1"
    if (!(Test-Path -Path $private))
    {
        New-Item -Path $private -ItemType File
    }

    # Creates ~/.pscaddy/gists.json if it doesnt exist
    $gists = Join-Path $pscaddy "gists.json"
    if (!(Test-Path -Path $gists))
    {
        New-Item -Path $gists -ItemType File
    }

    # Creates $Profile if it doesnt exist
    $profilePath = (Get-ProfilePath -Name CurrentUserCurrentHost)
    if (!(Test-Path -Path $profilePath))
    {
        New-Item -Path $profilePath -ItemType File
    }
}