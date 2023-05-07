[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetVersion" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Get-Module { return @{ Version = "x.x.x" } }
    }
    It "ReturnsExpected" {
        Get-Version
        | Should -Be "x.x.x"
    }
}