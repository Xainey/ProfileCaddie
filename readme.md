# PSCaddy

Simple tool to help manage and share useful snippits, functions, and aliases for `$Profile`

# CLI Reference

- Init
- Add
- Make
- Import
- Export

# File Structure

```
.pscaddy /
|
|- Custom.ps1
|- Gist.ps1
|- Profile.ps1

```

# Notes

```
    # Load PSCaddy Generated Profile
    # $PScaddy = "~/.pscaddy/profile.ps1"; if(Test-Path(Resolve-Path $PScaddy -ErrorAction SilentlyContinue)){. $PScaddy}
```