@{
    Modules = @(
        ## NOTE: This module ight be useful someday.
        # @{ Name = 'Az.Tools.Predictor' ; Version = '1.1.3' ; Repository = 'PSGallery' },
        @{ Name = 'Az' ; Version = '13.4.0' ; Repository = 'PSGallery' },
        ## NOTE: This module is failing to download.
        # @{ Name = 'CliMenu' ; Version = '1.0.52.0' ; Repository = 'PSGallery' },
        @{ Name = 'Configuration' ; Version = '1.6.0' ; Repository = 'PSGallery' },
        @{ Name = 'dbatools' ; Version = '2.1.30' ; Repository = 'PSGallery' },
        ## NOTE: This module might be useful someday.
        # @{ Name = 'ImportExcel' ; Version = '7.8.10' ; Repository = 'PSGallery' },
        @{ Name = 'InvokeBuild' ; Version = '5.12.2' ; Repository = 'PSGallery' },
        @{ Name = 'Metadata' ; Version = '1.5.7' ; Repository = 'PSGallery' },
        @{ Name = 'Microsoft.PowerShell.Crescendo' ; Version = '1.1.0' ; Repository = 'PSGallery' },
        @{ Name = 'Microsoft.PowerShell.SecretManagement' ; Version = '1.1.2' ; Repository = 'PSGallery' },
        @{ Name = 'Microsoft.PowerShell.SecretStore' ; Version = '1.0.6' ; Repository = 'PSGallery' },
        @{ Name = 'ModuleBuilder' ; Version = '3.1.7' ; Repository = 'PSGallery' },
        @{ Name = 'Pester' ; Version = '5.7.1' ; Repository = 'PSGallery' },
        @{ Name = 'posh-git' ; Version = '1.1.0' ; Repository = 'PSGallery' },
        ## NOTE: This module has not been updated with latest .NET and no longer works well.
        # @{ Name = 'PowerConfig' ; Version = '0.1.6' ; Repository = 'PSGallery' },
        @{ Name = 'PSDepend' ; Version = '0.3.8' ; Repository = 'PSGallery' },
        @{ Name = 'PSPolly' ; Version = '0.0.2' ; Repository = 'PSGallery' },
        @{ Name = 'PSReadLine' ; Version = '2.3.6' ; Repository = 'PSGallery' }
        @{ Name = 'PSScriptAnalyzer' ; Version = '1.24.0' ; Repository = 'PSGallery' },
        ## NOTE: This module is interesting, but doesn't work well remotely.
        # @{ Name = 'PSWindowsUpdate' ; Version = '2.2.1.5' ; Repository = 'PSGallery' },
        @{ Name = 'SqlServer' ; Version = '22.3.0' ; Repository = 'PSGallery' },
        @{ Name = 'WriteAscii' ; Version = '1.2.2.1' ; Repository = 'PSGallery' }
    )
}
