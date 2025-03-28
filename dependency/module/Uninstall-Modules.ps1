#requires -Module "Pester"
#requires -PSEdition "Core"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    (Import-PowerShellDataFile -Path "$PSScriptRoot\Modules.psd1").Modules |
    ForEach-Object {
        $moduleName = $_.Name
        $moduleVersion = $_.Version
        Write-Host "Getting Installed Modules @{ ModuleName = $moduleName }"
        Get-InstalledModule -Name $moduleName -AllVersions |
        Where-Object { $_.Version -ne $moduleVersion } |
        Sort-Object -Property "Version" |
        ForEach-Object {
            if ($_.Name -ne "Metadata" -and $_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
                Write-Host "Uninstalling Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
                Uninstall-Module -Name $_.Name -RequiredVersion $_.Version
            }
            else {
                ## TODO: Understand why Metadata, Pester and PSReadLine are tricky to uninstall.
                Write-Warning "Skipping Module @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
            }
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
