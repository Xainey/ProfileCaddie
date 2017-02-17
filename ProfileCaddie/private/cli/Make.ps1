<#
.Synopsis
    Generate a new ProfileCaddie Profile.ps1 and inject it into $Profile.
#>
function Make
{
    $psCaddie = Resolve-UncertainPath "~/.pscaddie"
    $private = Join-Path $psCaddie "Private.ps1"
    $makeProfile = Join-Path $psCaddie "Profile.ps1"

    # Copy Contents of .Private.psd1
    $Output = (Get-Content -Path $private) + "`n"

    # Collect all Raw gists and make file
    foreach($item in List)
    {
        $uri = Get-Gist -user $item.user -id $item.id -sha $item.sha -file $item.file
        $Output += "# Source: $uri`n"
        $Output += (Invoke-WebRequest $uri).Content
        $Output += "`n`n"
    }
    $Output | Out-File -FilePath $makeProfile -Force

    # Insert Marker into profile to dot source "~/.pscaddie/Profile.ps1"
    $marker = "# Load ProfileCaddie Generated Profile (Do Not Modify)"
    $profilePath = (Get-ProfilePath -Name CurrentUserCurrentHost)
    if((Select-String -Path $profilePath -SimpleMatch $marker).count -eq 0)
    {
        $userProfile = $marker
        $userProfile += "`n"
        $userProfile += '$ProfileCaddie = "~/.pscaddie/profile.ps1"; if(Test-Path $ProfileCaddie -ErrorAction SilentlyContinue){. $ProfileCaddie}else{"ProfileCaddie Config Missing"}'
        $userProfile += "`n`n"
        $userProfile += (Get-Content $profilePath | Out-String)
        $userProfile | Out-File -FilePath $profilePath -Force
    }
}