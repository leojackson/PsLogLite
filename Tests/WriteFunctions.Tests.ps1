BeforeAll {
    $TestLogPath = "$ENV:Temp\PsLogLite-PesterTests"
}

Describe -Name "Write-* functions" {

    BeforeAll {
        # Set log level to highest level to prep for all contexts
        Set-LogLevel -Level "Debug"
    }

    AfterEach {
        Reset-LogPath
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ Message = "Test" }; OutString = "*DEBUG - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ Message = $null; ErrorAction = "SilentlyContinue" }; OutString = "*CRIT - FAILED TO LOG DEBUG MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{ Message = "TestBuffer"; OutBuffer = 2 }; OutString = "*DEBUG - TestBuffer*" }
        ) {
            Write-Debug @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file when -Message specified"; Params = @{Message = "Test"}; OutString = "*ERROR - Test*" }
            @{ Description = "writes to a log file when -Exception specified"; Params = @{Exception = $(
                    $Except = [System.Exception]::new("Test")
                    $Except.Source = "PsLogLite"
                    $Except
                )}; OutString = "*ERROR - Test*" }
            @{ Description = "writes to a log file when -ErrorRecord specified"; Params = @{ErrorRecord = $(
                    $Except = [System.Exception]::new("Test")
                    $Except.Source = "PsLogLite"
                    [System.Management.Automation.ErrorRecord]::new($Except,"TestError","WriteError",$null)
                )}; OutString = "*ERROR - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{Message = $null}; OutString = "*CRIT - FAILED TO LOG ERROR MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{Message = "TestBuffer"; OutBuffer = 2}; OutString = "*ERROR - TestBuffer*" }
        ) {
            Write-Error -ErrorAction SilentlyContinue @Params | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ Object = "Test" }; OutString = "*HOST - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ Object = $null; ErrorAction = "SilentlyContinue" }; InString = $null; OutString = "*CRIT - FAILED TO LOG HOST MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{ Object = "TestBuffer"; OutBuffer = 2 }; InString = "TestBuffer"; OutString = "*HOST - TestBuffer*" }
        ) {
            Write-Host @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, testing for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ MessageData = "Test" }; OutString = "*INFO - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ MessageData = ""; ErrorAction = "SilentlyContinue" }; OutString = "*CRIT - FAILED TO LOG INFO MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{ MessageData = "TestBuffer"; OutBuffer = 2 }; OutString = "*INFO - TestBuffer*" }
        ) {
            Write-Information @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ InputObject = "Test" }; OutString = "*OUTPUT - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ InputObject = $null; ErrorAction = "SilentlyContinue"}; OutString = "*CRIT - FAILED TO LOG OUTPUT MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{ InputObject = "TestBuffer"; OutBuffer = 2 }; OutString = "*OUTPUT - TestBuffer*" }
        ) {
            Write-Output @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ Message = "Test" }; OutString = "*VERBOSE - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ Message = $null; ErrorAction = "SilentlyContinue" }; OutString = "*CRIT - FAILED TO LOG VERBOSE MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{  Message = "TestBuffer"; OutBuffer = 2}; OutString = "*VERBOSE - TestBuffer*" }
        ) {
            Write-Verbose @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
        # These tests go through use cases for different input types and param sets, and tests for the expected value in the log
        It "<Description>" -TestCases @(
            @{ Description = "writes to a log file"; Params = @{ Message = "Test" }; OutString = "*WARN - Test*" }
            @{ Description = "fails when no message is provided"; Params = @{ Message = $null; ErrorAction = "SilentlyContinue" }; OutString = "*CRIT - FAILED TO LOG WARN MESSAGE*" }
            @{ Description = "resets the output buffer when -OutBuffer is specified"; Params = @{ Message = "TestBuffer"; OutBuffer = 2 }; OutString = "*WARN - TestBuffer*" }
        ) {
            Write-Warning @Params *>&1 | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly $OutString
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
#        Remove-Item -Path $TestLogPath -Force -Recurse
    }
}
