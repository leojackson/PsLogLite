Function Set-LogLevel {
<#
.SYNOPSIS
Set the log level to a specific value.

.DESCRIPTION
Set the log level to a specific value.

.PARAMETER Level
The level to set logging to.

.EXAMPLE
PS> Set-LogLevel 'Error'

Sets the log level to log all messages of level Error or higher

.EXAMPLE
PS> Set-LogLevel 'Debug'

Sets the log level to log all messages of level Debug or higher

.INPUTS
PsLogLiteLevel
    The logging level at and above which PsLogLite should log messages.

.OUTPUTS
None

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$True,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [ValidateScript({
        If($_ -in $([enum]::GetNames("PsLogLiteLevel"))) {
            $True
        } Else {
            Throw "Level must be a valid PsLogLiteLevel value"
        }
    })]
    [String]
    $Level
) # param

Begin {
    $PreChangeLevel = Get-LogLevel
}

Process {
    If($PSCmdlet.ShouldProcess($Level)) {
        $Script:LogLevel = $Level
        Write-Log -Message "Log level changed from $PreChangeLevel to $Level" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
    }
} # Process

End {}

} # Function
