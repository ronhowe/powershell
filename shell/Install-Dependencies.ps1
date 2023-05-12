#requires -PSEdition "Core"
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

    Write-Verbose "Importing Dependencies"
    Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
    Select-Object -ExpandProperty "Modules" |
    ForEach-Object {
        Write-Output @{ ModuleName = $_.Name ; RequiredVersion = $_.Version }
        if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable -Verbose:$false) {
            Write-Verbose "Skipping Module"
        }
        else {
            Write-Verbose "Installing Module"
            $parameters = @{
                AllowClobber       = $true
                ErrorAction        = "Stop"
                Force              = $true
                Name               = $name
                Repository         = $_.Repository
                RequiredVersion    = $_.Version
                Scope              = $_.Scope
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
