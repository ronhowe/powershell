function Get-Cpu {
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

        Get-WmiObject -Class "Win32_Processor" |
        Select-Object -ExpandProperty "NumberOfCores" |
        Measure-Object -Sum |
        Select-Object -Property @{Name = "CoreCount"; Expression = { $_.Sum } }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
