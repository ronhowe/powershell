function Remove-AzureKeyVault {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceGroupName = $ShellConfig.ResourceGroupName,

        [ValidateNotNullOrEmpty()]
        [string]
        $Location = $ShellConfig.Location,

        [ValidateNotNullOrEmpty()]
        [string]
        $KeyVaultName = $ShellConfig.KeyVaultName
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Host "Removing Azure Key Vault ; Please Wait"
            Remove-AzKeyVault -VaultName $KeyVaultName -Location $Location -ResourceGroupName $ResourceGroupName -Force

            Write-Host "Purging Azure Key Vault ; Please Wait"
            Remove-AzKeyVault -VaultName $KeyVaultName -Location $Location -InRemovedState -Force
        }
        catch {
            Write-Error "Removal Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
