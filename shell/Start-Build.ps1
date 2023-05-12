#requires -PSEdition "Core"
#requires -Module "ModuleBuilder"
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Build"
    $configuration = Import-PowerShellDataFile -Path "$PSScriptRoot\Build.psd1"

    Write-Verbose "Importing Configuration"
    $configuration = Import-PowerShellDataFile -Path "$PSScriptRoot\Configuration.psd1"

    $moduleName = $configuration.ModuleName
    $moduleVersion = $configuration.ModuleVersion
    $certificateThumbprint = $configuration.Certificate.Thumbprint
    $certificatePath = $configuration.Certificate.Path
    Write-Debug "`$moduleName=$moduleName"
    Write-Debug "`$moduleVersion=$moduleVersion"
    Write-Debug "`$certificateThumbprint=$certificateThumbprint"
    Write-Debug "`$certificatePath=$certificatePath"

    Write-Verbose "Getting Module Path"
    $modulePath = "$OutputPath\Module"
    Write-Debug "`$modulePath=$modulePath"

    Write-Verbose "Removing Module Path"
    Remove-Item -Path $modulePath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            (Resolve-Path -Path "$PSScriptRoot\Install-Requirements.ps1"),
            "$PSScriptRoot\LICENSE*",
            "$PSScriptRoot\README.md",
            "$PSScriptRoot\Requirements.psd1",
            "$PSScriptRoot\Source\$($configuration.ModuleName).json",
            "$PSScriptRoot\Source\$($configuration.ModuleName).nuspec"
        )
        OutputDirectory            = "$OutputPath\Module"
        SourcePath                 = (Resolve-Path -Path "$PSScriptRoot\Source\$moduleName.psd1")
        UnversionedOutputDirectory = $true
        Verbose                    = $true
        Version                    = "0.0.0" # $script:ModuleVersion
    }
    Build-Module @parameters

    Write-Verbose "Testing Module Path"
    if (Test-Path -Path $modulePath) {
        Get-ChildItem -Path $modulePath -Recurse
    }
    else {
        Write-Error "Module Path Not Found"
    }

    if ($certificateThumbprint) {
        Write-Verbose "Getting Certificate"
        $certificate = Join-Path -Path $certificatePath -ChildPath $certificateThumbprint |
        Get-ChildItem

        Write-Verbose "Signing Module"
        Get-ChildItem -Path "$OutputPath\Module\$certificateThumbprint\*.ps*" |
        ForEach-Object {
            Set-AuthenticodeSignature -Certificate $certificate -FilePath $_
        } |
        Out-Null
    }
    else {
        Write-Warning "Skipping Signing Module" -WarningAction Continue
    }

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
