[CmdletBinding()]
param(
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
        Write-Verbose "Importing Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1"

        Import-Module -Name "$modulePath\$moduleName" -Force
    }
    It "Alias Exists [<Name>]" -ForEach @(
        @{ Name = $Alias }
    ) {
        Get-Alias -Name $Alias |
        Should -Not -BeNullOrEmpty
    }
}