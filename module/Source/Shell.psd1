@{
    RootModule           = 'Shell.psm1'
    ModuleVersion        = '0.0.0'
    # CompatiblePSEditions = @()
    GUID                 = '6c176522-14cb-41e7-b010-12df869d0133'
    Author               = 'Ron Howe'
    CompanyName          = 'Ron Howe.ORG'
    Copyright            = '(c) Ron Howe. All rights reserved.'
    Description          = 'A shell in PowerShell.'
    PowerShellVersion    = '7.3'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    # DotNetFrameworkVersion = ''
    # ClrVersion = ''
    # ProcessorArchitecture = ''
    RequiredModules      = @(
        @{
            ModuleName    = 'Az.Accounts'
            ModuleVersion = '2.9.0'
        },
        @{
            ModuleName    = 'CliMenu'
            ModuleVersion = '1.0.52.0'
        },
        @{
            ModuleName    = 'dbatools'
            ModuleVersion = '1.1.122'
        },
        @{
            ModuleName    = 'InvokeBuild'
            ModuleVersion = '5.9.10'
        },
        @{
            ModuleName    = 'Microsoft.PowerShell.SecretManagement'
            ModuleVersion = '1.1.2'
        },
        @{
            ModuleName    = 'Microsoft.PowerShell.SecretStore'
            ModuleVersion = '1.0.6'
        },
        @{
            ModuleName    = 'ModuleBuilder'
            ModuleVersion = '2.0.0'
        },
        @{
            ModuleName    = 'Pester'
            ModuleVersion = '5.4.1'
        },
        # @{
        #     ModuleName    = 'PowerConfig'
        #     ModuleVersion = '0.1.6'
        # },
        @{
            ModuleName    = 'posh-git'
            ModuleVersion = '1.1.0'
        },
        @{
            ModuleName    = 'SqlServer'
            ModuleVersion = '21.1.18256'
        },
        @{
            ModuleName    = 'WriteAscii'
            ModuleVersion = '1.2.2.1'
        }
    )
    # RequiredAssemblies = @()
    # ScriptsToProcess     = @()
    # TypesToProcess = @()
    # FormatsToProcess = @()
    # NestedModules = @()
    FunctionsToExport    = @()
    # CmdletsToExport      = @()
    VariablesToExport    = '*'
    AliasesToExport      = '*'
    # DscResourcesToExport = @()
    # ModuleList = @()
    # FileList = @()
    PrivateData          = @{
        PSData = @{
            Tags       = @('PSModule', 'Information')
            # LicenseUri = ''
            ProjectUri = 'https://github.com/ronhowe/shell'
            # IconUri = ''
            # ReleaseNotes = ''
            # Prerelease = ''
            # RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        }
    }
    # HelpInfoURI = ''
    DefaultCommandPrefix = ''
}