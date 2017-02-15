function Get-UriType
{
    [cmdletbinding()]
    param(
        [string] $Uri,
        [switch] $Verify
    )

    # May want to restrict to only .ps1 Files
    $gist = [regex] 'https:\/\/gist.githubusercontent.com\/(\w+)\/([a-f0-9]+)\/raw\/([a-f0-9]{40})\/([^/\n]*)$'

    if ([uri]::IsWellFormedUriString($Uri, "Absolute"))
    {
        if ($gist.IsMatch($Uri))
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