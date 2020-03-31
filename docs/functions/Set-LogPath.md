# Set-LogPath
Set the log file path to a specific value.

```powershell
Set-LogPath
    [-Path] <String>
    [-Silent]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## Description
The `Set-LogPath` function sets the log file path to the specified value. Unless `-Silent` is specified, it also logs the change in both the existing log file and the new log file as a META entry.

If the value specified for `-Path` is a directory, the command assumes the intention is to create a log file in that directory with the same name as the default log file.

If the value specified for `-Path` is not a complete path (e.g. only a file name), `Set-LogPath` will assume the intention is to create that file in `$Env:TEMP`.

If the value specified for `-Path` is a file that does not exist, `Set-LogPath` will attempt to create it. This includes creating any intermediary directories.

## Examples

### Example 1: Set the log file path to an explicit file name

```powershell
Set-LogPath -Path C:\Temp\Logfile.log
```

Sets the log file path to `C:\Temp\Logfile.log`. If this file does not exist, `Set-LogPath` will attempt to create it.

No output is returned. A message is recorded in both log files regarding the change.

### Example 2: Set the log file path to a directory

```powershell
Set-LogPath -Path C:\Logs
```

If `C:\Logs` is an existing directory, this sets the log file path to `C:\Logs\PsLogLite.module.log`, as no filename was specified. If `C:\Logs` is an existing file, the path is set to `C:\Logs` and the file `Logs` (with no extension) will function as the log file in the root of the `C:` drive.

No output is returned. A message is recorded in both log files regarding the change.

### Example 3: Set the log file path to a file name

```powershell
Set-LogPath -Path LogFile.log
```

Sets the log file path to `$ENV:Temp\LogFile.log` as the full path is not specified.

No output is returned. A message is recorded in both log files regarding the change.

### Example 4: Set the log file path to the path of a read-only file

```powershell
Set-ItemProperty -Path C:\Temp\ReadOnlyFile.log -Name IsReadOnly -Value $True
Set-LogPath -Path C:\Temp\ReadOnlyFile.log
```

This will generate an error message indicating that because the file is not writable, the change cannot take place. No change is made. The attempt is recorded in the log.

### Example 5: Set the log file path to an explicit file name

```powershell
Set-LogPath -Path C:\Temp\Logfile.log -Silent
```

Sets the log file path to `C:\Temp\Logfile.log`. If this file does not exist, `Set-LogPath` will attempt to create it.

No output is returned, and no log will be generated indicating a change.

## Parameters

__`-Confirm`__

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

__`-Path`__

Prompts you for confirmation before running the cmdlet.

```yaml
Type: String
Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

__`-Silent`__

Suppresses a log of the reset to the log file.

```yaml
Type: SwitchParameter
Required: False
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

### System.String

A string representing the log file path to set.

## Outputs

None