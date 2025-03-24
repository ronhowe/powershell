#requires -Module "Configuration"
#requires -Module "Metadata"
#requires -Module "InvokeBuild"
#requires -Module "ModuleBuilder"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = "0.0.0"
)

task rebuild clean, build
task . clean, build

task clean {
    Write-Verbose "Removing Module"
    Get-Module -Name "Shell" |
    Remove-Module -Force

    Write-Verbose "Removing Output"
    Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue
}

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
