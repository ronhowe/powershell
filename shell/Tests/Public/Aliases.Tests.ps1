[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\Source\Module.psd1"
)
Describe "Testing Aliases" -ForEach @(
    # sync with Aliases.ps1
    # sync with Aliases.Tests.ps1
    # sync with Show-Help.ps1
    @{ Alias = "catfact" }
    @{ Alias = "date" }
    @{ Alias = "help" }
    @{ Alias = "logo" }
    @{ Alias = "quote" }
    @{ Alias = "ready" }
    @{ Alias = "version" }
    @{ Alias = "weather" }
    @{ Alias = $SHELL_CODENAME }
) {
    BeforeAll {
        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1" -Path $Path

        Import-Module -Name "$PSScriptRoot\..\..\Output\Module\$Name" -Force
    }
    It "Alias Exists [<Name>]" -ForEach @(
        @{ Name = $Alias }
    ) {
        Get-Alias -Name $Alias |
        Should -Not -BeNullOrEmpty
    }
}