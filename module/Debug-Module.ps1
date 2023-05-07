#requires -PSEdition Core
Clear-Host
Get-Module -Name "Shell" | Remove-Module -Force -Verbose
& "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose
Import-Module -Name "$PSScriptRoot\Output\Module\Shell" -Force -Verbose
