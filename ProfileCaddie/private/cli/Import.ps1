<#
.Synopsis
    Import a gist url or local json file into ProfileCaddie.
#>
function Import
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Path
    )

    $Type = Get-UriType -Uri $Path

    if($Type -eq "File")
    {
        [System.Array] $list = List -Path $Path
    }
    #TODO change
    else
    {
        [System.Array] $list = List -Path $Path
    }

    foreach($import_item in $list)
    {
        [HashTable] $uri = @{}
        foreach($import_piece in $import_item.psobject.properties)
        {
            $uri[$import_piece.name] = $import_piece.value
        }

        Add -Path (Get-GistUri @uri)
    }
}