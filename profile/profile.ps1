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

    Write-Verbose "Asserting Shell Module Exists"
    if (Test-Path -Path "$PSScriptRoot\..\module\shell\bin\Shell\Shell.psm1") {
        Write-Verbose "Removing Shell Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force

        Write-Verbose "Importing Shell Module"
        Import-Module -Name "$PSScriptRoot\..\module\shell\bin\Shell" -Global -Force
    
        Write-Verbose "Starting Shell"
        Start-Shell
    }
    else {
        Write-Warning "Shell Module Not Found"
    }

    Write-Verbose "Setting Location"
    Set-Location -Path $HOME
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
