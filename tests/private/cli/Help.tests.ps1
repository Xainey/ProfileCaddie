$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Help" {
            It "Gets the Help Docs" {
                { Help } | Should Not Throw
            }
        }
    }
}