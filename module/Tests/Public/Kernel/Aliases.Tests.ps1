[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingAliases" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
    }
    It "Alias'<Name>'`"'Exists" -ForEach @(
        @{ Name = "shell" }
    ) {
        Get-Alias -Name $Name |
        Should -Not -BeNullOrEmpty
    }
}