BeforeAll {
    $TestLogPath = "$ENV:Temp\PsLogLite-PesterTests"
}

Describe -Name "Write-* functions" {

    BeforeAll {
        # Set log level to highest level to prep for all contexts
        Set-LogLevel -Level "Debug"
    }

    Context "Write-Debug" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Debug.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Debug stream" {
            $DebugTemp = $Global:DebugPreference
            $Global:DebugPreference = "Continue"
            Write-Debug -Message "This is a debug message." 5>&1 | Should -Be "This is a debug message."
            $Global:DebugPreference = $DebugTemp
        }
        It "writes to a log file" {
            Write-Debug -Message "Test" | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*DEBUG - Test*"
        }
        It "fails when no message is provided" {
            Write-Debug -Message $null | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG DEBUG MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Debug -Message "TestBuffer" -OutBuffer 2
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*DEBUG - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }
    
    Context "Write-Error" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Error.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Error stream" {
            Write-Error -Message "This is an error message." -ErrorAction Continue 2>&1 | Should -BeLikeExactly "This is an error message."
        }
        It "writes to a log file when -Message specified" {
            Write-Error -Message "Test" -ErrorAction SilentlyContinue | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*ERROR - Test*"
        }
        It "writes to a log file when -Exception specified" {
            $Except = [System.Exception]::new("Test")
            $Except.Source = "PsLogLite"
            Write-Error -Exception $Except -ErrorAction SilentlyContinue | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*ERROR - Test*"
        }
        It "writes to a log file when -ErrorRecord specified" {
            $Except = [System.Exception]::new("Test")
            $Except.Source = "PsLogLite"
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($Except,"TestError","WriteError",$null)
            Write-Error -ErrorRecord $ErrorRecord -ErrorAction SilentlyContinue | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*ERROR - Test*"
        }
        It "fails when no message is provided" {
            Write-Error -Message $null -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG ERROR MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Error -Message "TestBuffer" -OutBuffer 2 -ErrorAction SilentlyContinue
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*ERROR - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Host" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Host.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes to the Information stream" {
            Write-Host -Object "This is a host message." 6>&1 | Should -Be "This is a host message."
        }
        It "writes to a log file" {
            Write-Host -Object "Test" 6>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*HOST - Test*"
        }
        It "fails when no message is provided" {
            Write-Host -Object $null -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG HOST MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Host -Object "TestBuffer" -OutBuffer 2 6>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*HOST - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Information" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Information.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Information stream" {
            Write-Information -MessageData "This is an information message." -InformationAction Continue 6>&1 | Should -Be "This is an information message."
        }
        It "writes to a log file" {
            Write-Information -MessageData "Test" | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*INFO - Test*"
        }
        It "fails when no message is provided" {
            Write-Information -MessageData "" | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG INFO MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Information -MessageData "TestBuffer" -OutBuffer 2 6>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*INFO - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Output" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Output.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Success stream" {
            Write-Output -InputObject "This is an output message." | Should -Be "This is an output message."
        }
        It "writes to a log file" {
            Write-Output -InputObject "Test" | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*OUTPUT - Test*"
        }
        It "fails when no message is provided" {
            Write-Output -InputObject $null | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG OUTPUT MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Output -InputObject "TestBuffer" -OutBuffer 2 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*OUTPUT - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Verbose" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Verbose.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Verbose stream" {
            $VerboseTemp = $Global:VerbosePreference
            $Global:VerbosePreference = "Continue"
            Write-Verbose -Message "This is a verbose message." 4>&1 | Should -Be "This is a verbose message."
            $Global:VerbosePreference = $VerboseTemp
        }
        It "writes to a log file" {
            Write-Verbose -Message "Test" | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*VERBOSE - Test*"
        }
        It "fails when no message is provided" {
            Write-Verbose -Message $null | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG VERBOSE MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Verbose -Message "TestBuffer" -OutBuffer 2 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*VERBOSE - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Warning" {
        BeforeAll {
            $TestLogFile = "$TestLogPath\Write-Warning.log"
            New-Item -Path $TestLogFile -Force -ItemType File
            Set-LogPath -Path $TestLogFile
        }
        It "writes only to the Warning stream" {
            Write-Warning -Message "This is an warning message." -WarningAction Continue 3>&1 | Should -BeLikeExactly "This is an warning message."
        }
        It "writes to a log file" {
            Write-Warning -Message "Test" -WarningAction SilentlyContinue | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*WARN - Test*"
        }
        It "fails when no message is provided" {
            Write-Warning -Message $null -WarningAction SilentlyContinue | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG WARN MESSAGE*"
        }
        It "resets the output buffer when -OutBuffer is specified" {
            Write-Warning -Message "TestBuffer" -OutBuffer 2 3>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*WARN - TestBuffer*"
        }
        AfterAll {
            Reset-LogPath
        }
    }

    Context "Write-Log Exception Handling" {
        BeforeAll {
            $CustomLogFile = "$TestLogPath\ReadOnlyLogTest.log"
            Reset-LogPath -Silent
            $DefaultLogPath = Get-LogPath
        }
        It "redirects to the default log file path when access is denied to custom log file" {
            # Uses Write-Information as a pass-thru to Write-Log
            Reset-LogPath -Silent
            $DefaultLogPath = Get-LogPath
            {Write-Information -MessageData "Test #1"} | Should -Not -Throw
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*INFO - Test #1*"
            Set-LogPath -Path $CustomLogFile
            Rename-Item -Path $DefaultLogPath -NewName ($(Split-Path -Path $DefaultLogPath -Leaf) -replace '\.log$','.temp.log') -Force
            If(-not $(Test-Path $CustomLogFile)) {
                New-Item -Path $CustomLogFile -ItemType File
            }
            Set-ItemProperty -Path $CustomLogFile -Name IsReadOnly -Value $True
            Write-Information -MessageData "Test #2" 3>&1 | Should -BeLike "*Unable to write to log path $CustomLogFile, resetting to default path*"
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*INFO - Test #2*"
        }

        It "throws an exception when the default log file is read-only" {
            # Resetting the environment after the last test
            If(Test-Path -Path $CustomLogFile) {
                Set-ItemProperty -Path $CustomLogFile -Name IsReadOnly -Value $False
                Set-LogPath -Path $CustomLogFile
            }
            If((Test-Path -Path $DefaultLogPath) -and (Test-Path -Path ($DefaultLogPath -replace '\.log$','.temp.log'))) {
                Remove-Item -Path $DefaultLogPath -Force
                Rename-Item -Path ($DefaultLogPath -replace '\.log$','.temp.log') -NewName $DefaultLogPath -Force
            }
            Reset-LogPath

            # Uses Write-Information as a pass-thru to Write-Log
            Reset-LogPath -Silent
            {Write-Information -MessageData "Test #3"} | Should -Not -Throw
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*INFO - Test #3*"
            Set-ItemProperty -Path $(Get-LogPath) -Name IsReadOnly -Value $True
            {Write-Information -MessageData "Test #4" 3>&1 | Out-Null} | Should -Throw
            # Resetting default log path to writeable
            Set-ItemProperty -Path $(Get-LogPath) -Name IsReadOnly -Value $False
        }
    }

    AfterAll {
        Reset-LogPath
        Reset-LogLevel
        Remove-Item -Path $TestLogPath -Force -Recurse
    }
}
