BeforeAll {
    . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}
Describe "Get-MyService Tests" {
    Context "Testing MyInput" {
        It "Asserting MyService Returns $false" {
            Get-MyService -MyInput $false |
            Should -BeFalse
        }
        It "Asserting MyService Returns $true" {
            Get-MyService -MyInput $true |
            Should -BeTrue
        }
    }
}
