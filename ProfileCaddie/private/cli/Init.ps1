<#
.Synopsis
    Create or refresh ProfileCaddie config.
#>
function Init {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$False)]
        [switch] $Force = $false
    )

    $pscaddie = Resolve-UncertainPath "~/.pscaddie"
    if ($Force) {
        Remove-Item -Path $pscaddie -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }

    # Creates ~/.pscaddie
    if (!(Test-Path -Path $pscaddie)) {
        New-Item -Path $pscaddie -ItemType Container | Out-Null
    }

    # Creates ~/.pscaddie/private.ps1
    $private = Join-Path $pscaddie "private.ps1"
    if (!(Test-Path -Path $private)) {
        New-Item -Path $private -ItemType File | Out-Null
    }

    # Creates ~/.pscaddie/gists.json
    $gists = Join-Path $pscaddie "gists.json"
    if (!(Test-Path -Path $gists)) {
        New-Item -Path $gists -ItemType File | Out-Null
    }

    # Creates $Profile
    $profilePath = (Get-ProfilePath -Name CurrentUserCurrentHost)
    if (!(Test-Path -Path $profilePath)) {
        New-Item -Path $profilePath -ItemType File | Out-Null
    }
}