$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Non-Existant Path" {
            It "It does not thow if the path does not exist" {
                { Resolve-UncertainPath "~/.example/does/not/exist.ps1" } | Should Not Throw
            }
        }
    }
}