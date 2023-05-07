[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingInvokeRequest" {
    BeforeAll {
        Write-Debug $(Resolve-Path -Path "$PSScriptRoot\..\..\Output\Module\$Name")
        Import-Module -Name "$PSScriptRoot\..\..\Output\Module\$Name" -Force

        . "$PSScriptRoot\..\..\Source\Private\Invoke-Request.ps1"
    }
    It "UriInvalidThrows" {
        { Invoke-Request -Uri "https://b276ec7d-1d97-46a1-af03-4a0fbb646b63" } |
        Should -Throw
    }
    It "SwitchPresentReturns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        Should -Not -BeNullOrEmpty
    }
    It "SwitchAbsentReturns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" |
        Should -Not -BeNullOrEmpty
    }
}