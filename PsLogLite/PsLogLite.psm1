New-Variable -Name "LogPrefix" -Scope Script -Option Constant -Visibility Private -Value ([pscustomobject]@{
    [PsLogLiteLevel]::Debug = "DEBUG"
    [PsLogLiteLevel]::Verbose = "VERBOSE"
    [PsLogLiteLevel]::Information = "INFO"
    [PsLogLiteLevel]::Host = "HOST"
    [PsLogLiteLevel]::Warning = "WARN"
    [PsLogLiteLevel]::Error = "ERROR"
    [PsLogLiteLevel]::Critical = "CRIT"
    [PsLogLiteLevel]::Meta = "META"
})

New-Variable -Name "LogPipelineMap" -Scope Script -Option Constant -Visibility Private -Value @{
    [PsLogLiteLevel]::Debug = [System.Management.Automation.Runspaces.PipelineResultTypes]::Debug
    [PsLogLiteLevel]::Verbose = [System.Management.Automation.Runspaces.PipelineResultTypes]::Verbose
    [PsLogLiteLevel]::Information = [System.Management.Automation.Runspaces.PipelineResultTypes]::Information
    [PsLogLiteLevel]::Host = [System.Management.Automation.Runspaces.PipelineResultTypes]::Output
    [PsLogLiteLevel]::Warning = [System.Management.Automation.Runspaces.PipelineResultTypes]::Warning
    [PsLogLiteLevel]::Error = [System.Management.Automation.Runspaces.PipelineResultTypes]::Error
    [PsLogLiteLevel]::Critical = [System.Management.Automation.Runspaces.PipelineResultTypes]::Error
    [PsLogLiteLevel]::Meta = [System.Management.Automation.Runspaces.PipelineResultTypes]::Output
}

New-Variable -Name "ModuleName" -Scope Script -Option Constant -Visibility Private -Value ($MyInvocation.MyCommand.Name -split "\.")[0]
New-Variable -Name "DefaultLogFileName" -Scope Script -Option Constant -Visibility Private -Value "$Script:ModuleName.module.log"
New-Variable -Name "DefaultLogFilePath" -Scope Script -Option Constant -Visibility Private -Value "$Env:TEMP\$Script:DefaultLogFileName"
New-Variable -Name "LogFilePath" -Scope Script -Visibility Private -Value $Script:DefaultLogFilePath
New-Variable -Name "DefaultLogLevel" -Scope Script -Option Constant -Visibility Private -Value "Host"
New-Variable -Name "LogLevel" -Scope Script -Visibility Private -Value $Script:DefaultLogLevel

$Public = @(Get-ChildItem -Path "$PSScriptRoot\Public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

# Dot source public/private functions
$p = 0
$pMax = @($Public + $Private).Count

foreach ($Import in @($Public + $Private)) {
    [int]$pCalc = ($p / $pMax) * 100
    Write-Progress -Activity "Importing module $($Local:ModuleName)" -Status "$pCalc% Complete" -PercentComplete $pCalc -CurrentOperation "Importing functions"
    try {
        . $Import.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): _"
    }
    $p++
}

Export-ModuleMember -Function $Public.BaseName

Write-Log -Message "Module $Script:ModuleName successfully loaded" -Function $((Get-PSCallStack)[1].Command) -Level 'Meta'
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Log -Message "Module $Script:ModuleName is being removed" -Function $((Get-PSCallStack)[1].Command) -Level 'Meta'
}