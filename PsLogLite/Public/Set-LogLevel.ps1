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
[CmdletBinding(SupportsShouldProcess,DefaultParameterSetName="Default")]
param(
    [Parameter(Mandatory=$True,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName="Default")]
    [ValidateScript({
        If($_ -in $([enum]::GetNames("PsLogLiteLevel"))) {
            $True
        } Else {
            Throw "Level must be a valid PsLogLiteLevel value"
        }
    })]
    [String]
    $Level,

    [Parameter(Mandatory=$True,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName="Hashtable")]
    [ValidateScript({
        ForEach($Key in $_.Keys) {
            $Value = $_[$Key]
            If($Key -notin $([enum]::GetNames("PsLogLiteLevel"))) {
                Throw "$Key is not a valid PsLogLiteLevel value"
            }
            If($Value -isnot [Boolean]) {
                Throw "All values must be either TRUE or FALSE, '$Key' is '$Value'"
            }
        }
        $True
    })]
    [Hashtable]
    $Config,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Debug")]
    [Boolean]
    $DebugLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Verbose")]
    [Boolean]
    $VerboseLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Information","Info")]
    [Boolean]
    $InformationLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Output","Out")]
    [Boolean]
    $OutputLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Host")]
    [Boolean]
    $HostLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Warning","Warn")]
    [Boolean]
    $WarningLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Error","Err")]
    [Boolean]
    $ErrorLevel,

    [Parameter(ParameterSetName="Individual")]
    [Alias("Critical","Crit")]
    [Boolean]
    $CriticalLevel

) # param

Begin {
    $PreChangeLevel = Get-LogLevel
}

Process {
    $NewLevel = $PreChangeLevel
    Switch($PSCmdlet.ParameterSetName) {
        "Individual" {
            $PSBoundParameters.Keys | ForEach-Object {
                $NewLevel[[PsLogLiteLevel]$($_ -replace "Level$","")] = $PSBoundParameters[$_]
            }
        }
        "Hashtable" {
            $Config.Keys | ForEach-Object {
                $NewLevel[[PsLogLiteLevel]$_] = $Config[$_]
            }
        }
        Default {
            $NewLevel.Keys | ForEach-Object {
                If($_ -lt $Level) {
                    $NewLevel[$_] = $false
                } Else {
                    $NewLevel[$_] = $true
                }
            }
        }
    }
    If($PSCmdlet.ShouldProcess("Update log levels")) {
        $Script:Config.LogLevel = $NewLevel
        Write-Log -Message "Log level changed from $PreChangeLevel to $Level" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
    }
} # Process

End {}

} # Function
