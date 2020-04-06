# Set-LogLevel
Set the log level to a specific value.

```powershell
Set-LogLevel
    [-Level] <String>
    [-Silent]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## Description
The `#!powershell Set-LogLevel` function sets the log level to the specified value. Unless `#!powershell -Silent` is specified, it also logs the change to the log file as a META entry.

## Examples

### Example 1: Reset the log level to the default setting

```powershell
Set-LogLevel -Level Error
```

Sets the log level to log all messages of level Error or higher. No output is returned. A message is recorded in both log files regarding the change.

### Example 2: Reset the log level to the default setting, suppressing additional messages to the log files

```powershell
Set-LogLevel -Level Debug -Silent
```

Sets the log level to log all messages of level Debug or higher. No output is returned, and no log will be generated indicating a change.

## Parameters

__`#!powershell -Confirm`__

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Required: False
Aliases: cf
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

__`#!powershell -Level`__

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

__`#!powershell -Silent`__

Suppresses a log of the reset to the log file.

```yaml
Type: SwitchParameter
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

__`#!powershell -WhatIf`__

Shows what would happen if the function runs. The function is not run.

```yaml
Type: SwitchParameter
Aliases: wi
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## Inputs

__System.String__

A string representing the log level to set.

## Outputs

None

## Related Links

[Get-LogLevel](./Get-LogLevel.md)

[Reset-LogLevel](./Reset-LogLevel.md)