#requires -PSEdition "Core"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Source\Module.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory = "$PSScriptRoot\Output",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Repository = "PSGallery"
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
    Write-Debug "`$name=$name"
    Write-Debug "`$version=$version"

    Write-Verbose "Installing Build Requirements"
    & "$PSScriptRoot\Install-Requirements.ps1" -Path "$PSScriptRoot\Requirements.psd1" -Repository $Repository -Scope "CurrentUser" -Debug -Verbose

    Write-Verbose "Installing Module Requirements"
    & "$PSScriptRoot\Install-Requirements.ps1" -Path "$PSScriptRoot\Source\Requirements.psd1" -Repository $Repository -Scope "CurrentUser" -Debug -Verbose

    Write-Verbose "Removing Output Directory"
    Remove-Item -Path $OutputDirectory -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Testing Requirements"
    Invoke-Pester -Path "$PSScriptRoot\Test-Requirements.ps1" -Output Detailed -PassThru |
    New-Variable -Name "result" -Force
    if ($result.FailedCount -gt 0) {
        Write-Warning "Test Requirements Failed"
    }

    Write-Verbose "Starting Build"
    & "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

    Write-Verbose "Starting Package"
    & "$PSScriptRoot\Start-Package.ps1" -Debug -Verbose

    Write-Verbose "Unregistering Repository"
    Unregister-PSRepository -Name $name -ErrorAction SilentlyContinue

    Write-Verbose "Registering Repository"
    Register-PSRepository -Name $name -SourceLocation "$OutputDirectory\Package" -InstallationPolicy Trusted |
    Out-Null

    Write-Verbose "Removing Module"
    Get-Module -Name $name |
    Remove-Module -Force

    Write-Verbose "Finding Module"
    Find-Module -Name $name -RequiredVersion $version -Repository $name -WarningAction SilentlyContinue

    Write-Verbose "Installing Module"
    Install-Module -Name $name -RequiredVersion $version -Repository $name -AllowClobber -Force -WarningAction SilentlyContinue

    Write-Verbose "Importing Module"
    Import-Module -Name $name -RequiredVersion $version -Force -WarningAction SilentlyContinue

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
