$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path
Import-Module $pester.ManifestPath -Force
Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Basic Export" {
            It "Copies the gist.json file to target path" {
                Mock Resolve-UncertainPath { return "TestDrive:/.pscaddie" } -ParameterFilter { $Path -eq "~/.pscaddie" }
                Mock Copy-Item {} -Verifiable
                Init
                (Get-Command Init) | Out-Host
                Export -Path "./gists.json"
                Assert-VerifiableMocks
            }
        }
    }
}