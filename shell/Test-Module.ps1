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

    Write-Verbose "Importing Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1"

    Get-Module -Name $moduleName |
    Remove-Module -Force

    & "$PSScriptRoot\Start-Build.ps1"

    Invoke-Pester -Path $testsPath -Output Detailed

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
