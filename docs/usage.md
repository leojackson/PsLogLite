# Usage

## Quick Start

Install the [latest release from GitHub](https://github.com/leojackson/PsLogLite/releases), and unzip it into a Module path directory.

!!! info "Future improvement"
    We plan to list this module in PowerShell Gallery, after which we will update the installation portion of this page to reflect the change.

Add this to your PowerShell script:

```powershell
Import-Module PsLogLite
```

...and you're good to go.

## How It Works

PSLogLite works by overriding some built-in cmdlets of the [Microsoft.PowerShell.Utility](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/) with functions that capture the string being written and log it to a file, before passing the string along to the cmdlet in question. This is done by generating a proxy command using the output of the Create method from the System.Management.Automation.ProxyCommand class, wrapping it in a PowerShell function, and adding custom logic before passing the value on to the cmdlet in question.

This is available currently for the following functions:

* Write-Debug
* Write-Error
* Write-Host
* Write-Information
* Write-Output
* Write-Verbose
* Write-Warning

## Why not just use Start-Transcript?

Transcripts are wonderful for capturing the console. This module is __not__ intended to replace the use of transcripts, but rather to augment them. Transcripts have some specific shortcomings that are addressed by PsLogLite:

* A transcript cannot capture Verbose, Debug, Information, Warning, and Error messages when the corresponding preference action is set to SilentlyContinue
    * PsLogLite configurations work __regardless of a specific log's preference action.__ For example, you can set `$VerbosePreference` to `SilentlyContinue` and still get verbose output to the PsLogLite log
* A transcript captures everything on the host, regardless of relevance
    * PsLogLite can be set to __ignore specific types of entries__ when they are not relevant for logging purposes (e.g. setting log levels)
* Transcript formats can be difficult to parse using machine logic
    * PsLogLite log entries use a __familiar syntax__ similar to syslog

Ultimately, I recommend using __both a transcript and PsLogLite__ to get the fullest picture of what is happening in PowerShell.
