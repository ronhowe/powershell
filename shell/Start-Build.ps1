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

    Write-Verbose "Importing Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1"

    Write-Verbose "Removing Module Path"
    Remove-Item -Path $modulePath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            "$sourcePath\$moduleName.json",
            "$sourcePath\$moduleName.nuspec",
            "$PSScriptRoot\Dependencies.psd1",
            "$PSScriptRoot\Install-Dependencies.ps1",
            "$PSScriptRoot\LICENSE*",
            "$PSScriptRoot\README.md"
        )
        OutputDirectory            = $modulePath
        SourcePath                 = "$sourcePath\$moduleName.psd1"
        UnversionedOutputDirectory = $true
        Verbose                    = $true
        Version                    = $moduleVersion
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
        Get-ChildItem -Path "$modulePath\$certificateThumbprint\*.ps*" |
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
