function Connect-AzureAccount {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Tenant = $ShellConfig.Tenant,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Subscription = $ShellConfig.Subscription
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Host "Connecting Azure Account"
        Connect-AzAccount -Tenant $Tenant -Subscription $Subscription -UseDeviceAuthentication
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
