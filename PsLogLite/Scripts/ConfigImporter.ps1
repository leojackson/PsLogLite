[CmdletBinding()]
param(
    [Parameter(Mandatory=$True,ValueFromPipeline)]
    [PSCustomObject]
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
    $Config
}