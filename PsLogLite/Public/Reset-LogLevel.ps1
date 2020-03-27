Function Reset-LogLevel {
<#
.SYNOPSIS
Resets the log level to the default.

.DESCRIPTION
Resets the log level to the default.

.EXAMPLE
PS> Reset-LogLevel

Resets the log level to the default.

.INPUTS
None

.OUTPUTS
None

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]
    $Silent
)

Process {
    $PreChangeLevel = Get-LogLevel

    # Do nothing if already the default level
    If($PreChangeLevel -eq $Script:DefaultLogLevel) {
        Return
    }

    If($PSCmdlet.ShouldProcess($Script:DefaultLogLevel)) {
        Set-LogLevel -Level $Script:DefaultLogLevel
        
        If($Silent.IsPresent -is -not $True) {
            # Writing this before and after, so both log files will have the message
            Write-Log -Message "Log level reset from $PreChangeLevel to $Script:DefaultLogLevel (default)" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
        }
    }
} # Process

} # Function
