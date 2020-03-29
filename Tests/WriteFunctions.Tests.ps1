$TestLogPath = "$ENV:Temp\PsLogLite-PesterTests"

Describe -Name "Write-* functions" {

    # Set log level to highest level to prep for all contexts
    Set-LogLevel -Level "Debug"

    Context "Write-Debug" {
        $TestLogFile = "$TestLogPath\Write-Debug.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }
    
    Context "Write-Error" {
        $TestLogFile = "$TestLogPath\Write-Error.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
        It "writes only to the Error stream" {
            Write-Error -Message "This is an error message." -ErrorAction Continue 2>&1 | Should -BeLikeExactly "This is an error message."
        }
        It "writes to a log file" {
            Write-Error -Message "Test" -ErrorAction SilentlyContinue | Out-Null
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*ERROR - Test*"
        }
        It "fails when no message is provided" {
            Write-Error -Message $null -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
            Get-Content -Path $(Get-LogPath) -Raw | Should -BeLikeExactly "*CRIT - FAILED TO LOG ERROR MESSAGE*"
        }
        Reset-LogPath
    }

    Context "Write-Host" {
        $TestLogFile = "$TestLogPath\Write-Host.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }

    Context "Write-Information" {
        $TestLogFile = "$TestLogPath\Write-Information.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }

    Context "Write-Output" {
        $TestLogFile = "$TestLogPath\Write-Output.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }

    Context "Write-Verbose" {
        $TestLogFile = "$TestLogPath\Write-Verbose.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }

    Context "Write-Warning" {
        $TestLogFile = "$TestLogPath\Write-Warning.log"
        New-Item -Path $TestLogFile -Force -ItemType File
        Set-LogPath -Path $TestLogFile
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
        Reset-LogPath
    }

    Remove-Item -Path $TestLogPath -Force -Recurse
}
