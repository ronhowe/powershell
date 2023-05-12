#requires -PSEdition "Core"
#requires -Module "Pester"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = "$PSScriptRoot\Output",

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
    . "$PSScriptRoot\Import-Configuration.ps1" -Path "$PSScriptRoot\Configuration.psd1" -Debug -Verbose

    Write-Verbose "Testing Requirements"
    Invoke-Pester -Path "$PSScriptRoot\Test-Requirements.ps1" -Output Detailed -PassThru |
    New-Variable -Name "result" -Force
    if ($result.FailedCount -gt 0) {
        Write-Error "Requirements Test Failed"
    }

    Write-Verbose "Installing Requirements"
    & "$PSScriptRoot\Install-Requirements.ps1" -Path "$PSScriptRoot\Requirements.psd1" -Repository $Repository -Scope "CurrentUser" -Debug -Verbose

    Write-Verbose "Removing Output"
    Remove-Item -Path $OutputPath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Starting Build"
    & "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

    Write-Verbose "Testing Module"
    Invoke-Pester -Path "$PSScriptRoot\Test-Module.ps1" -Output Detailed -PassThru |
    New-Variable -Name "result" -Force
    if ($result.FailedCount -gt 0) {
        Write-Error "Module Tests Failed"
    }

    Write-Verbose "Starting Package"
    & "$PSScriptRoot\Start-Package.ps1" -Debug -Verbose

    Write-Verbose "Unregistering Repository"
    Unregister-PSRepository -Name $script:ModuleName -ErrorAction SilentlyContinue

    Write-Verbose "Registering Repository"
    Register-PSRepository -Name $script:ModuleName -SourceLocation "$OutputPath\Package" -InstallationPolicy Trusted |
    Out-Null

    Write-Verbose "Removing Module"
    Get-Module -Name $script:ModuleName |
    Remove-Module -Force

    Write-Verbose "Finding Module"
    Find-Module -Name $script:ModuleName -RequiredVersion $script:ModuleVersion -Repository $script:ModuleName -WarningAction SilentlyContinue

    Write-Verbose "Installing Module"
    Install-Module -Name $script:ModuleName -RequiredVersion $script:ModuleVersion -Repository $script:ModuleName -AllowClobber -Force -WarningAction SilentlyContinue

    Write-Verbose "Importing Module"
    Import-Module -Name $script:ModuleName -RequiredVersion $script:ModuleVersion -Force -WarningAction SilentlyContinue

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
