# Get-LogPath
Returns the current log file path for the module.

```powershell
Get-LogPath
    [<CommonParameters>]
```

## Description
The `Get-LogPath` function returns the current log file path of the module. This is stored in a script variable to prevent tampering mid-execution, so this function is the only method by which the variable can be safely retrieved outside the module scope.

## Examples

### Example1 1: Return the current log file path

```powershell
Get-LogPath
```

```Output
C:\Users\username\AppData\Local\Temp\PsLogLite.module.log
```

The current log file path is displayed as a string.

## Parameters

None

## Inputs

None

## Outputs

### System.String

`Get-LogPath` returns a string representation of the current log file path.

## Notes

* `Get-LogPath` can be run using the built-in alias `Get-LogFile`.