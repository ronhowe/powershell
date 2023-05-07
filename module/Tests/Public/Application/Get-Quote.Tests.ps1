[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Get-Quote" {
    BeforeEach {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1" -Path $Path

        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Invoke-Request { return "[{'text':'mocktext','author':'mockauthor'}]" }
    }
    It "Returns Quote Text" {
        (Get-Quote).text |
        Should -Be "mocktext"
    }
    It "Returns Quote Author" {
        (Get-Quote).author |
        Should -Be "mockauthor"
    }
}