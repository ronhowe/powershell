#requires -Module "Pester"
#requires -PSEdition "Core"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path = "$PSScriptRoot\Modules.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateSet("AllUsers", "CurrentUser")]
    [string]
    $Scope = "AllUsers"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    (Import-PowerShellDataFile -Path $Path).Modules |
    ForEach-Object {
        if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable -Verbose:$false) {
            Write-Output "Skipping Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) } ; Already Installed"
        }
        else {
            Write-Output "Installing Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
            $parameters = @{
                AllowClobber       = $true
                Force              = $true
                Name               = $_.Name
                Repository         = $_.Repository
                RequiredVersion    = $_.Version
                Scope              = $Scope
                SkipPublisherCheck = $true
            }
            Install-Module @parameters
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
