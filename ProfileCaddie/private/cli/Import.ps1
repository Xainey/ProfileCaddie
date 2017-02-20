<#
.Synopsis
    Import a Gist URL or local JSON file into ProfileCaddie.
#>
function Import
{
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Path
    )

    [System.Array] $list = List -Path $Path

    foreach ($item in $list) {
        [HashTable] $uri = @{}
        foreach ($prop in $item.psobject.properties) {
            $uri[$prop.name] = $prop.value
        }

        Add (Get-Gist @uri)
    }
}