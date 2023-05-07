#requires -PSEdition "Core"
#requires -Module "ModuleBuilder"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Source\Module.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory = "$PSScriptRoot\Output"
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
    $configuration = Import-PowerShellDataFile -Path $Path
    $name = $configuration.Name
    $version = $configuration.Version
    $certificatePath = $configuration.Certificate.Path
    $certificateThumbprint = $configuration.Certificate.Thumbprint
    Write-Debug "`$name=$name"
    Write-Debug "`$version=$version"
    Write-Debug "`$certificatePath=$certificatePath"
    Write-Debug "`$certificateThumbprint=$certificateThumbprint"

    Write-Verbose "Getting Module Directory"
    $moduleDirectory = "$OutputDirectory/Module"
    Write-Debug "`$moduleDirectory=$moduleDirectory"

    Write-Verbose "Removing Module Directory"
    Remove-Item -Path $moduleDirectory -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Building Module"
    $parameters = @{
        CopyPaths                  = @(
            "$PSScriptRoot\Install-Requirements.ps1",
            "$PSScriptRoot\LICENSE*",
            "$PSScriptRoot\README.md",
            "$PSScriptRoot\Requirements.psd1",
            "$PSScriptRoot\Source\$name.json",
            "$PSScriptRoot\Source\$name.nuspec"
        )
        OutputDirectory            = "$OutputDirectory\Module"
        SourcePath                 = "$PSScriptRoot\Source\$name.psd1"
        UnversionedOutputDirectory = $true
        Verbose                    = $true
        Version                    = $Version
    }
    Build-Module @parameters

    Write-Verbose "Removing Module Data Files"
    Get-Item -Path "$OutputDirectory\Module\$name\Module.psd1" |
    Remove-Item

    Write-Verbose "Getting Module Directory"
    if (Test-Path -Path $moduleDirectory) {
        Get-ChildItem -Path $moduleDirectory -Recurse
    }
    else {
        Write-Error "Module Directory Not Found"
    }

    if ($certificateThumbprint) {
        Write-Verbose "Getting Certificate"
        $certificate = Join-Path -Path $certificatePath -ChildPath $certificateThumbprint |
        Get-ChildItem
    
        Write-Verbose "Signing Module"
        Get-ChildItem -Path "$OutputDirectory\Module\$name\*.ps*" |
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
