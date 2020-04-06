path: tree/master/PsLogLite/Public
source: Get-LogPath.ps1

# Get-LogPath
Returns the current log file path for the module.

```powershell
Get-LogPath
    [<CommonParameters>]
```

## Description
The `#!powershell Get-LogPath` function returns the current log file path of the module. This is stored in a script variable to prevent tampering mid-execution, so this function is the only method by which the variable can be safely retrieved outside the module scope.

## Examples

### Example 1: Return the current log file path

```powershell
Get-LogPath
```
Output:
```text
C:\Users\username\AppData\Local\Temp\PsLogLite.module.log
```

The current log file path is displayed as a string.

## Parameters

None

## Inputs

None

## Outputs

__System.String__

`#!powershell Get-LogPath` returns a string representation of the current log file path.

## Notes

* `#!powershell Get-LogPath` can be run using the built-in alias `#!powershell Get-LogFile`.

## Related Links

[Reset-LogPath](./Reset-LogPath.md)

[Set-LogPath](./Set-LogPath.md)