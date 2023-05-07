#requires -PSEdition "Core"
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Source\Module.psd1"
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

    Write-Verbose "Importing Configuration"
    $configuration = Import-PowerShellDataFile -Path $Path
    $name = $configuration.Name
    $version = $configuration.Version
    $certificatePath = $configuration.Certificate.Path
    $certificateThumbprint = $configuration.Certificate.Thumbprint
    Write-Debug "`$name=$name"
    Write-Debug "`$version=$version"
    Write-Debug "`$certificatePath=$certificatePath"
    Write-Debug "`$certificateThumbprint=$certificateThumbprint"
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
