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

if (($host.Name -eq "Windows PowerShell ISE Host") -and (Get-Module -Name "ISESteroids" -ListAvailable)) {
    Write-Verbose "Importing ISESteroids" -Verbose
    Import-Module -Name "ISESteroids"
}
else {
    Write-Verbose "Skipping ISESteroids" -Verbose
}

if (($host.Name -ne "Visual Studio Code Host") -and (Get-Module -Name "posh-git" -ListAvailable)) {
    Write-Verbose "Importing posh-git" -Verbose
    Import-Module -Name "posh-git"
}
else {
    Write-Verbose "Skipping posh-git" -Verbose
}
