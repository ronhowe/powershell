@{
    Modules = @(
        # @{ Name = 'Az.Tools.Predictor' ; Version = '1.1.3' ; Repository = 'PSGallery' }, ## NOTE: This module ight be useful someday.
        # https://github.com/Azure/azure-powershell
        @{ Name = 'Az' ; Version = '13.4.0' ; Repository = 'PSGallery' },
        # https://github.com/torgro/cliMenu
        # @{ Name = 'CliMenu' ; Version = '1.0.52.0' ; Repository = 'PSGallery' }, ## NOTE: This module is failing to download.
        # https://github.com/PoshCode/Configuration
        @{ Name = 'Configuration' ; Version = '1.6.0' ; Repository = 'PSGallery' },
        # https://dbatools.io
        @{ Name = 'dbatools' ; Version = '2.1.30' ; Repository = 'PSGallery' },
        # https://learn.microsoft.com/en-us/powershell/module/iisadministration
        @{ Name = 'IISAdministration' ; Version = '1.1.0.0' ; Repository = 'PSGallery' },
        # https://github.com/dfinke/ImportExcel
        # @{ Name = 'ImportExcel' ; Version = '7.8.10' ; Repository = 'PSGallery' }, ## NOTE: This module might be useful someday.
        # https://github.com/nightroman/Invoke-Build
        @{ Name = 'InvokeBuild' ; Version = '5.12.2' ; Repository = 'PSGallery' },
        # https://github.com/PoshCode/Metadata
        @{ Name = 'Metadata' ; Version = '1.5.7' ; Repository = 'PSGallery' },
        # https://github.com/PowerShell/Crescendo
        @{ Name = 'Microsoft.PowerShell.Crescendo' ; Version = '1.1.0' ; Repository = 'PSGallery' },
        # https://github.com/powershell/secretmanagement
        @{ Name = 'Microsoft.PowerShell.SecretManagement' ; Version = '1.1.2' ; Repository = 'PSGallery' },
        # https://github.com/powershell/secretstore
        @{ Name = 'Microsoft.PowerShell.SecretStore' ; Version = '1.0.6' ; Repository = 'PSGallery' },
        # https://github.com/PoshCode/ModuleBuilder
        @{ Name = 'ModuleBuilder' ; Version = '3.1.7' ; Repository = 'PSGallery' },
        # https://github.com/pester/Pester
        @{ Name = 'Pester' ; Version = '5.7.1' ; Repository = 'PSGallery' },
        # https://github.com/dahlbyk/posh-git
        @{ Name = 'posh-git' ; Version = '1.1.0' ; Repository = 'PSGallery' },
        # https://github.com/justingrote/powerconfig
        # @{ Name = 'PowerConfig' ; Version = '0.1.6' ; Repository = 'PSGallery' }, ## NOTE: This module has not been updated with latest .NET and no longer works well.
        # https://github.com/RamblingCookieMonster/PSDepend
        @{ Name = 'PSDepend' ; Version = '0.3.8' ; Repository = 'PSGallery' },
        # https://github.com/adamdriscoll/pspolly
        @{ Name = 'PSPolly' ; Version = '0.0.2' ; Repository = 'PSGallery' },
        # https://github.com/PowerShell/PSReadLine
        @{ Name = 'PSReadLine' ; Version = '2.3.6' ; Repository = 'PSGallery' }
        # https://github.com/PowerShell/PSScriptAnalyzer
        @{ Name = 'PSScriptAnalyzer' ; Version = '1.24.0' ; Repository = 'PSGallery' },
        # @{ Name = 'PSWindowsUpdate' ; Version = '2.2.1.5' ; Repository = 'PSGallery' }, ## NOTE: This module is interesting, but doesn't work well remotely.
        # https://github.com/microsoft/SQLServerPSModule
        @{ Name = 'SqlServer' ; Version = '22.3.0' ; Repository = 'PSGallery' },
        # https://github.com/EliteLoser/WriteAscii
        @{ Name = 'WriteAscii' ; Version = '1.2.2.1' ; Repository = 'PSGallery' }
    )
}
