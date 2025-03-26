Describe "Resource Tests" {
    Context "Resource Currency Tests" {
        It "Asserting Resource Is Current @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
        $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources
        ) {
            Find-Module -Name $Name -Repository $Repository -Verbose:$false -WarningAction SilentlyContinue |
            Select-Object -ExpandProperty "Version" |
            Should -Be $Version
        }
    }
    Context "Resource Installation Tests" {
        It "Asserting Resource Is Installed @{ ModuleName = '<Name>' ; RequiredVersion = '<Version>' }" -ForEach `
        $(
        (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources
        ) {
            Get-Module -FullyQualifiedName @{ ModuleName = $Name ; RequiredVersion = $Version } -ListAvailable -Verbose:$false |
            Should -Not -BeNullOrEmpty
        }
    }
}
