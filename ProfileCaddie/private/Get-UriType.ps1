function Get-UriType {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Uri
    )

    if ([uri]::IsWellFormedUriString($Uri, "Absolute")) {
        if (Get-Gist -Uri $Uri -isValid) {
            return [UriType]::Gist
        }
        return [UriType]::URI
    }
    elseif ([bool]([uri]$Uri).IsUnc) {
        return [UriType]::UNC
    }

    elseif (Test-Path -Path $Uri -IsValid) {
        return [UriType]::File
    }

    return [UriType]::Unknown
}