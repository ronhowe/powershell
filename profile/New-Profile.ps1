[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Creating Profile"
    New-Item -Path $profile -ItemType File -Force

    Write-Verbose "Setting Profile"
    "# auto-generated" |
    Set-Content -Path $profile -Force

    ". $(Resolve-Path -Path "$PSScriptRoot\profile.ps1")" |
    Add-Content -Path $profile

    Write-Verbose "Loading Profile"
    . $profile
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
