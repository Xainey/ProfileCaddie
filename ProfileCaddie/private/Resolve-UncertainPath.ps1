<#
.Synopsis
    Resolve and return a full path even if any of the leaves or branches are missing.

.Notes
    Could use: $PSCmdlet.GetUnresolvedProviderPathFromPSPath()
#>
function Resolve-UncertainPath {
    [cmdletbinding()]
    param (
        [string] $Path
    )

    $ResolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue -ErrorVariable RPError

    if (!$ResolvedPath)
    {
        $ResolvedPath = $RPError[0].TargetObject
    }

    return $ResolvedPath
}