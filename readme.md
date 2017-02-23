# ProfileCaddie

[![CodeStyle](https://img.shields.io/badge/code%20style-OTBS-brightgreen.svg?style=flat)](https://github.com/PoshCode/PowerShellPracticeAndStyle)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Xainey/ProfileCaddie/blob/master/LICENSE)

Simple tool to help manage and share useful snippits, functions, and aliases for `$Profile`.

Note: Currently only supports Github Gists.

**WARNING**:

- Opening this up early to get ideas, feedback, and advice.

## Native Help

```powershell
Get-Help about_profilecaddie
Get-Help ProfileCaddie
Get-Command -Module ProfileCaddie
Get-Help Invoke-ProfileCaddie
```

## CLI Reference

The following commands use `Invoke-Caddie` or the alias `caddie`.

**-Help** : Shows Custom Help

```powershell
Invoke-Caddie -Help
```

**-Init** : Scaffold Files

```powershell
# Create ~/.pscaddie/
Invoke-Caddie -Init

# Clean and Init ~/.pscaddie/*
Invoke-Caddie -Init -Force
```

**-Add** : Add a raw Gist URL

```powershell
Invoke-Caddie -Add "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
```

**-Remove** : Remove a gist by ID

```powershell
Invoke-Caddie -Remove "bc4e497435b440f6699a4f778c89a0c5"

# If ID is not specific enough, use sha and/or file.
Invoke-Caddie -Remove "bc4e497435b440f6699a4f778c89a0c5" -Sha "cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68" -File "touch.ps1"
```

**-Make** : Builds `Profile.ps1` from `Custom.ps1` and `Gists.json` / Inserts marker in `$Profile`

```powershell
Invoke-Caddie -Make
```

**-Import** : Imports a list of ProfileCaddie gists from a JSON formatted gist.

```powershell
Invoke-Caddie -Import "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/pscaddie.json"
```

**-Export** : Exports (Copies) ~/.pscaddie/gists.json to specified location.

```powershell
Invoke-Caddie -Export "C:\Temp\CopyOfGists.ps1"
```

**-List** : Lists all of the gists in your ~/.pscaddie/gists.json

```powershell
Invoke-Caddie -List
```

## File Structure

```
~/.pscaddie/
    ├── Custom.ps1
    ├── Gists.json
    └── Profile.ps1
```

## Notes

`-Make` fetches all of the raw content listed in `gists.json` and combines it with `custom.ps1` to generate `~/.pscaddie/Profile.ps1`

The `Profile.ps1` output file is then loaded in your profile script:
```
# Load Profile Caddie Generated Profile
# $PScaddie = "~/.pscaddie/profile.ps1"; if(Test-Path(Resolve-Path $PScaddie -ErrorAction SilentlyContinue)){. $PScaddie}
```