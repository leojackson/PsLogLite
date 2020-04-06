title: PsLogLite
description: PsLogLite is a lightweight procedural logging utility for use with any PowerShell script.

# PsLogLite

__PsLogLite__ is a lightweight procedural logging utility for use with any PowerShell script. It works by using proxy functions to override all default Write-* cmdlets with script functions that log their input.

## Overview

__PsLogLite__ works by wrapping the existing Write cmdlets in proxy functions that include logging logic. This allows logging to be turned on and off for specific log levels.

## Usage

Load the module, and use the existing `#!powershell Write-*` cmdlets you already use in your code. Other than loading the module, you do not need to make any changes to existing code to take advantage of PsLogLite's logging capability.

This code:

```powershell
Import-Module PsLogLite
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

```text
03/01/2020 00:00:00.000 - Set-LogLevel - META - Log level changed from Output to Debug
03/01/2020 00:00:00.000 - (root) - ERROR - Error Message
03/01/2020 00:00:00.000 - (root) - WARN - Warning Message
03/01/2020 00:00:00.000 - (root) - OUTPUT - Output Message
03/01/2020 00:00:00.000 - (root) - HOST - Host Message
03/01/2020 00:00:00.000 - (root) - INFO - Information Message
03/01/2020 00:00:00.000 - (root) - VERBOSE - Verbose Message
03/01/2020 00:00:00.000 - (root) - DEBUG - Debug Message
```

By default, the log is located at `#!powershell $ENV:TEMP\PsLogLite.module.log`, though this can be overridden with the `#!powershell Set-LogPath` function.

## License

__PsLogLite__ is released under the [MIT License](https://github.com/leojackson/PsLogLite/blob/master/LICENSE).