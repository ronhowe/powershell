function Show-Help {
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
 
        # sync with Aliases.ps1
        Write-Host "catfact" -ForegroundColor Green
        Write-Host "date" -ForegroundColor Green
        Write-Host "help" -ForegroundColor Green
        Write-Host "logo" -ForegroundColor Green
        Write-Host "quote" -ForegroundColor Green
        Write-Host "ready" -ForegroundColor Green
        Write-Host "shell" -ForegroundColor Green
        Write-Host "version" -ForegroundColor Green
        Write-Host "weather" -ForegroundColor Green
     }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
    }
}