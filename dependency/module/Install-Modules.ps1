[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("AllUsers", "CurrentUser")]
    [string]
    $Scope = "CurrentUser"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    (Import-PowerShellDataFile -Path "$PSScriptRoot\Modules.psd1").Modules |
    ForEach-Object {
        if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable) {
            Write-Host "Skipping Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) } ; Already Installed"
        }
        else {
            Write-Host "Installing Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
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
