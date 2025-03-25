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
    Write-Verbose "Showing DevOps Tools"
    & "$Path\powershell\developer\Show-DevOpsTools.ps1" -Verbose

    Write-Header -Header "Build"
    Write-Verbose "Invoking Build Workflow"
    & "$Path\powershell\developer\Invoke-BuildWorkflow.ps1" -Verbose

    Write-Header -Header "Packages"
    Write-Verbose "Running .NET List"
    dotnet list "$Path\dotnet\MySolution.sln" package --outdated

    Write-Header -Header "Dependencies"
    Write-Verbose "Testing Dependencies"
    & "$Path\powershell\depend\Test-Dependencies.ps1"

    Write-Header -Header "Module"
    Write-Verbose "Debugging Module"
    & "$Path\powershell\module\shell\Debug-Build.ps1"

    Write-Header -Header "WinGet"
    Write-Verbose "Running WinGet Upgrade"
    winget upgrade
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
