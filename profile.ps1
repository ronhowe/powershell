Write-Host "https://github.com/ronhowe/powershell/blob/main/profile.ps1" -ForegroundColor Green

Write-Verbose "PowerShell $($PSVersionTable.PSVersion.ToString())" -Verbose

New-Variable -Name "Root" -Value "C:\VSTS" -Scope "Global" -Force -Verbose
if (Test-Path -Path $Root) {
    Set-Location -Path $Root -Verbose
}

if (($host.Name -eq "Windows PowerShell ISE Host") -and (Get-Module -Name "ISESteroids" -ListAvailable)) {
    Write-Verbose "Importing ISESteroids" -Verbose
    Import-Module -Name "ISESteroids" | Out-Null
}

if (($host.Name -ne "Visual Studio Code Host") -and (Get-Module -Name "posh-git" -ListAvailable)) {
    Write-Verbose "Importing posh-git" -Verbose
    Import-Module -Name "posh-git"
}
