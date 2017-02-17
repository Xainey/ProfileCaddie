function Verify-URI {
    [cmdletbinding()]
    param (
        [string] $Uri,
        [string] $Type
    )

    $AllowedUris = @("URI", "Gist")

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

    elseif ($Type -eq "UNC") {
        $server = ([uri] $Uri).Host
        $status = (Test-Connection -ComputerName $server -ErrorAction SilentlyContinue -Count 1).StatusCode

        if ($status -ne 0) {
            return $false
        }

        if (Test-Path -Path $Uri) {
           return $true
        }
    }

    elseif ($Type -eq "File") {
        if (Test-Path -Path $Uri) {
           return $true
        }
    }

    return $false
}