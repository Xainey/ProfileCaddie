<#
.Synopsis
    Get the Help.
#>
function Help()
{
    Get-Help about_ProfileCaddie

    $Private = @( Get-ChildItem -Path $PSScriptRoot/*.ps1 -ErrorAction SilentlyContinue )

    $cli = @()
    foreach($import in $Private)
    {
        $name = (Get-ChildItem $import).BaseName
        $cli += [PSCustomObject]@{
            "Command" = $name
            "Synopsis" = (Get-Help $name).Synopsis
        }
    }

    $cli | Format-Table -AutoSize
}