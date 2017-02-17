Import-LocalizedData -FileName ProfileCaddie.Resources.psd1 -BindingVariable "LocalizedData" -ErrorAction SilentlyContinue

$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

foreach ($import in @($Public + $Private)) {
    try {
        . $import.fullname
    } catch {
        Write-Error -Message ($LocalizedData.FailedToImport -f "$($import.fullname): $_")
    }
}

Export-ModuleMember -Function $Public.Basename

# Try using custom types or enums if supporting only v5
Add-Type -TypeDefinition @"
    public enum UriType
    {
        Gist,
        URI,
        UNC,
        File,
        Unknown
    }
"@