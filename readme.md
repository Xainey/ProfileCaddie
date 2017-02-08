# PSCaddy

Simple tool to help manage and share useful snippits, functions, and aliases for `$Profile`

# CLI Reference

`-Help` : Shows Help Docs

```powershell
Invoke-Caddy -Help
```

`-Init` : Scaffold Files in ~/.pscaddy/

```powershell
Invoke-Caddy -Init
Invoke-Caddy -Init -Force # Clean and Init ~/.pscaddy/*
```

`-Add` : Add a raw gist url

```powershell
Invoke-Caddy -Add "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/touch.ps1"
```

`-Remove` : Remove a gist by ID

```powershell
Invoke-Caddy -Remove "bc4e497435b440f6699a4f778c89a0c5"
```

`-Make` : Build Profile from Custom.ps1 and Gists.json / Inserts marker in $Profile

```powershell
Invoke-Caddy -Make
```

`-Import` : Imports all pscaddy gists from a gist (whoa)

```powershell
Invoke-Caddy -Import "https://gist.githubusercontent.com/Xainey/bc4e497435b440f6699a4f778c89a0c5/raw/cfbd2f458bbec19ba62e7b721bb0cf092e5f9a68/pscaddy.json"
```

`-Export` : Undecided

```powershell
# Hmmm
```

`-List` : Lists all of the gists in your ~/.pscaddy/gists.json

```powershell
Invoke-Caddy -List
```

# File Structure

```
.pscaddy /
    |
    |- Custom.ps1
    |- Gists.json
    |- Profile.ps1

```

# Notes

```
    # Load Profile Caddy Generated Profile
    # $PScaddy = "~/.pscaddy/profile.ps1"; if(Test-Path(Resolve-Path $PScaddy -ErrorAction SilentlyContinue)){. $PScaddy}

    Allow multiple?
    Gists are grouped by ID, where each individual file can be pulled from the api.
    To specifically reference an individual file use id:/sha:.
```