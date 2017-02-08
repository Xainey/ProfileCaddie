function Make
{
    $Output = $null
    foreach($item in List)
    {
        $uri = "https://gist.githubusercontent.com/{0}/{1}/raw/{2}/{3}" -f $item.user, $item.id, $item.sha, $item.file
        $Output += "# Source: $uri`n"
        $Output += (Invoke-WebRequest $uri).Content
        $Output += "`n`n"
    }

    $makeProfile = Force-ResolvePath "~/.pscaddy/Profile.ps1"
    $Output | Out-File -FilePath $makeProfile -Force

    $marker = "# Load ProfileCaddy Generated Profile (Do Not Modify)"

    if((Select-String -Path $profile -Pattern $marker).count -eq 0)
    {
        $userProfile = $marker
        $userProfile += "`n"
        $userProfile += '$ProfileCaddy = "~/.pscaddy/profile.ps1"; if(Test-Path(Resolve-Path $ProfileCaddy -ErrorAction SilentlyContinue)){. $ProfileCaddy}'
        $userProfile += "`n`n"
        $userProfile += (Get-Content $profile | Out-String)
        $userProfile | Out-File -FilePath $profile -Force
    }
}