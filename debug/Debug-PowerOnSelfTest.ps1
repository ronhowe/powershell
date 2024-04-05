[CmdletBinding()]
param (
    [string]
    $Value = "value"
)
begin {
    Write-Debug "Power-On Self-Test (1 of 5) => Debug Preference $DebugPreference" -Debug
    Write-Verbose "Power-On Self-Test (2 of 5) => Verbose Preference $VerbosePreference" -Verbose
    Write-Information "Power-On Self-Test (3 of 5) => Information Preference $InformationPreference" -InformationAction Continue
    Write-Warning "Power-On Self-Test (4 of 5) => Warning Preference $WarningPreference" -WarningAction Continue
    Write-Error "Power-On Self-Test (5 of 5) => Error Preference $ErrorActionPreference" -ErrorAction Continue

    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
