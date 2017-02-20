$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Test-Uri" {
            It "Tests Gist URIs" {
                Mock Invoke-WebRequest { return @{statuscode = 200} } -Verifiable
                (Test-Uri -Uri "gisturl" -Type ([UriType]::Gist)) | Should Be $true
                Assert-VerifiableMocks
            }
        }
    }
}