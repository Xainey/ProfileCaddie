<#
.Synopsis
    Generate a new ProfileCaddie Profile.ps1 and inject it into $Profile.
#>
function Make
{
    # Collect all Raw gists and make file
    $Output = $null
    foreach($item in List)
    {
        $uri = "https://gist.githubusercontent.com/{0}/{1}/raw/{2}/{3}" -f $item.user, $item.id, $item.sha, $item.file
        $Output += "# Source: $uri`n"
        $Output += (Invoke-WebRequest $uri).Content
        $Output += "`n`n"
    }
    $psCaddie = Resolve-UncertainPath "~/.pscaddie"
    $makeProfile = Join-Path $psCaddie "Profile.ps1"
    $Output | Out-File -FilePath $makeProfile -Force

    # Insert Marker into profile to dot source "~/.pscaddie/Profile.ps1"
    $marker = "# Load ProfileCaddie Generated Profile (Do Not Modify)"
    $profilePath = (Get-ProfilePath -Name CurrentUserCurrentHost)
    if((Select-String -Path $profilePath -Pattern $marker).count -eq 0)
    {
        $userProfile = $marker
        $userProfile += "`n"
        $userProfile += '$ProfileCaddie = "~/.pscaddie/profile.ps1"; if(Test-Path(Resolve-Path $ProfileCaddie -ErrorAction SilentlyContinue)){. $ProfileCaddie}'
        $userProfile += "`n`n"
        $userProfile += (Get-Content $profilePath | Out-String)
        $userProfile | Out-File -FilePath $profilePath -Force
    }
}