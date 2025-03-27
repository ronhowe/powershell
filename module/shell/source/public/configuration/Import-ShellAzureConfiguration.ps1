function Import-ShellAzureConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]
        $Path
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Host "Importing Parameters JSON"
        $parameters = Get-Content -Path $Path |
        ConvertFrom-Json |
        Select-object -ExpandProperty "parameters"

        Write-Host "Setting Shell Configuration"
        ## TODO: Add all Azure resource names to ShellConfig.
        $global:ShellConfig.Location = $parameters.location.value;
        $global:ShellConfig.AppConfigurationName = $parameters.configStoreName.value;
        $global:ShellConfig.AutomationAccountName = $parameters.automationAccountName.value;
        $global:ShellConfig.FileShareName = $parameters.fileShareName.value;
        $global:ShellConfig.KeyVaultName = $parameters.keyVaultName.value;
        $global:ShellConfig.StorageAccountName = $parameters.storageAccountName.value;

        Write-Host "Returning Shell Configuration"
        return $global:ShellConfig
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
