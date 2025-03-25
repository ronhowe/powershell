Describe "Resource Tests" {
    It "Asserting Resource Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources
    ) {
        Find-Module -Name $Name -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
        Select-Object -ExpandProperty "Version" |
        Should -Be $Version
    }
    It "Asserting Resource Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
    $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources
    ) {
        Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable -Verbose:$false |
        Should -Not -BeNullOrEmpty
    }
}
