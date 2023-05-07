[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingShowReady" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Write-Host { }
    }
    It "InvokeDoesNotThrow" {
        { Show-Ready } |
        Should -Not -Throw
    }
    It "InvokeReturnsNothing" {
        Show-Ready |
        Should -BeNullOrEmpty
    }
}