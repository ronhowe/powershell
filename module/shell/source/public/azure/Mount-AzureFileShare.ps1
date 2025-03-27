function Mount-AzureFileShare {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]
        $ResourceGroupName = $ShellConfig.ResourceGroupName,

        [ValidateNotNullOrEmpty()]
        [string]
        $StorageAccountName = $ShellConfig.StorageAccountName,

        [ValidateNotNullOrEmpty()]
        [string]
        $FileShareName = $ShellConfig.FileShareName,

        [ValidateNotNullOrEmpty()]
        [string]
        $DriveLetter = $ShellConfig.DriveLetter
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $ErrorActionPreference = "Stop"

        Write-Host "Testing Connection To Azure Storage Account"
        $connectTestResult = Test-NetConnection -ComputerName "$StorageAccountName.file.core.windows.net" -Port 445

        Write-Host "Asserting Connection To Azure Storage Account"
        if ($connectTestResult.TcpTestSucceeded) {
            Write-Host "Getting Azure Storage Account Key"
            $storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName)[0].Value

            Write-Host "Mounting Azure File Share ; Please Wait"
            $parameters = @{
                Name       = $DriveLetter
                PSProvider = "FileSystem"
                Root       = "\\$StorageAccountName.file.core.windows.net\$FileShareName"
                Persist    = $true
                Scope     = "Global"
                Credential = (New-Object System.Management.Automation.PSCredential("Azure\$StorageAccountName", (ConvertTo-SecureString $storageAccountKey -AsPlainText -Force)))
                Verbose    = $true
            }
            New-PSDrive @parameters |
            Out-Null
        }
        else {
            Write-Warning "Connection To Azure Storage Account Failed"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
