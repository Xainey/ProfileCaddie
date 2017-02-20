<#
.Synopsis
    Add a Raw Gist URL to ProfileCaddie.
#>
function Add {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Path
    )

    $psCaddie = Resolve-UncertainPath "~/.pscaddie"

    if (!(Test-Path $psCaddie)) {
        return ($LocalizedData.ProfileDirectoryNotFound)
    }

    $type = Get-UriType -Uri $Path

    Write-Verbose ($LocalizedData.GetUriType -f $type)

    if ($type -eq [UriType]::Gist) {
        $gists = Join-Path $psCaddie "gists.json"

        [System.Array] $list = List

        $list += Get-Gist -Uri $Path

        $json = $list | Sort-Object -Property id, sha, file -Unique | ConvertTo-Json

        Write-Verbose ($LocalizedData.CreatingFile -f $gists)
        $json | Out-File -FilePath $gists -Force
    }
    else {
        throw ($LocalizedData.TypeNotImplemented -f $type)
    }
}