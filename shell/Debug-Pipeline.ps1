#requires -PSEdition "Core"
#requires -Module "Pester"
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
    . "$PSScriptRoot\Import-Configuration.ps1" -Debug -Verbose

    Write-Verbose "Installing Dependencies"
    & "$PSScriptRoot\Install-Dependencies.ps1" -Debug -Verbose

    Write-Verbose "Testing Dependencies"
    Invoke-Pester -Path "$PSScriptRoot\Test-Dependencies.ps1" -Output Detailed -PassThru |
    New-Variable -Name "result" -Force
    if ($result.FailedCount -gt 0) {
        Write-Error "Dependencies Tests Failed"
    }

    Write-Verbose "Removing Output"
    Remove-Item -Path $outputPath -Recurse -Force -ErrorAction SilentlyContinue

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
    Unregister-PSRepository -Name $moduleName -ErrorAction SilentlyContinue

    Write-Verbose "Registering Repository"
    Register-PSRepository -Name $moduleName -SourceLocation $packagePath -InstallationPolicy Trusted |
    Out-Null

    Write-Verbose "Removing Module"
    Get-Module -Name $moduleName |
    Remove-Module -Force

    Write-Verbose "Finding Module"
    Find-Module -Name $moduleName -RequiredVersion $moduleVersion -Repository $moduleName -WarningAction SilentlyContinue

    Write-Verbose "Installing Module"
    Install-Module -Name $moduleName -RequiredVersion $moduleVersion -Repository $moduleName -Scope CurrentUser -AllowClobber -Force -WarningAction SilentlyContinue

    Write-Verbose "Importing Module"
    Import-Module -Name $moduleName -RequiredVersion $moduleVersion -Force -WarningAction SilentlyContinue

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
