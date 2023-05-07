#requires -PSEdition Core
#requires -Modules @{ ModuleName = "Pester"; ModuleVersion = "5.3.3" }
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetVersion" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
        Mock -ModuleName $Name Get-Module { return @{ Version = "x.x.x" } }
    }
    It "ReturnsExpected" {
        Get-Version
        | Should -Be "x.x.x"
    }
}