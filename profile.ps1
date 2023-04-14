Write-Host "Universal PowerShell Profile" -ForegroundColor Green

New-Variable -Name "Root" -Value "C:\VSTS" -Scope "Global" -Force -Verbose
if (Test-Path -Path $Root) {
    Set-Location -Path $Root -Verbose
}

Write-Verbose "PowerShell $($PSVersionTable.PSVersion.ToString())"

if (($PSVersionTable.PSEdition -eq "Desktop") -and (Get-Module -Name "ISESteroids" -ListAvailable)) {
    Write-Verbose "Importing ISESteroids" -Verbose
    Import-Module -Name "ISESteroids"
}