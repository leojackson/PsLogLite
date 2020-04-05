Function Write-Log {
<#
.SYNOPSIS
Writes a continuous log file of Write-* messages.

.DESCRIPTION
Writes a continuous log file of Write-* messages. Inspired by syslog
and other similar standards.

.PARAMETER Message
The message to log.

.PARAMETER Function
The function that generated the message. If not specified, the fucntion
is derived from context.

.PARAMETER LogPath
The location where logs are written. If the file or any part of the
path do not exist, they will be created.

.PARAMETER Encoding
The text encoding to use for the log file. Default is utf8.

.PARAMETER Type
The type of message to log. 

.PARAMETER Force
Forcibly overwrite the log file with the current message. Default is to
append an existing file.

.PARAMETER Params
Additional parameters to 

.PARAMETER Tee
Insert description for parameter Tee here

.PARAMETER Silent
Insert description for parameter Silent here

.EXAMPLE
PS> Write-Log

Describe example here

.EXAMPLE
PS> Write-Log -Message

Describe example here

.INPUTS
Insert inputs here

.OUTPUTS
Insert outputs here

.NOTES
Insert notes here

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$True,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]
    $Message,

    [Parameter(Mandatory=$True,Position=1)]
    [AllowEmptyString()]
    [string]
    $Function,

    [Parameter(Mandatory=$True,Position=2)]
    [Alias('Facility','Type')]
    [PsLogLiteLevel]
    $Level
) # param

Begin {
    $Date = Get-Date -Format "MM/dd/yyyy HH:mm:ss.fff"

    $OutFileParams = @{
        FilePath = "$($Script:Config.LogFilePath)"
        Append = $True
        NoClobber = $True
    }

    If($Function -eq "<ScriptBlock>" -or  [string]::IsNullOrEmpty($Function)) {
        $Function = "(root)"
    }

    $Prefix = $Script:LogPrefix.$Level

    # Get the currently logged on username
    $UserName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
} # Begin

Process {
    If($Level -ge $Script:Config.LogLevel -and $PSCmdlet.ShouldProcess($Message)) {
        Try {
            If(-not $(Test-Path -Path $Script:Config.LogFilePath)) {
                New-Item -Path "$($Script:Config.LogFilePath)" -ItemType File -Force | Out-Null
            }
            "$Date - $UserName - $Function - $Prefix - $Message" | Out-File @OutFileParams
        }
        Catch [System.UnauthorizedAccessException] {
            Microsoft.PowerShell.Utility\Write-Warning -Message "Unable to write to log path $($Script:Config.LogFilePath), resetting to default path"
            Reset-LogPath -Silent   # Setting this to Silent to prevent an endless loop
            Try {
                If(-not $(Test-Path -Path $Script:Config.LogFilePath)) {
                    New-Item -Path "$($Script:Config.LogFilePath)" -ItemType File -Force | Out-Null
                }
                $OutFileParams.FilePath = $Script:Config.LogFilePath
                "$Date - $Function - $Prefix - $Message" | Out-File @OutFileParams
            }
            Catch {
                Throw "Unable to write log to file $($Script:Config.LogFilePath) after log path reset: $_"
            }
        }
    }
} # Process

End {}

} # Function