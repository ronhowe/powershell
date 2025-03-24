function Show-ShellConfiguration {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Showing Shell Configuration"
        $global:ShellConfig |
        Out-String |
        Write-Host
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
