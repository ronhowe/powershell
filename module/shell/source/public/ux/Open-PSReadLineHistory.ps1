function Open-PSReadLineHistory {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        notepad (Get-PSReadLineOption).HistorySavePath
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "oops" -Value "Open-PSReadLineHistory" -Force -Scope Global
