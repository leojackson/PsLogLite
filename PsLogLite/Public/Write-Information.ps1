Function Write-Information {
[CmdletBinding(HelpUri='https://go.microsoft.com/fwlink/?LinkId=525909', RemotingCapability='None')]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [Alias('Msg')]
    [System.Object]
    $MessageData,

    [Parameter(Position=1)]
    [string[]]
    $Tags
) # param

Begin
{
    $Level = 'Information'
    Try {
        If([string]::IsNullOrEmpty($MessageData)) { Throw } # Explicitly adding this to create a "failure to log" in the log file
        $Function = (Get-PSCallStack)[1].Command
        Write-Log -Message $($MessageData | Out-String) -Function $Function -Level $Level
    } Catch {
        $Prefix = $Script:LogPrefix.$Level
        Write-Log -Message "FAILED TO LOG $Prefix MESSAGE: $_" -Function $('{0}\{1}' -f $Script:ModuleName,$MyInvocation.MyCommand) -Level 'Critical'
    }

    Try {
        $outBuffer = $null
        If ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Information', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } Catch {
        Throw
    }
} # Begin

Process
{
    Try {
        $steppablePipeline.Process($_)
    } Catch {
        Throw
    }
} # Process

End
{
    Try {
        $steppablePipeline.End()
    } Catch {
        Throw
    }
} # End
<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Information
.ForwardHelpCategory Cmdlet

#>

}