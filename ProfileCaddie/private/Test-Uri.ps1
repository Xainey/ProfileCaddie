function Test-Uri {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string] $Uri,
        [Parameter(Mandatory=$True, Position=1)]
        [string] $Type
    )

    $AllowedUris = @([UriType]::URI, [UriType]::Gist)

    if ($Type -in $AllowedUris) {
        $parms = @{
            UseBasicParsing = $True
            DisableKeepAlive = $True
            Uri = $Uri
            Method = 'Head'
            ErrorAction = 'stop'
            TimeoutSec = 1
        }

        if ((Invoke-WebRequest @parms).statuscode -eq 200) {
            return $true
        }
    }

    elseif ($Type -eq [UriType]::UNC) {
        $server = ([uri] $Uri).Host
        $status = (Test-Connection -ComputerName $server -ErrorAction SilentlyContinue -Count 1).StatusCode

        if ($status -ne 0) {
            return $false
        }

        if (Test-Path -Path $Uri) {
           return $true
        }
    }

    elseif ($Type -eq [UriType]::File) {
        if (Test-Path -Path $Uri) {
           return $true
        }
    }

    return $false
}