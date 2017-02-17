<#
.Synopsis
    Get the Help.
#>
function Help() {

"
 ______             ___ _ _        _______           _     _ _
(_____ \           / __|_) |      (_______)         | |   | (_)
 _____) )___ ___ _| |__ _| | _____ _       _____  __| | __| |_ _____
|  ____/ ___) _ (_   __) | || ___ | |     (____ |/ _  |/ _  | | ___ |
| |   | |  | |_| || |  | | || ____| |_____/ ___ ( (_| ( (_| | | ____|
|_|   |_|   \___/ |_|  |_|\_)_____)\______)_____|\____|\____|_|_____)
"
    Get-Help about_ProfileCaddie

    $cliCommands = @( Get-ChildItem -Path $PSScriptRoot/*.ps1 -ErrorAction SilentlyContinue )

    $cli = @()
    foreach ($flag in $cliCommands) {
        $name = (Get-ChildItem $flag).BaseName
        $cli += [PSCustomObject]@{
            "Command" = $name
            "Synopsis" = (Get-Help $name).Synopsis
        }
    }

    $cli | Format-Table -AutoSize
}