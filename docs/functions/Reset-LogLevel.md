path: tree/master/PsLogLite/Public
source: Reset-LogLevel.ps1

# Reset-LogLevel
Returns the current log level for the module.

```powershell
Reset-LogLevel
    [-Silent]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## Description
The `#!powershell Reset-LogLevel` function resets the log level to the default setting, which is `#!powershell Output`. Unless `#!powershell -Silent` is specified, it also logs the reset to the log file as a META entry.

## Examples

### Example 1: Reset the log level to the default setting

```powershell
Reset-LogLevel
```

The current log level is reset. No output is returned. A message is recorded in both log files regarding the change.

### Example 2: Reset the log level to the default setting, suppressing additional messages to the log files

```powershell
Reset-LogLevel -Silent
```

The current log level is reset. No output is returned, and no log will be generated indicating a change.

## Parameters

__`#!powershell -Confirm`__

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

__`#!powershell -Silent`__

Suppresses a log of the reset to the log file.

```yaml
Type: SwitchParameter
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

None

## Outputs

None

## Related Links

[Get-LogLevel](./Get-LogLevel.md)

[Set-LogLevel](./Set-LogLevel.md)
