function Show-Version {
    [CmdletBinding()]
    param ()
    begin {
    }
    process {
        Write-Host $(Get-Version) -ForegroundColor DarkGray
    }
    end {
    }
}