#region requires
#requires -Module "Configuration"
#requires -Module "Metadata"
#requires -Module "InvokeBuild"
#requires -Module "ModuleBuilder"
#endregion requires

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = "0.0.0"
)
begin {}
process {
    #region tasks
    task full clean, build, import
    task . build
    #endregion tasks

    #region build
    task build {
        Write-Verbose "Building Module"
        $parameters = @{
            CopyPaths                  = @(
                "$PSScriptRoot\source\Shell.json",
                "$PSScriptRoot\source\Shell.nuspec",
                "$PSScriptRoot\source\LICENSE*"
            )
            OutputDirectory            = "$PSScriptRoot\bin"
            SourcePath                 = "$PSScriptRoot\source\Shell.psd1"
            UnversionedOutputDirectory = $true
            Version                    = $Version
        }
        Build-Module @parameters |
        Out-Null
    }
    #endregion  build

    #region clean
    task clean {
        Write-Verbose "Removing Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force

        Write-Verbose "Removing Output"
        Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue
    }
    #endregion clean

    #region import
    task import {
        Write-Verbose "Importing Module"
        Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force
    }
    #endregion import
}
end {}
