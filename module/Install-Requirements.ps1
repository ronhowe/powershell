#requires -PSEdition "Core"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Requirements.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Repository = "PSGallery",

    [Parameter(Mandatory = $false)]
    [ValidateSet("AllUsers", "CurrentUser")]
    [string]$Scope = "CurrentUser"
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

    Write-Verbose "Invoking Import-Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1" -Path $Path

    Write-Verbose "Installing Modules"
    $requirements.Modules |
    ForEach-Object {
        Write-Verbose "Getting Module"
        $moduleName = $_.ModuleName
        $moduleVersion = $_.ModuleVersion
        Write-Debug "`$moduleName=$moduleName"
        Write-Debug "`$moduleVersion=$moduleVersion"
    
        if (-not (Get-Module -FullyQualifiedName $_ -ListAvailable -Verbose:$false)) {
            Write-Verbose "Installing Module"
            $parameters = @{
                AllowClobber       = $true
                ErrorAction        = "Stop"
                Force              = $true
                Name               = $moduleName
                Repository         = $Repository
                RequiredVersion    = $moduleVersion
                Scope              = $Scope
                SkipPublisherCheck = $true
                Verbose            = $false
                WarningAction      = "SilentlyContinue"
            }
            Install-Module @parameters
        }
    }

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
