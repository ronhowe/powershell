function Show-Ready {
    [CmdletBinding()]
    param ()
    begin {
    }
    process {
        Write-Host "READY" -ForegroundColor Green
    }
    end {
    }
}