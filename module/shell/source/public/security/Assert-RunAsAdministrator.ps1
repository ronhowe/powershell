function Assert-RunAsAdministrator {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Testing Running As Administrator"
        if (-not (Test-RunAsAdministrator)) {
            throw [System.UnauthorizedAccessException] "Not Running As Administrator"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
