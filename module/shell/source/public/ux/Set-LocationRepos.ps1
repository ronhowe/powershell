function Set-LocationRepos {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        if (Test-Path -Path "$HOME\repos") {
            Set-Location -Path "$HOME\repos"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "repos" -Value "Set-LocationRepos" -Force -Scope Global
