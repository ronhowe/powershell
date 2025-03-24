[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Removing Module"
    Get-Module -Name "Shell" |
    Remove-Module -Force

    Write-Verbose "Rebuilding Module"
    & "$PSScriptRoot\Rebuild-Module.ps1" -Verbose

    Write-Verbose "Importing Module"
    Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force -Verbose

    Write-Verbose "Testing Module"
    & "$PSScriptRoot\Test-Module.ps1" -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
