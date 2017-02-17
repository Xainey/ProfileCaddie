$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        Context "Get-UriType" {
            It "Gets Gists" {
                $gist = 'https://gist.githubusercontent.com/Xainey/f1b58368b25645b347f92ebc7416a472/raw/6df35a83c80a2f2829bc7a3f745ae19e87152322/CustomThrow.ps1'
                (Get-UriType -Uri $gist) | Should Be ([UriType]::Gist)
            }
            It "Gets File" {
                $files = @(
                    'c:\ProgramFiles\test.txt'
                    'c:\ProgramFiles\test.ps1'
                    'c:\ProgramFiles\test.json'
                    'c:\folder\myfile.txt'
                    'c:\folder\myfileWithoutExtension'
                    '.\something\test.ps1'
                    './something/test.ps1'
                    'something'
                )
                foreach ($file in $files)
                {
                    Get-UriType -Uri $file | Should be ([UriType]::File)
                }
            }
            It "Gets UNC" {
                $uncs = @(
                    '\\test\test$\TEST.xls'
                    '\\server\share\folder\myfile.txt'
                    '\\server\share\myfile.txt'
                    '\\123.123.123.123\share\folder\myfile.txt'
                )
                foreach ($unc in $uncs)
                {
                    Get-UriType -Uri $unc | Should be ([UriType]::UNC)
                }
            }
            It "Gets URI" {
                $uris = @(
                    "https://github.com"
                    "http://github.com"
                )
                foreach ($unc in $uncs)
                {
                    Get-UriType -Uri $unc | Should be ([UriType]::URI)
                }
            }
            It "Gets Unknown" {
                $uris = @(
                    "ftp.github.com"
                    "*somefile"
                    "`"somefile"
                )
                foreach ($unc in $uncs)
                {
                    Get-UriType -Uri $unc | Should be ([UriType]::Unknown)
                }
            }
        }
    }
}
