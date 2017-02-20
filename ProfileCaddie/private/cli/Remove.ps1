<#
.Synopsis
    Remove a Gist from Profile.
#>
function Remove {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Id,

        [Parameter(Mandatory=$False, Position=1)]
        [string] $Sha,

        [Parameter(Mandatory=$False, Position=2)]
        [string] $File
    )

    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    if (!(Test-Path $psCaddie)) {
        return ($LocalizedData.ProfileDirectoryNotFound)
    }

    $gists = Join-Path $psCaddie "gists.json"

    [System.Array] $list = (List | Sort-Object -Property id, sha, file -Unique)

    $filtered = $list.Where({$_.id -eq $Id})

    if ($Sha) {
        $filtered = $filtered.Where({$_.sha -eq $Sha})
    }

    if ($File) {
        $filtered = $filtered.Where({$_.file -eq $File})
    }

    if ($filtered.Count -gt 1) {
        throw ($LocalizedData.MultipleGistsFound)
    }

    Write-Verbose ($LocalizedData.CreatingFile -f $gists)
    $list.Where({$_ -notin $filtered}) | ConvertTo-Json | Out-File -FilePath $gists -Force
}