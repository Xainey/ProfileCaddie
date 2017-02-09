$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# Since we match the srs/tests organization this works
$here = $here -replace 'tests', 'ProfileCaddy'

. "$here\$sut"

# Import our module to use InModuleScope
Import-Module (Resolve-Path ".\ProfileCaddy\ProfileCaddy.psm1") -Force

InModuleScope "ProfileCaddy" {
    Describe "Private/ParseGist" {

        $goodGists = @{
            "Export.ps1"  =  "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            "Touch.ps1"   =  "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
        }

        $badGists = @{
            "BadDomain" = "https://giadsda/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            "HttpDomain" = "http://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            "BadQuery1" = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/raw/ro/ma/ma/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1"
            "BadQuery2" = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/Thisshouldntbehere/export.ps1"
            "BadQuery3" = "https://gist.githubusercontent.com/Xainey/a8793a62dcb6d613bf0482ee6deec36f/raw/f965f317fe4c13cc7224484d7494e7e1c9334b38/export.ps1/northis"
        }

        Context "Validate Gist URI" {
            It "Should parse a raw gist URI" {
                foreach($goodGist in $goodGists.GetEnumerator())
                {
                    { ParseGist -Uri $goodGist.Value } | Should Not Throw
                }
            }
            It "Should throw an error if URI is malformed" {
                foreach($badGist in $badGists.GetEnumerator())
                {
                    { ParseGist -Uri $badGist.Value } | Should Throw
                }
            }
        }
    }
}