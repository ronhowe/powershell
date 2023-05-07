[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetWeather" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
    }
    It "ReturnsWeather" {
        InModuleScope $Name {
            Mock Invoke-Request { return "mock" }
            Get-Weather |
            Should -Be "mock"
        }
    }
}