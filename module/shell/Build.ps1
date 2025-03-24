#requires -Module "ModuleBuilder"

[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string]
    $Version = "0.0.0"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Task Debug Remove, Clean, Build, Import
    Task . Clean, Build

    Task Build {
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

    Task Clean {
        Write-Verbose "Removing Output"
        Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Task Remove {
        Write-Verbose "Removing Module"
        Get-Module -Name "Shell" |
        Remove-Module -Force
    }

    Task Import {
        Write-Verbose "Importing Module"
        Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
