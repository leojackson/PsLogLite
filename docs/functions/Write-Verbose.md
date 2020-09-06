path: tree/master/PsLogLite/Public
source: Write-Verbose.ps1

# Write-Verbose

Writes text to the verbose message stream, logged according to the log level and log path configured as part of the `#!powershell PsLogLite` module.

```powershell
Write-Verbose
    [-Message] <String>
    [<CommonParameters>]
```

## Description

!!! info
    This function is a proxy function for the [Write-Verbose](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-verbose) cmdlet distributed as part of the [Microsoft.PowerShell.Utility](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/) built-in module. Please refer to Microsoft's documentation for how and where to use this function.

This function uses the same parameters, accepts the same inputs, and produces the same outputs as the cmdlet `#!powershell Write-Verbose` by implicitly calling a runtime-generated copy of that cmdlet within a wrapper function.

Inside that wrapper, the function sends the content of the `#!powershell -Message` parameter to the central log processor, `#!powershell Write-Log`, a private function which decides whether the message gets logged based on the current log level, as well as where the log gets written based on the current log file path.

## Related Links

[Write-Debug](./Write-Debug.md)

[Write-Error](./Write-Error.md)

[Write-Host](./Write-Host.md)

[Write-Information](./Write-Information.md)

[Write-Output](./Write-Output.md)

[Write-Warning](./Write-Warning.md)
