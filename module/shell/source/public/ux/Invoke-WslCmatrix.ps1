function Invoke-WslCmatrix {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Clear-Host
        Write-Host "The Matrix has you..." -ForegroundColor Green
        Start-Sleep -Seconds 3
        wsl cmatrix
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "matrix" -Value "Invoke-WslCmatrix" -Force -Scope Global
