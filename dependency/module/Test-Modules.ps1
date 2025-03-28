#requires -Module "Pester"
#requires -PSEdition "Core"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Invoking Pester"
    Invoke-Pester -Path "$PSScriptRoot\Modules.Tests.ps1" -Output Detailed
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
