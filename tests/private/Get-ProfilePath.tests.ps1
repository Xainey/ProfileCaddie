$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Returns a list or string" {
            It "Returns a string if profile is requested by name" {
                (Get-ProfilePath -Name AllUsersAllHosts) | Should BeOfType String
                (Get-ProfilePath -Name AllUsersCurrentHost) | Should BeOfType String
                (Get-ProfilePath -Name CurrentUserAllHosts) | Should BeOfType String
                (Get-ProfilePath -Name CurrentUserCurrentHost) | Should BeOfType String
            }
            It "Returns a PSCustomObject List of all Profiles if `$Name is not included" {
                (Get-ProfilePath) | Should BeOfType PSCustomObject
            }
        }
    }
}