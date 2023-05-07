[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingGetQuote" {
    BeforeEach {
        
        # Import-Module -Name "$PSScriptRoot/../../../Output/Modules/$Name" -Force
        # Mock -CommandName Invoke-Request -MockWith { return "[{'text':'mock','author':'mock'}]" }
        
    }
    It "ReturnsQuoteText" {
        #. "C:\Users\ronhowe\repos\ronhowe\shell\Source\Public\API\Get-Quote.ps1"
        #Mock -CommandName Invoke-Request -MockWith { return "[{'text':'mock','author':'mock'}]" }
        (Get-Quote).text
        | Should -Be "mock"
    }
    # It "ReturnsQuoteAuthor" {
    #     (Get-Quote).author
    #     | Should -Be "mock"
    # }
}