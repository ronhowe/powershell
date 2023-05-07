[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\Source\Module.psd1"
)
Describe "Testing Aliases" {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1" -Path $Path
    }
    It "Alias Exists [<Name>]" -ForEach @(
        @{ Name = $name }
    ) {
        Get-Alias -Name $name |
        Should -Not -BeNullOrEmpty
    }
}