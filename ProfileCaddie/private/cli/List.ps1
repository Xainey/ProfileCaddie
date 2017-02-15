<#
.Synopsis
    List all of the Gists added to profile.
#>
function List
{
    [cmdletbinding(DefaultParameterSetName="File")]
    param(
        [Parameter(Mandatory=$False, ParameterSetName="Gist")]
        [switch] $Gist,

        [Parameter(Mandatory=$False, ParameterSetName="File")]
        [switch] $File,

        [Parameter(Mandatory=$False, ParameterSetName="File", Position=0)]
        [Parameter(Mandatory=$True, ParameterSetName="Gist", Position=0)]
        [string] $Path = (Resolve-UncertainPath "~/.pscaddie/gists.json")
    )

    if($PsCmdlet.ParameterSetName -eq "File")
    {
        if ((Test-Path -Path $Path))
        {
            [System.Array] $list = (Get-Content -Path $Path) | ConvertFrom-Json
        }
    }
    else
    {
        $testUri = ParseGist -Uri $Path
        Write-Verbose $testUri
        $content = (Invoke-WebRequest $Path).Content
        [System.Array] $list = $content | ConvertFrom-Json
    }

    return $list
}