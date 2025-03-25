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

    $ErrorActionPreference = "Continue"

    Write-Verbose "Showing DevOps Tools"
    & "$Path\powershell\devops\Show-DevOpsTools.ps1" -Verbose

    Write-Verbose "Invoking Build Workflow"
    & "$Path\powershell\devops\Invoke-BuildWorkflow.ps1" -Verbose

    Write-Verbose "Running .NET List"
    dotnet list "$Path\dotnet\MySolution.sln" package --outdated

    Write-Verbose "Testing Dependencies"
    & "$Path\powershell\depend\Test-Dependencies.ps1"

    Write-Verbose "Debugging Module"
    & "$HOME\powershell\module\shell\Debug-Build.ps1"

    Write-Verbose "Running WinGet Upgrade"
    winget upgrade
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
