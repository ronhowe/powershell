Clear-Host
Test-Path "$HOME\repos\ronhowe\powershell\dsc"

Clear-Host
Set-Location -Path "$HOME\repos\ronhowe\powershell\dsc"

Clear-Host
Import-Module -Name "Pester"

Clear-Host
Invoke-Pester -Path ".\DevBoxConfiguration.Tests.ps1" -Output Detailed

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/?view=powershell-5.1
Clear-Host
Import-Module -Name "Microsoft.PowerShell.Diagnostics"

# Get-WinEvent : Could not retrieve information about the Microsoft-Windows-RemoteDesktopServices-RemoteFX-Synth3dvsp provider. Error: The specified resource type cannot be found in the image file.
Clear-Host
Get-WinEvent -ListProvider * -ErrorAction SilentlyContinue |
Select-Object -Property @("Name") |
Sort-Object -Property @("Name")

# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent?view=powershell-5.1
Clear-Host
$events = Get-WinEvent -LogName "Microsoft-Windows-Dsc/Operational" -MaxEvents 2
$events |
Select-Object -Property @("TimeCreated", "Message")

$jobId = Read-Host -Prompt "Enter Job ID"

Get-Content -Path "C:\Windows\system32\configuration\ConfigurationStatus\{$jobId}-0.details.json." -Raw

Get-DscLocalConfigurationManager
