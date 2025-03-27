function Assert-RunAsWindowsPowerShell {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        if (-not (Test-RunAsWindowsPowerShell)) {
            throw [System.UnauthorizedAccessException] "Not Running As Windows PowerShell"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
