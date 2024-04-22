[CmdletBinding()]
param (
    [string]
    $Why = "Power-On Self-Test"
)
begin {
    Write-Debug "Power-On Self-Test (1 of 5) => `$DebugPreference = $DebugPreference" -Debug
    Write-Verbose "Power-On Self-Test (2 of 5) => `$VerbosePreference = $VerbosePreference" -Verbose
    Write-Information "Power-On Self-Test (3 of 5) => `$InformationPreference = $InformationPreference" -InformationAction Continue
    Write-Warning "Power-On Self-Test (4 of 5) => `$WarningPreference = $WarningPreference" -WarningAction Continue
    Write-Error "Power-On Self-Test (5 of 5) => `$ErrorActionPreference = $ErrorActionPreference" -ErrorAction Continue

    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Host "WHO"
    Write-Host $env:USERNAME

    Write-Host "WHAT"
    Write-Host $PSVersionTable

    Write-Host "WHERE"
    Write-Host $env:COMPUTERNAME

    Write-Host "WHEN"
    Write-Host (Get-Date)

    Write-Host "WHY"
    Write-Host $Why

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
