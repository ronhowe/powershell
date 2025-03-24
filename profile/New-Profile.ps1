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

    Write-Debug "`$profile = $profile"

    Write-Verbose "Creating Profile"
    New-Item -Path $profile -ItemType File -Force |
    Out-Null

    Write-Verbose "Setting Profile"
    '# auto-generated' |
    Set-Content -Path $profile -Force

    ". $(Resolve-Path -Path "$PSScriptRoot\Start-Profile.ps1")" |
    Add-Content -Path $profile

    Write-Verbose "Starting Profile"
    . $profile
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
