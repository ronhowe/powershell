Write-Host "https://github.com/ronhowe/powershell/blob/main/profile.ps1" -ForegroundColor Green

Write-Verbose "PowerShell $($PSVersionTable.PSVersion.ToString())" -Verbose

if (Test-Path -Path "C:\VSTS") {
    Write-Verbose "Setting `$Root" -Verbose
    New-Variable -Name "Root" -Value "C:\VSTS" -Scope "Global" -Force -Verbose
    Set-Location -Path $Root
}
else {
    Write-Verbose "Skipping `$Root" -Verbose
}

if ((Get-Module -Name "ISESteroids" -ListAvailable) -and ($host.Name -eq "Windows PowerShell ISE Host")) {
    Write-Verbose "Importing ISESteroids" -Verbose
    Import-Module -Name "ISESteroids"
}
else {
    Write-Verbose "Skipping ISESteroids" -Verbose
}

if ((Get-Module -Name "posh-git" -ListAvailable) -and ($host.Name -ne "Visual Studio Code Host")) {
    Write-Verbose "Importing posh-git" -Verbose
    Import-Module -Name "posh-git"
}
else {
    Write-Verbose "Skipping posh-git" -Verbose
}

if (Get-Module -Name "Microsoft.PowerShell.SecretManagement" -ListAvailable) {
    Write-Verbose "Importing Microsoft.PowerShell.SecretManagement" -Verbose
    Import-Module -Name "Microsoft.PowerShell.SecretManagement"
}
else {
    Write-Verbose "Skipping Microsoft.PowerShell.SecretManagement" -Verbose
}

if (Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable) {
    Write-Verbose "Importing Microsoft.PowerShell.SecretStore" -Verbose
    Import-Module -Name "Microsoft.PowerShell.SecretStore"
}
else {
    Write-Verbose "Skipping Microsoft.PowerShell.SecretStore" -Verbose
}

Set-PSReadLineOption -PredictionViewStyle ListView

function Get-PSReadLineHistory {
    Get-Content -Path $(Get-PSReadLineOption).HistorySavePath
}

function Clear-PSReadLineHistory {
    Remove-Item -Path $(Get-PSReadLineOption).HistorySavePath -Verbose
}

function Set-LocationHome {
    Set-Location -Path $HOME
}

New-Alias -Name "home" -Value Set-LocationHome -Force

function Set-LocationRepos {
    if (Test-Path -Path "C:\VSTS") {
        Set-Location -Path "C:\VSTS"
    }
    elseif (Test-Path -Path "$HOME/repos") {
        Set-Location -Path "$HOME/repos"
    }
}

New-Alias -Name "repos" -Value Set-LocationRepos -Force

function Clear-All {
    Clear-History
    Clear-PSReadLineHistory
    Clear-Host
}
