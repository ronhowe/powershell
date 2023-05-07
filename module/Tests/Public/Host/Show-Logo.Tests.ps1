[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Show-Logo" {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1" -Path $Path

        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        # Mock -ModuleName $Name Write-Host { }
    }
    It "Invoke Does Not Throw" {
        { Show-Logo } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Logo |
        Should -BeNullOrEmpty
    }
}