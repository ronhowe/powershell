#requires -PSEdition Core
#requires -Modules @{ ModuleName = "Pester"; ModuleVersion = "5.3.3" }
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingAliases" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
    }
    It "Alias'<Name>'`"'Exists" -ForEach @(
        @{ Name = "shell" }
    ) {
        Get-Alias -Name $Name
        | Should -Not -BeNullOrEmpty
    }
}