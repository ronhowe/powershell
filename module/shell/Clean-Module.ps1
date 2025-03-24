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

    Write-Verbose "Removing Output"
    Remove-Item -Path "$PSScriptRoot\bin" -Recurse -Force -ErrorAction SilentlyContinue
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
