function Show-Date {
    [CmdletBinding()]
    param ()
    begin {
    }
    process {
        Write-Host $(Get-Date -AsUTC)
    }
    end {
    }
}