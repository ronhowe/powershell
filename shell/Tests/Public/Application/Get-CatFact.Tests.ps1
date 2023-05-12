[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Get-CatFact" {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1" -Path $Path

        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Invoke-Request { return "[{'fact':'mock','length':4}]" }
    }
    It "Returns CatFact" {
        Get-CatFact |
        Should -Be "mock"
    }
}