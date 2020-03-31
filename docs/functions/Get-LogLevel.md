# Get-LogLevel
Returns the current log level for the module.

```powershell
Get-LogLevel
    [<CommonParameters>]
```

## Description
The `Get-LogLevel` function returns the current log level of the module. This is stored in a script variable to prevent tampering mid-execution, so this function is the only method by which the variable can be safely retrieved outside the module scope.

## Examples

### Example1 1: Return the current log level

```powershell
Get-LogLevel
```

```Output
Information
```

The current log level is displayed as a string.

## Parameters

None

## Inputs

None

## Outputs

### System.String

`Get-LogLevel` returns a string representation of the current log level.