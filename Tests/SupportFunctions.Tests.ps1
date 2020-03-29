Describe "Support Functions" {
    Context "LogLevel" {
        It "Get-LogLevel returns the current log level" {
            $(Get-LogLevel) -in [enum]::GetNames("PsLogLiteLevel") | Should -Be $True
        }
        
        It "Set-LogLevel changes the log level to a different value" {
            Set-LogLevel -Level "Output"
            Get-LogLevel | Should -Be "Output"
            Set-LogLevel -Level "Verbose"
            Get-LogLevel | Should -Be "Verbose"
        }

        It "Set-LogLevel throws an exception with invalid input" {
            { Set-LogLevel -Level "Garbage" } | Should -Throw "Level must be a valid PsLogLiteLevel value"
        }

        It "Reset-LogLevel changes the log level back to the default" {
            Reset-LogLevel
            Get-LogLevel | Should -Be "Output"
        }
    }
    Context "LogPath" {
        $NewFile = "PsLogLite.newpath.log"
        $NewDir = "$ENV:TEMP\PsLogLite-PathTest"
        $NewPath = "$ENV:TEMP\$NewFile"
        New-Item -Path $NewDir -ItemType Directory -Force

        It "Get-LogPath returns the current log path" {
            Test-Path $(Get-LogPath) | Should -Be $True
        }

        It "Get-LogPath also works when referenced by alias Get-LogFile" {
            Test-Path $(Get-LogFile) | Should -Be $True
        }

        It "Set-LogPath changes the log level to a different value" {
            Get-LogPath | Should -Be "$ENV:TEMP\PsLogLite.module.log"
            Set-LogPath -Path $NewPath
            Get-LogPath | Should -Be $NewPath
        }

        It "Reset-LogPath changes the log path back to the default" {
            Set-LogPath -Path $NewPath
            Reset-LogPath
            Get-LogPath | Should -Be "$ENV:TEMP\PsLogLite.module.log"
        }

        It "Set-LogPath also works when referenced by alias Set-LogFile" {
            Get-LogFile | Should -Be "$ENV:TEMP\PsLogLite.module.log"
            Set-LogFile -Path $NewPath
            Get-LogFile | Should -Be $NewPath
        }

        It "Reset-LogPath also works when referenced by alias Reset-LogFile" {
            Set-LogFile -Path $NewPath
            Reset-LogFile
            Get-LogFile | Should -Be "$ENV:TEMP\PsLogLite.module.log"
        }

        It "Set-LogPath automatically puts the log file into %TEMP% when only a filename is specified" {
            Set-LogFile -Path $NewFile
            Get-LogFile | Should -Not -Be $NewFile
            Get-LogFile | Should -Be "$ENV:TEMP\$NewFile"
        }

        It "Set-LogPath automatically appends .log if the path does not exist and does not end in .log" {
            Set-LogFile -Path $NewDir
            Get-LogFile | Should -Not -Be $NewDir
            Get-LogFile | Should -Be "$NewDir\PsLogLite.module.log"
        }

        It "Set-LogPath automatically sets the log file name to PsLogLite.module.log if a directory is specified" {
            Set-LogFile -Path "$NewDir\NewLogFile"
            Get-LogFile | Should -Not -Be "$NewDir\NewLogFile"
            Get-LogFile | Should -Be "$NewDir\NewLogFile.log"
        }
        Remove-Item -Path $NewPath -Force
        Remove-Item -Path $NewDir -Force -Recurse
    }
}