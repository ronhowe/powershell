[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ModuleName
)

$allVersions = Get-InstalledModule $ModuleName -AllVersions

$latestVersion = $allVersions |
Sort-Object Version |
Select-Object -Last 1

$allVersions |
Where-Object { $_.Version -ne $latestVersion.Version } |
ForEach-Object { Uninstall-Module -Name $ModuleName -RequiredVersion $_.Version }
