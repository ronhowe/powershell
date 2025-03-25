#requires -Module "Pester"
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Invoke-Pester -Path "$PSScriptRoot\Dependencies.Tests.ps1" -Output Detailed
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
