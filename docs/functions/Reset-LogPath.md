# Reset-LogPath
Returns the current log file path for the module.

```powershell
Reset-LogPath
    [-Silent]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## Description
The `Reset-LogPath` function resets the log file path to the default setting, which is `%TEMP%\PsLogLite.module.log`. Unless `-Silent` is specified, it also logs the reset in both the existing log file and the default log file as a META entry.

## Examples

### Example 1: Reset the log file path to the default setting

```powershell
Reset-LogPath
```

The current log file path is reset. No output is returned. A message is recorded in both log files regarding the change.

### Example 2: Reset the log file path to the default setting, suppressing additional messages to the log files

```powershell
Reset-LogPath -Silent
```

The current log file path is reset. No output is returned, and no log will be generated indicating a change.

## Parameters

__`-Confirm`__

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

__`-Silent`__

Suppresses a log of the reset in both the existing log file and the default log file.


```yaml
Type: SwitchParameter
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

__`-WhatIf`__

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

## Notes

* `Reset-LogPath` can be run using the built-in alias `Reset-LogFile`.