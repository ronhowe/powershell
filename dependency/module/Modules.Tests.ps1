Describe "Modules Tests" {
    It "Asserting Module Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Modules.psd1").Modules
    ) {
        Find-Module -Name $Name -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $Version
    }
    It "Asserting Module Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Modules.psd1").Modules
    ) {
        Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable -Verbose:$false |
        Should -Not -BeNullOrEmpty
    }
}
