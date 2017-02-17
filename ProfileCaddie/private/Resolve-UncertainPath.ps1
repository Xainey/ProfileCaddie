<#
.Synopsis
    Resolve and return a full path even if any of the leaves or branches are missing.

.Notes
    Could use: $PSCmdlet.GetUnresolvedProviderPathFromPSPath()
#>
function Resolve-UncertainPath {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Path
    )

    $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue -ErrorVariable rpError

    if (!$resolvedPath)
    {
        $resolvedPath = $rpError[0].TargetObject
    }

    return $resolvedPath
}