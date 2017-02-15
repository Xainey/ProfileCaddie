<#
    .SYNOPSIS
        ...

    .DESCRIPTION
        ...

    .PARAMETER Help
        Show custom Help Docs. For Native help use (Get-Help Invoke-ProfileCaddie).

    .PARAMETER Force
        ...

    .PARAMETER Path
        ...

    .PARAMETER Id
        ...

    .EXAMPLE
        Invoke-ProfileCaddie -Init
        Invoke-ProfileCaddie -Add "raw gist url"
        Invoke-ProfileCaddie -Make

    .NOTES
#>
function Invoke-ProfileCaddie
{
    [cmdletbinding(DefaultParameterSetName="Help")]
    param(
        ###############################################################################
        # CLI Command Flags
        ###############################################################################

        # Help
        [Parameter(Mandatory=$False, ParameterSetName="Help")]
        [switch] $Help,

        # Add
        [Parameter(Mandatory=$True, ParameterSetName="Add")]
        [switch] $Add,

        # Export
        [Parameter(Mandatory=$True, ParameterSetName="Export")]
        [switch] $Export,

        # Import
        [Parameter(Mandatory=$True, ParameterSetName="Import")]
        [switch] $Import,

        # Init
        [Parameter(Mandatory=$True, ParameterSetName="Init")]
        [switch] $Init,

        # List
        [Parameter(Mandatory=$True, ParameterSetName="List")]
        [switch] $List,

        # Make
        [Parameter(Mandatory=$True, ParameterSetName="Make")]
        [switch] $Make,

        # Remove
        [Parameter(Mandatory=$True, ParameterSetName="Remove")]
        [switch] $Remove,

        ###############################################################################
        # Bound Parameters
        ###############################################################################

        # Path
        [Parameter(Mandatory=$True, ParameterSetName="Import", Position=0)]
        [Parameter(Mandatory=$False, ParameterSetName="List", Position=0)]
        [Parameter(Mandatory=$True, ParameterSetName="Export", Position=0)]
        [Parameter(Mandatory=$True, ParameterSetName="Add", Position=0)]
        [string] $Path,

        # Force
        [Parameter(Mandatory=$False, ParameterSetName="Init", Position=0)]
        [switch] $Force,

        # ID
        [Parameter(Mandatory=$True, ParameterSetName="Remove", Position=0)]
        [string] $Id
    )

    # Remove Switch for ParmameterSetName
    $PSBoundParameters.Remove($PsCmdlet.ParameterSetName) | Out-Null

    Write-Verbose ($LocalizedData.SplatFunctionWith -f $PsCmdlet.ParameterSetName, ($PSBoundParameters | Out-String ))

    # Call Functon with Bound Parms
    . $PsCmdlet.ParameterSetName @PSBoundParameters
}