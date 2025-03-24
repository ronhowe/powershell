function Disconnect-AzureAccount {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Disconnecting Azure Account"
        Disconnect-AzAccount
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
