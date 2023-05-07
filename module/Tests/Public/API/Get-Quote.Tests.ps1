[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetQuote" {
    BeforeEach {
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Invoke-Request { return "[{'text':'mocktext','author':'mockauthor'}]" }
    }
    It "ReturnsQuoteText" {
        (Get-Quote).text |
        Should -Be "mocktext"
    }
    It "ReturnsQuoteAuthor" {
        (Get-Quote).author |
        Should -Be "mockauthor"
    }
}