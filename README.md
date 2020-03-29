# PsLogLite
PsLogLite is a lightweight procedural logging utility for use with any PowerShell script. It works by using proxy functions to override all default Write-* cmdlets with script functions that log their input.

## Usage
This code:
```powershell
Using Module PsLogLite
Set-LogLevel Debug
Write-Error -Message "Error Message"
Write-Warning -Message "Warning Message"
Write-Output -InputObject "Output Message"
Write-Host -Object "Host Message"
Write-Information -MessageData "Information Message"
Write-Verbose -Message "Verbose Message"
Write-Debug -Message "Debug Message"
```
...results in log file entries similar to these:
```
03/01/2020 00:00:00.000 - Set-LogLevel - META - Log level changed from Output to Debug
03/01/2020 00:00:00.000 - (root) - ERROR - Error Message
03/01/2020 00:00:00.000 - (root) - WARN - Warning Message
03/01/2020 00:00:00.000 - (root) - OUTPUT - Output Message
03/01/2020 00:00:00.000 - (root) - HOST - Host Message
03/01/2020 00:00:00.000 - (root) - INFO - Information Message
03/01/2020 00:00:00.000 - (root) - VERBOSE - Verbose Message
03/01/2020 00:00:00.000 - (root) - DEBUG - Debug Message
```
By default, the log is located at `%TEMP%\PsLogLite.module.log`, though this can be overridden with the `Set-LogPath` function.