[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Cleaning Module"
    & "$PSScriptRoot\Clean-Module.ps1"

    Write-Verbose "Building Module"
    & "$PSScriptRoot\Build-Module.ps1"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
