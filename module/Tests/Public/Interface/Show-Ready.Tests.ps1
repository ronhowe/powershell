#requires -PSEdition Core
#requires -Modules @{ ModuleName = "Pester"; ModuleVersion = "5.3.3" }
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingShowReady" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
        Mock -ModuleName $Name Write-Host { }
    }
    It "InvokeDoesNotThrow" {
        { Show-Ready }
        | Should -Not -Throw
    }
    It "InvokeReturnsNothing" {
        Show-Ready
        | Should -BeNullOrEmpty
    }
}