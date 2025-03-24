[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

    Write-Verbose "Setting Progress Preference"
    $ProgressPreference = "SilentlyContinue" # changed from Continue
    Write-Debug "`$ProgressPreference = $ProgressPreference"

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

    Write-Verbose "Setting Location"
    Set-Location -Path $HOME
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
