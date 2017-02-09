<#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER Ask

    .PARAMETER Help

    .EXAMPLE

    .NOTES
#>
function Invoke-ProfileCaddy
{
    [cmdletbinding(DefaultParameterSetName="Help")]
    param(
        #Help
        [Parameter(Mandatory=$False, ParameterSetName="Help")]
        [switch] $Help,

        # Ask
        [Parameter(Mandatory=$True, ParameterSetName="Ask")]
        [switch] $Ask,
        [string] $Format,
        [Parameter(Mandatory=$True, ParameterSetName="Ask", Position=0)]
        [string] $Question
    )

    # Remove Switch for ParmameterSetName
    $PSBoundParameters.Remove($PsCmdlet.ParameterSetName) | Out-Null

    # Call Functon with Bound Parms
    . $PsCmdlet.ParameterSetName @PSBoundParameters
}