[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "Testing Get-CatFact" {
    BeforeAll {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Invoke-Request { return "[{'fact':'mock','length':4}]" }
    }
    It "Returns CatFact" {
        Get-CatFact |
        Should -Be "mock"
    }
}