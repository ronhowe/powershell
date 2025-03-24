#requires -Module "Configuration"
#requires -Module "Metadata"
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

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            "$PSScriptRoot\source\Shell.json",
            "$PSScriptRoot\source\Shell.nuspec",
            "$PSScriptRoot\LICENSE*"
        )
        OutputDirectory            = "$PSScriptRoot\bin"
        SourcePath                 = "$PSScriptRoot\source\Shell.psd1"
        UnversionedOutputDirectory = $true
        Version                    = $Version
    }
    Build-Module @parameters |
    Out-Null
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
