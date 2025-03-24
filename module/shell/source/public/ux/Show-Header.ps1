function Show-Header {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Host "********************************************************************************" -ForegroundColor Green
        Write-Host "https://github.com/ronhowe" -ForegroundColor Green
        Write-Host "********************************************************************************" -ForegroundColor Green
        }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
