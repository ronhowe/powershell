#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Setting Execution Policy"
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force -ErrorAction SilentlyContinue

    Write-Verbose "Installing NuGet Package Provider"
    Install-PackageProvider -Name "nuget" -Force

    Write-Verbose "Installing Pester Module"
    Install-Module -Name "Pester" -Repository "PSGallery" -RequiredVersion "5.7.1" -Scope AllUsers -SkipPublisherCheck -Force

    Write-Warning "Restart PowerShell" -WarningAction
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
