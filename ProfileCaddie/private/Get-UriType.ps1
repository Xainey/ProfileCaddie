function Get-UriType {
    [cmdletbinding()]
    param (
        [string] $Uri
    )

    if ([uri]::IsWellFormedUriString($Uri, "Absolute")) {
        if (Get-Gist -Uri $Uri -isValid) {
            return [UriType]::Gist
        }
        return [UriType]::URI
    }
    elseif ([bool]([uri]$Path).IsUnc) {
        return [UriType]::UNC
    }

    elseif (Test-Path -Path $Path -IsValid) {
        return [UriType]::File
    }

    return [UriType]::Unknown
}