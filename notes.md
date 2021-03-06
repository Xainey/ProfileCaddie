# Design Notes

## Project Structure

```dart
ProfileCaddie/                                  <--- "Repo Root"
├── ProfileCaddie/                              <--- "Module Root"
│   ├── en-US/                                  <--- "English Local"
│   │   ├── ProfileCaddie.strings.psd1          <--- "String Localization"
│   │   └── about_ProfileCaddie.help.txt        <--- "Help Document"
│   ├── Private/                                <--- "Functions / Not Exposed"
│   │   └── cli/                                <--- "Functions / Exposed Through Invoke- Router"
│   ├── Public/                                 <--- "Functions / Exposed"
│   │   └── Invoke-ProfileCaddie.ps1            <--- "Router for CLI commands"
│   ├── ProfileCaddie.psd1                      <--- "Manifest"
│   └── ProfileCaddie.psm1                      <--- "Root Module"
├── tests/                                      <--- "Tests Match Source Structure"
│   ├── Private/
│   │   └── cli/
│   └── Public/
├── appveyor.yml                                <--- "CI Runner"
├── build.utils.ps1                             <--- "Extra Functions Not in BuildHelpers"
├── ProfileCaddie.build.ps1                     <--- "Invoke-Build Core Tasks"
├── ProfileCaddie.deploy.ps1                    <--- "PSDeploy Script for PSGallery"
├── ProfileCaddie.pester.ps1                    <--- "Protoype Pester Helper"
└── ProfileCaddie.settings.ps1                  <--- "Settings/Hooks for Invoke-Build"
```

## TODO: Update to use Noun-Verbs instead of router function

Help:    Get-Help ProfileCaddie
List:    Get-CaddieGist
Add:     Add-CaddieGist
Remove:  Remove-CaddieGist
Export:  Export-Caddie
Import:  Import-Caddie
Make:    Set-Caddie / Install-Caddie / Write-Caddie
Init:    Initialize-Caddie / New-Caddie

## Tests/Source should have matching file structures

- https://xainey.github.io/2017/powershell-module-pipeline/#example-3-strict-pattern

## Pester Helper: `ProfileCaddie.pester.ps1`

1. Run `Invoke-Pester` from project root.
2. Use common test format in all tests.

```powershell
$pester = & (Resolve-Path ".\ProfileCaddie.Pester.ps1") $MyInvocation.MyCommand.Path

Describe $pester.Namespace {
    InModuleScope $pester.ModuleName {
        # Add Context / Describe Blocks Here
    }
}
```

3. `$pester` will be populated with paths like so:

```
TestFile            : C:\Users\Mike\Github\ProfileCaddie\tests\private\cli\Export.tests.ps1
TestFileName        : Export.tests.ps1
TestDirectory       : C:\Users\Mike\Github\ProfileCaddie\tests\private\cli
ModuleRootDirectory : C:\Users\Mike\Github\ProfileCaddie
ModuleName          : ProfileCaddie
SourceFile          : C:\Users\Mike\Github\ProfileCaddie\ProfileCaddie\private\cli\Export.ps1
SourceFileName      : Export.ps1
SourceDirectory     : C:\Users\Mike\Github\ProfileCaddie\ProfileCaddie\private\cli
PathFromModuleRoot  : private\cli
Namespace           : private\cli\Export.ps1
```

4. `ProfileCaddie.Pester.ps1` will Import the module and dot source the source file that goes with the test.

## Router / CLI Commands

- https://xainey.github.io/2017/powershell-module-pipeline/#single-point-of-access

`Invoke-ProfileCaddie.ps1` is the only public exposed function, it is used to route all of the commands.

Each function under `/private/cli/` function is given matching a matching `Switch` and `ParameteSetName`.
The function is dot sourced and the psboundparameters are splat to make the call.

```powershell
# Remove Switch for ParmameterSetName
$PSBoundParameters.Remove($PsCmdlet.ParameterSetName) | Out-Null

# Call Functon with Bound Parms
& $PsCmdlet.ParameterSetName @PSBoundParameters
```

Could use only switches on Invoke-ProfileCaddie and pipe the remaining arguments positionally using `ValueFromRemainingArguments`
or possibly using `DynamicParam`.

## Custom Error Handling

Concept Based on Pester's `Set-TestInconclusive.ps1`.

- https://gist.github.com/Xainey/f1b58368b25645b347f92ebc7416a472
- https://github.com/PoshCode/Configuration/blob/master/Source/Metadata.psm1#L955
- https://msdn.microsoft.com/en-us/library/system.management.automation.errorcategory(v=vs.85).aspx

## Custom Help

`Help1.ps1` loads:

- A custom Ascii header for fun.
- `Get-Help about_ProfileCaddie.help.text`
- Custom comment based help

Each function under `/private/cli/` has comment based help for `Synopsis`.

```powershell
<#
.Synopsis
    Add a Raw Gist url to ProfileCaddie.
#>
```

Using these lets me make a minimal list of commands.

## Localization

- `\en-US\about_ProfileCaddie.help.txt` added for English help.
- `\en-US\about_ProfileCaddie.help.txt` added for English strings throughout the module.
    - `ProfileCaddie.psm1` Imports these strings and binds them to `$LocalizedData`

## CI/CD Pipeline

### Invoke-Build Tasks

- InstallDependencies
- Init
    - Setup tasks
- Clean
    - Clean old artifacts
    - Make artifacts folder
    - Get PSTestReport with git
- Analyze
    - Run scriptAnalyzer
    - Output results to json
- Test
    - Run pester
    - save reults to nunit and json
    - generate PSTestReport report
- Archive
    - Create Zip Archive
    - Create Nuget Package
- Publish
    - Publish using PSDeploy if `!deploy` is in commit message.

### AppVeyor

- Install Nuget
- Install Invoke-Build
- Run `Invoke-Build -Task InstallDependencies`
- Run `Invoke-Build .` Pipeline
- Publish nunit Test Results to AppVeyor
- Publish all artifacts
- `Invoke-Build -Task Publish`  to deploy