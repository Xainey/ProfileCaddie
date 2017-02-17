function Get-UriType
{
    [cmdletbinding()]
    param(
        [string] $Uri
    )

    if ([uri]::IsWellFormedUriString($Uri, "Absolute"))
    {
        if (ParseGist -Uri $Uri -Test)
        {
            return "Gist"
        }

        return "URI"
    }

    elseif([bool]([uri]$Path).IsUnc)
    {
        return "UNC"
    }

    elseif(Test-Path -Path $Path -IsValid)
    {
        return "File"
    }

    return "Unknown"
}