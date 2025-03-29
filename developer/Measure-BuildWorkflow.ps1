[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    Write-Output "Measuring Build Workflow"
    Measure-Command {
        & "$PSScriptRoot\Invoke-BuildWorkflow.ps1"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
