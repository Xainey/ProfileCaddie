$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path
(Get-Command -Module ProfileCaddie) | Out-Host
Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Basic Export" {
            It "Copies the gist.json file to target path" {
                Mock Resolve-UncertainPath { return "TestDrive:/.pscaddie" } -ParameterFilter { $Path -eq "~/.pscaddie" }
                Mock Copy-Item {} -Verifiable
                (Get-Command -Module ProfileCaddie Init) | Out-Host
                (Get-Help Init) | Out-Host
                { Init } | Should Not Throw
                Init -Force
                Export -Path "./gists.json"
                Assert-VerifiableMocks
            }
        }
    }
}