$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

#since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddie'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddie\ProfileCaddie.psm1") -Force

InModuleScope "ProfileCaddie" {
    Describe "Public/Invoke-ProfileCaddie" {
        Mock Resolve-UncertainPath { return "TestDrive:/.pscaddie" } -ParameterFilter { "~/.pscaddie" }
        $gist1 = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
        Context "Help" {
            It "Gets the docs" {
                { Invoke-ProfileCaddie -Help } | Should Not Throw
            }
            It "Adds gists" {
                { Invoke-ProfileCaddie -Add $gist1 } | Should Not Throw
            }
            It "Exports gists.json" {
                ( Invoke-ProfileCaddie -Export "TestDrive:/exported.json" ) | Should Be $LocalMessage.ProfileDirectoryNotFound

                mkdir "TestDrive:\.pscaddie"
                ( Invoke-ProfileCaddie -Export "TestDrive:/exported.json" ) | Should Be $LocalMessage.GistJsonNotFound

                Invoke-ProfileCaddie -Init
                Invoke-ProfileCaddie -Export "TestDrive:\.pscaddie\exported.json"
                "TestDrive:\.pscaddie\exported.json" | Should Exist
            }
            # It "..." {
            #     { Invoke-ProfileCaddie -Import } | Should Not Throw
            # }
            # It "..." {
            #     { Invoke-ProfileCaddie -Init } | Should Not Throw
            # }
            # It "..." {
            #     { Invoke-ProfileCaddie -List } | Should Not Throw
            # }
            # It "..." {
            #     { Invoke-ProfileCaddie -Make } | Should Not Throw
            # }
            # It "..." {
            #     { Invoke-ProfileCaddie -Remove } | Should Not Throw
            # }
        }
    }
}