function Start-Kernel {
    [CmdletBinding()]
    param ()
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process $($MyInvocation.MyCommand.Name)"

        try {
            Write-Verbose "Importing Power Configuration"

            # https://github.com/JustinGrote/PowerConfig/issues/7
            # Import-PowerConfiguration -Name "Shell" -Path "$PSScriptRoot\Shell.json" | Out-Null

            Write-Verbose "Showing Configuration"

            $ShellConfiguration | Format-Table -AutoSize

            Write-Verbose "Showing Interface"

            Show-Logo
            Show-Version
            Show-Date
            Show-Ready
        }
        catch {
            Write-Error "Start Kernel Failed"
        }
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}