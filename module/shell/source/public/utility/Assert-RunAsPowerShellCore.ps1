function Assert-RunAsPowerShellCore {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Testing Running As PowerShell Core"
        if (-not (Test-RunAsPowerShellCore)) {
            throw [System.UnauthorizedAccessException] "Not Running As PowerShell Core"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
