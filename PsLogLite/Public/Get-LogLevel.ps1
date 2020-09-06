Function Get-LogLevel {
<#
.SYNOPSIS
Get the current log level.

.DESCRIPTION
Get the current log level.

.EXAMPLE
PS> Get-LogFile

Returns the current log level.

.INPUTS
None

.OUTPUTS
PsLogLiteLevel
    The current logging level.

#>
[CmdletBinding()]
param()

Process {
    $Script:Config.LogLevel
} # Process

} # Function
