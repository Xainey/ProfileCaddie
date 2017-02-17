# ProfileCaddie

[![CodeStyle](https://img.shields.io/badge/code%20style-OTBS-brightgreen.svg?style=flat)](https://github.com/PoshCode/PowerShellPracticeAndStyle)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Xainey/ProfileCaddie/blob/master/LICENSE)

Simple tool to help manage and share useful snippits, functions, and aliases for `$Profile`

# CLI Reference

`-Help` : Shows Help Docs

```powershell
Invoke-Caddie -Help
```

`-Init` : Scaffold Files in ~/.pscaddie/

```powershell
Invoke-Caddie -Init
Invoke-Caddie -Init -Force # Clean and Init ~/.pscaddie/*
```

`-Add` : Add a raw gist url

```powershell
Invoke-Caddie -Add "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
```

`-Remove` : Remove a gist by ID

```powershell
Invoke-Caddie -Remove "bc4e497435b440f6699a4f778c89a0c5"
```

`-Make` : Build Profile from Custom.ps1 and Gists.json / Inserts marker in $Profile

```powershell
Invoke-Caddie -Make
```

`-Import` : Imports all pscaddie gists from a gist (whoa)

```powershell
Invoke-Caddie -Import "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/pscaddie.json"
```

`-Export` : Undecided

```powershell
# Hmmm
```

`-List` : Lists all of the gists in your ~/.pscaddie/gists.json

```powershell
Invoke-Caddie -List
```

# File Structure

```
.pscaddie /
    |
    |- Custom.ps1
    |- Gists.json
    |- Profile.ps1

```

# Notes

```
    # Load Profile Caddie Generated Profile
    # $PScaddie = "~/.pscaddie/profile.ps1"; if (Test-Path(Resolve-Path $PScaddie -ErrorAction SilentlyContinue)){. $PScaddie}

    https://developer.github.com/v3/gists/
    Allow multiple?
    Gists are grouped by ID, where each individual file can be pulled from the api.
    To specifically reference an individual file use id:/sha:.
```