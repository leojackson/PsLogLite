Function Write-Host {
[CmdletBinding(HelpUri='https://go.microsoft.com/fwlink/?LinkID=113426', RemotingCapability='None')]
param(
    [Parameter(Position=0, ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
    [System.Object]
    $Object,

    [switch]
    $NoNewline,

    [System.Object]
    $Separator,

    [System.ConsoleColor]
    $ForegroundColor,

    [System.ConsoleColor]
    $BackgroundColor
) # param

Begin
{
    $Level = 'Host'
    Try {
        $Function = (Get-PSCallStack)[1].Command
        Write-Log -Message $($Object | Out-String) -Function $Function -Level $Level
    } Catch {
        $Prefix = $Script:LogPrefix.$Level
        Write-Log -Message "FAILED TO LOG $Prefix MESSAGE: $_" -Function $('{0}\{1}' -f $Script:ModuleName,$MyInvocation.MyCommand) -Level 'Critical'
    }

    Try {
        $outBuffer = $null
        If ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Host', [System.Management.Automation.CommandTypes]::Cmdlet)
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

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Host
.ForwardHelpCategory Cmdlet

#>

}