Write-Host "https://github.com/ronhowe/powershell/blob/main/profile.ps1" -ForegroundColor Green

Write-Verbose "PowerShell $($PSVersionTable.PSVersion.ToString())" -Verbose

#region imports
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
#endregion imports

#region api
function Invoke-Api {
    & "$HOME\repos\ronhowe\powershell\azure\Test-Api.ps1" -Loop
}

New-Alias -Name "api" -Value Invoke-Api -Force -Verbose
#endregion api

#region history
function Get-PSReadLineHistory {
    Get-Content -Path $(Get-PSReadLineOption).HistorySavePath
}

function Clear-PSReadLineHistory {
    Remove-Item -Path $(Get-PSReadLineOption).HistorySavePath -Verbose
}
#endregion history

#region home
function Set-LocationHome {
    Set-Location -Path $HOME
}

New-Alias -Name "home" -Value Set-LocationHome -Force -Verbose
#endregion home

#region log
function Start-Log {
    Start-Transcript -Force -ErrorAction SilentlyContinue
}
New-Alias -Name "log" -Value Start-Log -Force -Verbose
#endregion log

#region new
function Show-New {
    Clear-Host
    Show-RonHowe
    Set-LocationHome
}

New-Alias -Name "new" -Value Show-New -Force -Verbose
#endregion new

#region posh
function Set-LocationPowerShell {
    if (Test-Path -Path "C:\VSTS\ronhowe\powershell") {
        Set-Location -Path "C:\VSTS\ronhowe\powershell"
    }
    elseif (Test-Path -Path "$HOME\repos\ronhowe\powershell") {
        Set-Location -Path "$HOME\repos\ronhowe\powershell"
    }
}

New-Alias -Name "posh" -Value Set-LocationPowerShell -Force -Verbose
#endregion posh

#region repos
function Set-LocationRepos {
    if (Test-Path -Path "C:\VSTS") {
        Set-Location -Path "C:\VSTS"
    }
    elseif (Test-Path -Path "$HOME\repos") {
        Set-Location -Path "$HOME\repos"
    }
}

New-Alias -Name "repos" -Value Set-LocationRepos -Force -Verbose
#endregion repos

#region ronhowe
function Show-RonHowe {
    Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
    Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
    Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
    Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
    Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
    Write-Host ".net"
}

New-Alias -Name "ronhowe" -Value Show-RonHowe -Force -Verbose
#endregion ronhowe

#region root
if (Test-Path -Path "C:\VSTS") {
    New-Variable -Name "Root" -Value "C:\VSTS" -Scope "Global" -Force -Verbose
    Set-Location -Path "C:\VSTS"
}
else {
    Write-Verbose "Skipping `$Root" -Verbose
}
#endregion root

Set-PSReadLineOption -PredictionViewStyle ListView
