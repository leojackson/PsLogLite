Function Get-LogPath {
<#
.SYNOPSIS
Get the current log file.

.DESCRIPTION
Get the current log file.

.EXAMPLE
PS> Get-LogFile

Returns the path to the log file.

.INPUTS
None

.OUTPUTS
System.String
    The current path to the log file.

#>
[CmdletBinding()]
param()

Process {
    Return $Script:LogFilePath
} # Process

} # Function

Set-Alias -Name "Get-LogFile" -Value "Get-LogPath"