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

    Write-Output "Creating Profile"
    New-Item -Path $profile -ItemType File -Force |
    Out-Null

    Write-Output "Setting Profile"
    "# auto-generated`n$(Resolve-Path -Path "$PSScriptRoot\profile.ps1") |`nOut-Null" |
    Set-Content -Path $profile -Force

    Write-Output "Loading Profile"
    . $profile
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
