#requires -PSEdition "Core"
[CmdletBinding()]
param(
)
Describe "Testing Dependencies" {
    BeforeAll {
        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"
        $WarningPreference = "SilentlyContinue"
    }
    It "Dependency Is Latest @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
        Select-Object -ExpandProperty "Modules"
    ) {
        Find-Module -Name $Name -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $Version
    }
    It "Nuget Exists" {
        Get-Command -Name "nuget" -CommandType Application |
        Should -Not -BeNullOrEmpty
    }
}