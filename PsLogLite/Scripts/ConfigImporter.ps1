[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,ValueFromPipeline)]
    [hashtable]
    $ConfigData
)

begin{
    $AcceptedValues = @(
        "LogLevel"
        "LogFileName"
        "LogFilePath"
    )
}

process {
    $Config = @{}
    $AcceptedValues | ForEach-Object {
        If($ConfigData.$_ -is [string] -and -not [string]::IsNullOrEmpty($ConfigData.$_)) {
            $Config.$_ = $ConfigData.$_
        }
    }
    If($Config.Count -gt 0) {
        
    }
    Switch($Configs.Count) {
        {$_ -gt 1} {
            $AcceptedValues | ForEach-Object {
                ForEach($Config in $Configs) {
                    If($_ -in $Config.Keys) {

                    }
                }
            }
            Break
        }
        1 {
            $Configs
            Break
        }
        Default {
            $null
        }
    }
}