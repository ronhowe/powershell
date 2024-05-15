[CmdletBinding()]
param (
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

    Write-Verbose "Importing Dependencies Definition"
    (Import-PowerShellDataFile -Path "$PSScriptRoot\Dependencies.psd1").Modules |
    ForEach-Object {
        $moduleName = $_.Name
        $moduleVersion = $_.Version
        Get-InstalledModule -Name $moduleName -AllVersions |
        Where-Object { $_.Version -ne $moduleVersion } |
        Sort-Object -Property "Version" |
        ForEach-Object {
            if ($_.Name -ne "Pester" -and $_.Name -ne "PSReadLine") {
                Write-Host "Uninstalling @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }... " -NoNewline
                Uninstall-Module -Name $_.Name -RequiredVersion $_.Version
                Write-Host "OK" -ForegroundColor Green
            }
            else {
                Write-Warning "Skipping @{ ModuleName = $($_.Name) ; RequiredVersion = $($_.Version) }" -WarningAction Continue
            }
        }
    }

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
