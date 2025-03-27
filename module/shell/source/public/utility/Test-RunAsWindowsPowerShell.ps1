function Test-RunAsWindowsPowerShell {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        return ($PSVersionTable.PSEdition -eq "Desktop")
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
