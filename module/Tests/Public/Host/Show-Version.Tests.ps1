[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\..\Source\Module.psd1"
)
Describe "Testing Show-Version" {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\..\Import-Configuration.ps1" -Path $Path
    
        Import-Module -Name "$PSScriptRoot\..\..\..\Output\Module\$Name" -Force
        Mock -ModuleName $Name Get-Version { return "x.x.x" }
        Mock -ModuleName $Name Write-Host { }
    }
    It "Invoke Does Not Throw" {
        { Show-Version } |
        Should -Not -Throw
    }
    It "Invoke Returns Nothing" {
        Show-Version |
        Should -BeNullOrEmpty
    }
    It "Invoke Mock" {
        Should -InvokeVerifiable
    }
}