$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Get-GistUri" {
            It "returns a url given the user, id, sha, and file" {
                $gist = @{
                    user = "Xainey"
                    id = "8127ac4840b781f090c162dd97207626"
                    sha = "5e0172fdf6768f2660b9ad779c7d8c2d73fa5666"
                    file = "gists.json"
                }

                ( Get-GistUri @gist ) | Should Be "https://gist.githubusercontent.com/Xainey/8127ac4840b781f090c162dd97207626/raw/5e0172fdf6768f2660b9ad779c7d8c2d73fa5666/gists.json"
            }
        }
    }
}