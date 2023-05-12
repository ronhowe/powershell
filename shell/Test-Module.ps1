#requires -PSEdition "Core"
#requires -Module "Pester"
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

    . "$PSScriptRoot\Import-Configuration.ps1" -Path "$PSScriptRoot\Configuration.psd1" -Debug -Verbose

    Get-Module -Name $name |
    Remove-Module -Force -Verbose

    & "$PSScriptRoot\Debug-Module.ps1" -Debug -Verbose

    Invoke-Pester -Path "$PSScriptRoot\Tests" -Output Detailed

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
