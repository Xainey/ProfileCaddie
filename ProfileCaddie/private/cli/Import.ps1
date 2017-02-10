<#
.Synopsis
    Import a gist url or local json file into ProfileCaddie.
#>
function Import
{
    [cmdletbinding(DefaultParameterSetName="File")]
    param(
        [Parameter(Mandatory=$False, ParameterSetName="Gist")]
        [switch] $Gist,

        [Parameter(Mandatory=$False, ParameterSetName="File")]
        [switch] $File,

        [Parameter(Mandatory=$False, ParameterSetName="File", Position=0)]
        [Parameter(Mandatory=$True, ParameterSetName="Gist", Position=0)]
        [string] $Path
    )

    if($PsCmdlet.ParameterSetName -eq "File")
    {
        [System.Array] $list = List -File $Path
    }
    else
    {
        [System.Array] $list = List -Gist $Path
    }

    foreach($import_item in $list)
    {
        [HashTable] $uri = @{}
        foreach($import_piece in $import_item.psobject.properties)
        {
            $uri[$import_piece.name] = $import_piece.value
        }

        Add -Uri (Get-GistUri @uri)
    }
}