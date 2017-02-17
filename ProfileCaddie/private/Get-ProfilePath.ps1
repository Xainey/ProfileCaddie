<#
.Example
Get-ProfilePath
Get-ProfilePath -Name CurrentUserCurrentHost

.Notes
https://blogs.technet.microsoft.com/heyscriptingguy/2012/05/21/understanding-the-six-powershell-profiles/
#>
function Get-ProfilePath {
    [cmdletbinding()]
    param (
        [ValidateSet("AllUsersAllHosts", "AllUsersCurrentHost", "CurrentUserAllHosts", "CurrentUserCurrentHost")]
        [string] $Name
    )

    if ($Name -eq $null -or $Name -eq "") {
        return $global:profile | Select-Object AllUsersAllHosts, AllUsersCurrentHost, CurrentUserAllHosts, CurrentUserCurrentHost
    }

    return $global:profile."$Name"
}