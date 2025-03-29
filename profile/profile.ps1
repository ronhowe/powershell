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

    Write-Host "Loading Profile ; Please Wait" -ForegroundColor DarkGray

    Write-Output "Setting Progress Preference"
    $ProgressPreference = "SilentlyContinue" # changed from Continue
    Write-Debug "`$ProgressPreference = $ProgressPreference"

    Write-Output "Asserting PowerShell Core"
    if ($PSVersionTable.PSEdition -ne "Core") {
        Write-Warning "PowerShell Core Not Detected"
    }

    ## NOTE: Loaded by Az.Tools.Predictor.  Importing intentionally just for clarity.
    Write-Output "Asserting Az.Accounts Module Exists"
    if (Get-Module -Name "Az.Accounts" -ListAvailable) {
        Write-Output "Importing Az.Accounts"
        Import-Module -Name "Az.Accounts"
    }
    else {
        Write-Warning "Skipping Az.Accounts Module"
    }

    Write-Output "Asserting Az.Resources Module Exists"
    if (Get-Module -Name "Az.Resources" -ListAvailable) {
        Write-Output "Importing Az.Resources"
        Import-Module -Name "Az.Resources"
    }
    else {
        Write-Warning "Skipping Az.Resources Module"
    }

    Write-Output "Asserting Az.Tools.Predictor Module Exists"
    if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
        Write-Output "Importing Az.Tools.Predictor"
        Import-Module -Name "Az.Tools.Predictor"
    }
    else {
        Write-Warning "Skipping Az.Tools.Predictor Module"
    }

    Write-Output "Asserting Microsoft.PowerShell.SecretManagement Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
        Write-Output "Importing Microsoft.PowerShell.SecretManagement"
        Import-Module -Name "Microsoft.PowerShell.SecretManagement"
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretManagement Module"
    }

    Write-Output "Asserting Microsoft.PowerShell.SecretStore Module Exists"
    if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
        Write-Output "Importing Microsoft.PowerShell.SecretStore"
        Import-Module -Name "Microsoft.PowerShell.SecretStore"
    }
    else {
        Write-Warning "Skipping Microsoft.PowerShell.SecretStore Module"
    }

    Write-Output "Asserting PackageManagement Module Exists"
    if (Get-Module -Name "PackageManagement" -ListAvailable) {
        Write-Output "Importing PackageManagement"
        Import-Module -Name "PackageManagement"
    }
    else {
        Write-Warning "Skipping PackageManagement Module"
    }

    ## NOTE: Loaded by usual hosts automatically.  Importing intentionally just for clarity.
    Write-Output "Asserting Pester Module Exists"
    if (Get-Module -Name "Pester" -ListAvailable) {
        Write-Output "Importing Pester"
        Import-Module -Name "Pester"
    }
    else {
        Write-Warning "Skipping Pester Module"
    }

    Write-Output "Asserting posh-git Module Exists"
    if (Get-Module -Name "posh-git" -ListAvailable) {
        Write-Output "Importing posh-git"
        Import-Module -Name "posh-git"
    }
    else {
        Write-Warning "Skipping posh-git Module"
    }

    Write-Output "Asserting Shell Module Exists"
    if (Test-Path -Path "$PSScriptRoot\..\module\shell\bin\Shell\Shell.psm1") {
        Write-Output "Removing Shell Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force

        Write-Output "Importing Shell Module"
        Import-Module -Name "$PSScriptRoot\..\module\shell\bin\Shell" -Global -Force
    
        Write-Output "Starting Shell"
        Start-Shell
    }
    else {
        Write-Warning "Shell Module Not Found"
    }

    ## NOTE: Work shim.
    Write-Output "Asserting Windows PowerShell ISE Host"
    if ($host.Name -eq "Windows PowerShell ISE Host") {
        Write-Output "Asserting ISESteroids Module Exists"
        if (Get-Module -Name "ISESteroids" -ListAvailable) {
            Write-Output "Importing ISESteroids"
            Import-Module -Name "ISESteroids"
        }
        else {
            Write-Warning "Skipping ISESteroids Module"
        }
    }

    ## NOTE: Work shim.
    Write-Output "Defining Shim Global Variables"
    New-Variable -Name "Root" -Value "C:\VSTS" -Scope Global -Force -ErrorAction SilentlyContinue
    Write-Debug "`$Root = $Root"
    New-Variable -Name "VSTS" -Value "C:\VSTS" -Scope Global -Force -ErrorAction SilentlyContinue
    Write-Debug "`$VSTS = $VSTS"

    Write-Output "Setting PSReadLine Options"
    if ($PSVersionTable.PSEdition -eq "Core") {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin
        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
    }
    else {
        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
    }

    Write-Output "Setting Location"
    Set-Location -Path $HOME
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
