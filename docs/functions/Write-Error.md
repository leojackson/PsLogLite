path: tree/master/PsLogLite/Public
source: Write-Error.ps1

# Write-Error

Writes an error message to the error stream, logged according to the log level and log path configured as part of the `#!powershell PsLogLite` module.

```powershell
Write-Error
    [-Message] <String>
    [-Category <ErrorCategory>]
    [-ErrorId <String>]
    [-TargetObject <Object>]
    [-RecommendedAction <String>]
    [-CategoryActivity <String>]
    [-CategoryReason <String>]
    [-CategoryTargetName <String>]
    [-CategoryTargetType <String>]
    [<CommonParameters>]
```

```powershell
Write-Error
    -Exception <Exception>
    [-Message <String>]
    [-Category <ErrorCategory>]
    [-ErrorId <String>]
    [-TargetObject <Object>]
    [-RecommendedAction <String>]
    [-CategoryActivity <String>]
    [-CategoryReason <String>]
    [-CategoryTargetName <String>]
    [-CategoryTargetType <String>]
    [<CommonParameters>]
```

```powershell
Write-Error
    -ErrorRecord <ErrorRecord>
    [-RecommendedAction <String>]
    [-CategoryActivity <String>]
    [-CategoryReason <String>]
    [-CategoryTargetName <String>]
    [-CategoryTargetType <String>]
    [<CommonParameters>]
```

## Description

!!! info
    This function is a proxy function for the [Write-Error](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-error) cmdlet distributed as part of the [Microsoft.PowerShell.Utility](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/) built-in module. Please refer to Microsoft's documentation for how and where to use this function.

This function uses the same parameters, accepts the same inputs, and produces the same outputs as the cmdlet `#!powershell Write-Error` by implicitly calling a runtime-generated copy of that cmdlet within a wrapper function.

Inside that wrapper, the function sends the content of the `#!powershell -ErrorRecord`, `#!powershell -Exception`, or `#!powershell -Message` parameter (depending on which parameter set is used) to the central log processor, `#!powershell Write-Log`, a private function which decides whether the message gets logged based on the current log level, as well as where the log gets written based on the current log file path.

## Related Links

[Write-Debug](./Write-Debug.md)

[Write-Host](./Write-Host.md)

[Write-Information](./Write-Information.md)

[Write-Output](./Write-Output.md)

[Write-Verbose](./Write-Verbose.md)

[Write-Warning](./Write-Warning.md)