[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetCatFact" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
        Mock -ModuleName $Name Invoke-Request { return "[{'fact':'mock','length':4}]" }
    }
    It "ReturnsCatFact" {
        Get-CatFact
        | Should -Be "mock"
    }
}