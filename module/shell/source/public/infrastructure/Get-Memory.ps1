function Get-Memory {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        if (Test-RunAsPowerShellCore) {
            Import-Module -Name "Microsoft.PowerShell.Management" -UseWindowsPowerShell -WarningAction SilentlyContinue |
            Out-Null
        }

        Get-WmiObject -Class "Win32_PhysicalMemory" |
        Select-Object -ExpandProperty "Capacity" |
        Measure-Object -Sum |
        Select-Object -Property @{Name = "MemoryGB"; Expression = { [Math]::Round($_.Sum / 1GB, 0) } }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
