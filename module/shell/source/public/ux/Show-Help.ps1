function Show-Help {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        # sync with Aliases.ps1
        # sync with Aliases.Tests.ps1
        # sync with Show-Help.ps1
        Write-Host "catfact`n`t- Displays a random fact about cats."
        Write-Host "date`n`t- Displays local and UTC times."
        Write-Host "help`n`t- Displays the Shell help."
        Write-Host "home`n`t- Locates the standard home folder."
        Write-Host "matrix`n`t- Take the blue pill or red pill?  (requires wsl and cmatrix)"
        Write-Host "menu`n`t- Starts the Shell menu"
        Write-Host "new`n`t- Refreshes the screen."
        Write-Host "oops`n`t- Opens Notepad to edit command history."
        Write-Host "redact`n`t- Removes the last issued command from the PowerShell history."
        Write-Host "repos`n`t- Locates the standard repos folder."
        Write-Host "shell`n`t- Starts the Shell."
        Write-Host "time`n`t- Displays local and UTC times."
        Write-Host "version`n`t- Displays the version of PowerShell and the Shell."
        Write-Host "weather`n`t- Displays the weather."
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "help" -Value "Show-Help" -Force -Scope Global
