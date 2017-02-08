function Force-ResolvePath
{
    [cmdletbinding()]
    param(
        [string] $Path
    )

    $ResolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue -ErrorVariable RPError

    if(!$ResolvedPath)
    {
        $ResolvedPath = $RPError[0].TargetObject
    }

    return $ResolvedPath
}