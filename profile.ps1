Write-Host "https://github.com/ronhowe/powershell/blob/main/profile.ps1" -ForegroundColor Green

$ProgressPreference = "SilentlyContinue"

Write-Verbose "PowerShell $($PSVersionTable.PSVersion.ToString())" -Verbose

Set-Location -Path $HOME

#region imports

if (Get-Module -Name "Az.Tools.Predictor" -ListAvailable) {
    Write-Verbose "Importing Az.Tools.Predictor" -Verbose
    Import-Module -Name "Az.Tools.Predictor"
}
else {
    Write-Verbose "Skipping Az.Tools.Predictor" -Verbose
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

#endregion imports

#region Set-LocationHome (aka home)

function Set-LocationHome {
    Set-Location -Path $HOME
}

New-Alias -Name "home" -Value Set-LocationHome -Force -Verbose

#endregion Set-LocationHome (aka home)

#region Set-LocationPowerShell (aka posh)

function Set-LocationPowerShell {
    if (Test-Path -Path "$HOME\repos\ronhowe\powershell") {
        Set-Location -Path "$HOME\repos\ronhowe\powershell"
    }
}

New-Alias -Name "posh" -Value Set-LocationPowerShell -Force -Verbose

#endregion Set-LocationPowerShell (aka posh)

#region Set-LocationRepos (aka repos)

function Set-LocationRepos {
    if (Test-Path -Path "$HOME\repos") {
        Set-Location -Path "$HOME\repos"
    }
}

New-Alias -Name "repos" -Value Set-LocationRepos -Force -Verbose

#endregion Set-LocationRepos (aka repos)

#region Set-PSReadLineHistory (aka oops)

function Set-PSReadLineHistory {
    notepad (Get-PSReadLineOption).HistorySavePath
}

New-Alias -Name "oops" -Value Set-PSReadLineHistory -Force -Verbose

#endregion Set-PSReadLineHistory (aka oops)

#region Show-New (aka new)

function Show-New {
    Clear-Host
    Show-RonHowe
    Set-LocationHome
}

New-Alias -Name "new" -Value Show-New -Force -Verbose

#endregion Show-New (aka new)

#region Show-RonHowe (aka ronhowe)

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

#endregion Show-RonHowe (aka ronhowe)

if ($PSVersionTable.PSEdition -eq "Core") {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue
}
else {
    Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue
}

# legacy build machine support
New-Variable -Name "Root" -Value "$HOME\repos" -Scope Global -Force -ErrorAction SilentlyContinue

function Set-PromptMinimal {
    function global:prompt { "> " }
}

New-Alias -Name "quiet" -Value Set-PromptMinimal -Force -Verbose

function Set-PromptOff {
    function global:prompt { " " }
}

New-Alias -Name "silence" -Value Set-PromptOff -Force -Verbose
