Function Set-LogPath {
<#
.SYNOPSIS
Set the log file to a specific path.

.DESCRIPTION
Set the log file to a specific path.

.PARAMETER Path
The path to the new log file.

.EXAMPLE
PS> Get-LogFile

Returns the path to the log file.

.INPUTS
None

.OUTPUTS
System.String

#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory=$True,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]
    $Path,

    [switch]
    $Silent
) # param

Begin {
    # If the path is a filename, prepend it with the %TEMP% directory
    If([Regex]::Matches($Path, "\\").Count -lt 1) {
        $Path = Join-Path -Path $Env:TEMP -ChildPath $Path
    }

    # If the path is a folder, append it with the default log file name
    If(Test-Path $Path -PathType Container) {
        $Path = Join-Path -Path $Path -ChildPath $Script:DefaultLogFileName
    }

    # If the path leads to a file with no extension, add a .log extension
    If($(Split-Path -Path $Path -Leaf) -eq $([System.IO.Path]::GetFileNameWithoutExtension($Path))) {
        $Path = $Path + ".log"
    }

    # If the path is a file that already exists, make sure it's writable
    If(Test-Path $Path -PathType Leaf) {
        Try {
            [IO.File]::OpenWrite($Path).Close()
        } Catch {
            Throw "Log file exists, and is not writable"
        }
    }
    $PreChangePath = Get-LogPath

} # Begin

Process {
    If($PSCmdlet.ShouldProcess($Path)) {
        If(-not $Silent.IsPresent) {
            # Writing this before and after, so both log files will have the message
            Write-Log -Message "Log path changed from $PreChangePath to $Path" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
        }
        $Script:LogFilePath = $Path

        If(-not $Silent.IsPresent) {
            # Writing this before and after, so both log files will have the message
            Write-Log -Message "Log path changed from $PreChangePath to $Path" -Function $('{0}' -f $MyInvocation.MyCommand) -Level 'Meta'
        }
    }
} # Process

End {}

} # Function
