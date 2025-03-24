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

    Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1" |
    Select-Object -ExpandProperty "Modules" |
    ForEach-Object {
        if (Get-Module -FullyQualifiedName @{ ModuleName = $_.Name ; RequiredVersion = $_.Version } -ListAvailable -Verbose:$false) {
            Write-Verbose "Skipping Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) } ; Already Installed"
        }
        else {
            Write-Verbose "Installing Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
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
