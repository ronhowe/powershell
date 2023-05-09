function Start-Shell {
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
            # Write-Verbose "Importing Power Configuration"

            # https://github.com/JustinGrote/PowerConfig/issues/7
            # Import-PowerConfiguration -Name "Shell" -Path "$PSScriptRoot\Shell.json" |
            # Out-Null

            # Write-Verbose "Showing Configuration"

            # $ShellConfiguration |
            # Format-Table -AutoSize

            Write-Verbose "Showing Interface"
            Clear-Host
            Write-Ascii -InputObject $SHELL_CODENAME -ForegroundColor Green
            Show-Logo
            Show-Version
            Show-Date
            Show-Ready
            [System.Console]::Beep(500,100)
        }
        catch {
            Write-Error "Starting Shell Failed"
        }
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}