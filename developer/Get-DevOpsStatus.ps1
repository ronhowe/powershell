[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $Path = "$HOME\repos\ronhowe"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    . "$PSScriptRoot\Write-Header.ps1"

    Write-Header -Header "Tools"
    & "$Path\powershell\developer\Get-DevOpsTools.ps1" -Verbose
    Read-Host -Prompt "Press Enter To continue"

    Write-Header -Header "Packages"
    dotnet list "$Path\dotnet\MySolution.sln" package --outdated
    Read-Host -Prompt "Press Enter To continue"

    Write-Header -Header "Modules"
    & "$Path\powershell\dependency\module\Test-Modules.ps1"
    Read-Host -Prompt "Press Enter To continue"

    # Write-Header -Header "Resources"
    # & "$Path\powershell\dependency\resource\Test-Resources.ps1"

    Write-Header -Header "WinGet"
    winget upgrade
    Read-Host -Prompt "Press Enter To continue"

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
