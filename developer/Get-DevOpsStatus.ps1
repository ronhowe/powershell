[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $Path = "$HOME\repos\ronhowe"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    . "$PSScriptRoot\Write-Header.ps1"

    $ErrorActionPreference = "Stop"

    Write-Header -Header "Tools"
    & "$Path\powershell\developer\Show-DevOpsTools.ps1" -Verbose

    Write-Header -Header "Packages"
    dotnet list "$Path\dotnet\MySolution.sln" package --outdated

    Write-Header -Header "Modules"
    & "$Path\powershell\dependency\module\Test-Modules.ps1"

    # Write-Header -Header "Resources"
    # & "$Path\powershell\dependency\resource\Test-Resources.ps1"

    Write-Header -Header "WinGet"
    winget upgrade
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
