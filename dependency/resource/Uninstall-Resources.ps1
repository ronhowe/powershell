#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    (Import-PowerShellDataFile -Path "$PSScriptRoot\Resources.psd1").Resources |
    ForEach-Object {
        $moduleName = $_.Name
        $moduleVersion = $_.Version
        Write-Host "Getting Installed Resources @{ ModuleName = $moduleName }"
        Get-InstalledModule -Name $moduleName -AllVersions |
        Where-Object { $_.Version -ne $moduleVersion } |
        Sort-Object -Property "Version" |
        ForEach-Object {
            if ($_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
                Write-Host "Uninstalling Resource @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
                Uninstall-Module -Name $_.Name -RequiredVersion $_.Version
            }
            else {
                Write-Warning "Skipping Resource @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }"
            }
        }
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
