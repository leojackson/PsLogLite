New-Variable -Name "LogPrefix" -Scope Script -Option Constant -Visibility Private -Force -Value ([pscustomobject]@{
    [PsLogLiteLevel]::Debug = "DEBUG"
    [PsLogLiteLevel]::Verbose = "VERBOSE"
    [PsLogLiteLevel]::Information = "INFO"
    [PsLogLiteLevel]::Output = "OUTPUT"
    [PsLogLiteLevel]::Host = "HOST"
    [PsLogLiteLevel]::Warning = "WARN"
    [PsLogLiteLevel]::Error = "ERROR"
    [PsLogLiteLevel]::Critical = "CRIT"
    [PsLogLiteLevel]::Meta = "META"
})

New-Variable -Name "LogPipelineMap" -Scope Script -Option Constant -Visibility Private -Force -Value ([pscustomobject]@{
    [PsLogLiteLevel]::Debug = [System.Management.Automation.Runspaces.PipelineResultTypes]::Debug
    [PsLogLiteLevel]::Verbose = [System.Management.Automation.Runspaces.PipelineResultTypes]::Verbose
    [PsLogLiteLevel]::Information = [System.Management.Automation.Runspaces.PipelineResultTypes]::Information
    [PsLogLiteLevel]::Output = [System.Management.Automation.Runspaces.PipelineResultTypes]::Output
    [PsLogLiteLevel]::Host = [System.Management.Automation.Runspaces.PipelineResultTypes]::Output
    [PsLogLiteLevel]::Warning = [System.Management.Automation.Runspaces.PipelineResultTypes]::Warning
    [PsLogLiteLevel]::Error = [System.Management.Automation.Runspaces.PipelineResultTypes]::Error
    [PsLogLiteLevel]::Critical = [System.Management.Automation.Runspaces.PipelineResultTypes]::Error
    [PsLogLiteLevel]::Meta = [System.Management.Automation.Runspaces.PipelineResultTypes]::Output
})
New-Variable -Name "ModuleName" -Scope Script -Option Constant -Visibility Private -Value ($MyInvocation.MyCommand.Name -split "\.")[0]
New-Variable -Name "DefaultLogFileName" -Scope Script -Option Constant -Visibility Private -Value "$Script:ModuleName.module.log"
New-Variable -Name "DefaultLogFileParent" -Scope Script -Option Constant -Visibility Private -Value $([IO.Path]::GetTempPath())
#New-Variable -Name "DefaultLogFilePath" -Scope Script -Option Constant -Visibility Private -Value $(Join-Path -Path $Script:DefaultLogFileParent -ChildPath "$Script:DefaultLogFileName")
New-Variable -Name "DefaultLogLevel" -Scope Script -Option Constant -Visibility Private -Value "Output"
Switch([System.Environment]::OSVersion.Platform) {
    "MacOSX" {
        New-Variable -Name "ConfigPath" -Scope Script -Option Constant -Visibility Private -Value $(Join-Path -Path "~" -ChildPath "Library/Application Support/$Script:ModuleName")
        Break
    }
    "Unix" {
        New-Variable -Name "ConfigPath" -Scope Script -Option Constant -Visibility Private -Value $(Join-Path -Path "~" -ChildPath ".$Script:ModuleName".ToLower())
        Break
    }
    Default {
        New-Variable -Name "ConfigPath" -Scope Script -Option Constant -Visibility Private -Value $(Join-Path -Path $([System.Environment]::GetEnvironmentVariable("APPDATA")) -ChildPath "$Script:ModuleName")
        Break
    }
}
New-Variable -Name "ConfigFile" -Scope Script -Option Constant -Visibility Private -Value $(Join-Path -Path $Script:ConfigPath -ChildPath "config.json")

# If config file hasn't been created,
If(-not (Test-Path -Path $Script:ConfigFile -PathType Leaf)) { 
    New-Item -Path $Script:ConfigFile -ItemType File -Force
    @{
        LogLevel="$Script:DefaultLogLevel"
        LogFileName="$Script:DefaultLogFileName"
        LogFileParent="$Script:DefaultLogFileParent"
#        LogFilePath="$Script:DefaultLogFilePath"
    } | ConvertTo-Json | Out-File -FilePath $Script:ConfigFile -Force
}
New-Variable -Name "Config" -Scope Script -Visibility Private -Value $(Get-Content -Raw -Path $Script:ConfigFile | ConvertFrom-Json | & $(Join-Path -Path $PSScriptRoot -ChildPath "Scripts\ConfigImporter.ps1"))

#New-Variable -Name "LogFilePath" -Scope Script -Visibility Private -Value $Script:Config.LogFilePath
#New-Variable -Name "LogLevel" -Scope Script -Visibility Private -Value $Script:Config.LogLevel

$Public = @(Get-ChildItem -Path $(Join-Path -Path $PSScriptRoot -ChildPath "Public") -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $(Join-Path -Path $PSScriptRoot -ChildPath "Private") -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

# Dot source public/private functions
$p = 0
$pMax = @($Public + $Private).Count

foreach ($Import in @($Public + $Private)) {
    [int]$pCalc = ($p / $pMax) * 100
    Write-Progress -Activity "Importing module $($Local:ModuleName)" -Status "$pCalc% Complete" -PercentComplete $pCalc -CurrentOperation "Importing functions"
    try {
        . $Import.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
    $p++
}

# Set aliases
Set-Alias -Name "Set-LogFile" -Value "Set-LogPath"
Set-Alias -Name "Reset-LogFile" -Value "Reset-LogPath"
Set-Alias -Name "Get-LogFile" -Value "Get-LogPath"

Export-ModuleMember -Function $Public.BaseName -Alias "Get-LogFile","Reset-LogFile","Set-LogFile"

Write-Log -Message "Module $Script:ModuleName successfully loaded" -Function $((Get-PSCallStack)[1].Command) -Level 'Meta'
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Log -Message "Module $Script:ModuleName is being removed" -Function $((Get-PSCallStack)[1].Command) -Level 'Meta'
}