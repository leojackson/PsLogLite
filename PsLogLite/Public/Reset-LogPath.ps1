Function Reset-LogPath {
<#
.SYNOPSIS
Resets the log file path to the default.

.DESCRIPTION
Resets the log file path to the default.

.EXAMPLE
PS> Reset-LogFile

Resets the log file path to the default.

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
    $PreChangePath = Get-LogPath

    # Do nothing if already the default path
    If($PreChangePath -eq $Script:DefaultLogFilePath) {
        Return
    }

    If($PSCmdlet.ShouldProcess($Script:DefaultLogFilePath)) {
        If(-not $Silent.IsPresent) {
            # Writing this before and after, so both log files will have the message
            Write-Log -Message "Log path reset from $PreChangePath to $($Script:DefaultLogFilePath) (default)" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
        }

        Set-LogPath -Path $Script:DefaultLogFilePath -Silent:$($Silent.IsPresent)

        If(-not $Silent.IsPresent) {
            # Writing this before and after, so both log files will have the message
            Write-Log -Message "Log path reset from $PreChangePath to $($Script:DefaultLogFilePath) (default)" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
        }
    }
} # Process

} # Function
