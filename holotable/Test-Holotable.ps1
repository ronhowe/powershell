#requires -Module "Pester"
[CmdletBinding()]
param (
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Invoke-Pester -Path "$PSScriptRoot\Holotable.Tests.ps1" -Output Detailed
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
