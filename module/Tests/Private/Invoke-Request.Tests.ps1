[CmdletBinding()]
param()
Describe "TestingInvokeRequest" {
    BeforeAll {
        . "$PSScriptRoot/../../Source/Private/Invoke-Request.ps1"
    }
    It "UriInvalidThrows" {
        { Invoke-Request -Uri "https://b276ec7d-1d97-46a1-af03-4a0fbb646b63" }
        | Should -Throw
    }
    It "SwitchPresentReturns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly
        | Should -Not -BeNullOrEmpty
    }
    It "SwitchAbsentReturns" {
        Invoke-Request -Uri "https://catfact.ninja/fact"
        | Should -Not -BeNullOrEmpty
    }
    It "Foo" {
        Invoke-Request -Uri "https://nan"
        | Should -Throw
    }
}