#requires -PSEdition "Core"
#requires -Module "Pester"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Requirements.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Repository = "PSGallery"
)
Describe "Testing Requirements" {
    BeforeAll {
        $ErrorActionPreference = "Stop"
        $ProgressPreference = "SilentlyContinue"
        $WarningPreference = "SilentlyContinue"
    }
    It "Build Requirement {ModuleName='<ModuleName>';ModuleVersion='<ModuleVersion>'} Is Latest" -ForEach `
    $(
        Import-PowerShellDataFile -Path $Path |
        Select-Object -ExpandProperty "Modules"
    ) {
        Find-Module -Name $ModuleName -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $ModuleVersion
    }
    It "Module Requirement {ModuleName='<ModuleName>';ModuleVersion='<ModuleVersion>'} Is Latest" -ForEach `
    $(
        Import-PowerShellDataFile -Path "$PSScriptRoot\Source\Requirements.psd1" |
        Select-Object -ExpandProperty "Modules"
    ) {
        Find-Module -Name $ModuleName -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $ModuleVersion
    }
    It "Nuget Exists" {
        Get-Command -Name "nuget" -CommandType Application |
        Should -Not -BeNullOrEmpty
    }
}