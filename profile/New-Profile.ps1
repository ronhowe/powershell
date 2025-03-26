[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Creating Profile"
    New-Item -Path $profile -ItemType File -Force

    Write-Host "Setting Profile"
    "# auto-generated`n. $(Resolve-Path -Path "$PSScriptRoot\profile.ps1")" |
    Set-Content -Path $profile -Force

    Write-Host "Loading Profile"
    . $profile
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
