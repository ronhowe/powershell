[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Get-Weather" {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1" -Path $Path

        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
    }
    It "Returns Weather" {
        InModuleScope $Name {
            Mock Invoke-Request { return "mock" }
            Get-Weather |
            Should -Be "mock"
        }
    }
}