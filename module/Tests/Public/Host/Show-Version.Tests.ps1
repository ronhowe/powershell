[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingShowVersion" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Get-Version { return "x.x.x" }
        Mock -ModuleName $Name Write-Host { }
    }
    It "InvokeDoesNotThrow" {
        { Show-Version } |
        Should -Not -Throw
    }
    It "InvokeReturnsNothing" {
        Show-Version |
        Should -BeNullOrEmpty
    }
    It "InvokeMock" {
        Should -InvokeVerifiable
    }
}