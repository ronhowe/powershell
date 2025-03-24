[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ProgressPreference = "SilentlyContinue" # changed from Continue

    Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

    Write-Verbose "Asserting PowerShell Core"
    if ($PSVersionTable.PSEdition -ne "Core") {
        Write-Warning "PowerShell Core Not Detected"
    }

    Write-Verbose "Setting PSReadLine Options"
    if ($PSVersionTable.PSEdition -eq "Core") {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
    }
    else {
        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
    }

    Set-Location -Path $HOME
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
