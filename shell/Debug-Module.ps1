#requires -PSEdition "Core"
#requires -Module "Pester"
[CmdletBinding()]
param(
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

    & "$PSScriptRoot\Import-Configuration.ps1" -Debug -Verbose

    Get-Module -Name $script:ModuleName |
    Remove-Module -Force -Verbose

    & "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

    # TODO - Getting an assembly already loaded error on some machines. -ErrorAction SilentlyContinue as workaround.
    Import-Module -Name "$PSScriptRoot\Output\Module\$script:ModuleName" -Force -Verbose -ErrorAction SilentlyContinue

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
