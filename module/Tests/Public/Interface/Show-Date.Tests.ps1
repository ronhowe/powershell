#requires -PSEdition Core
#requires -Modules @{ ModuleName = "Pester"; ModuleVersion = "5.3.3" }
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingShowDate" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
        Mock -ModuleName $Name Write-Host { }
    }
    It "InvokeDoesNotThrow" {
        { Show-Date }
        | Should -Not -Throw
    }
    It "InvokeReturnsNothing" {
        Show-Date
        | Should -BeNullOrEmpty
    }
}