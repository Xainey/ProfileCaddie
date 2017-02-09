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

    foreach($item in $list)
    {
        $uri = @{}
        foreach($piece in $item.psobject.properties)
        {
            $uri[$piece.name] = $piece.value
        }

        Add -Uri (Get-GistUri @uri)
    }
}