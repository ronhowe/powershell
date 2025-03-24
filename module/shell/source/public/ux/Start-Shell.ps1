function Start-Shell {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        try {
            ## TODO: Adopt Improt-ShellPowerConfiguration if it supports .NET Standard.
            ## LINK: https://github.com/JustinGrote/PowerConfig/issues/7
            Write-Verbose "Importing Shell Configuration"
            Import-ShellConfiguration -WarningAction "SilentlyContinue" |
            Out-Null

            Write-Verbose "Setting Location To Home"
            Set-Location -Path $HOME

            Show-Header
            Show-DateTime
            Show-Version
            Write-Host "Type 'help' for Shell commands." -ForegroundColor DarkGray
            Show-Logo
            Write-Host "OK"
        }
        catch {
            Write-Error "Shell Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "shell" -Value "Start-Shell" -Scope Global -Force
