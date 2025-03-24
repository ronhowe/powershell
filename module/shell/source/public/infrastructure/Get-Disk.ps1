function Get-Disk {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        if (Test-RunAsPowerShellCore) {
            Import-Module -Name "Microsoft.PowerShell.Management" -Verbose:$false -UseWindowsPowerShell -WarningAction SilentlyContinue 4>&1 |
            Out-Null
        }

        Get-WmiObject -Class "Win32_LogicalDisk" |
        Select-Object -Property @{Name = "DriveLetter" ; Expression = { $_.DeviceID } },
        @{Name = "SizeGB" ; Expression = { [Math]::Round($_.Size / 1GB, 0) } },
        @{Name = "FreeGB" ; Expression = { [Math]::Round($_.FreeSpace / 1GB, 0) } },
        @{Name = "UsedGB" ; Expression = { [Math]::Round($($_.Size - $_.FreeSpace) / 1GB, 0) } } |
        Where-Object { $_.SizeGB -gt 0 }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
