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
    $psCaddy = Force-ResolvePath "~/.pscaddy"
    $makeProfile = Join-Path $psCaddy "Profile.ps1"
    $Output | Out-File -FilePath $makeProfile -Force

    # Insert Marker into profile to dot source "~/.pscaddy/Profile.ps1"
    $marker = "# Load ProfileCaddy Generated Profile (Do Not Modify)"
    $profilePath = (Get-ProfilePath -Name CurrentUserCurrentHost)
    if((Select-String -Path $profilePath -Pattern $marker).count -eq 0)
    {
        $userProfile = $marker
        $userProfile += "`n"
        $userProfile += '$ProfileCaddy = "~/.pscaddy/profile.ps1"; if(Test-Path(Resolve-Path $ProfileCaddy -ErrorAction SilentlyContinue)){. $ProfileCaddy}'
        $userProfile += "`n`n"
        $userProfile += (Get-Content $profilePath | Out-String)
        $userProfile | Out-File -FilePath $profilePath -Force
    }
}