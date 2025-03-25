#requires -Module "WriteAscii"
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    function Write-Header {
        param(
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [string]
            $Header
        )
        Write-Host ("#" * 80) -ForegroundColor Blue
        Write-Ascii $Header
        Write-Host ("#" * 80) -ForegroundColor Blue
    }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Header -Header "dotnet"
    Write-Verbose "Getting .NET (dotnet) Version"
    if (Get-Command -Name "dotnet" -ErrorAction SilentlyContinue) {
        $(dotnet --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning ".NET (dotnet) Not Found"
    }

    Write-Header -Header "az"
    if (Get-Command -Name "az" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Azure CLI (az) Version"
        $(az --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Azure CLI (az) Not Found"
    }

    Write-Header -Header "bicep"
    if (Get-Command -Name "bicep" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Bicep CLI (bicep) Version"
        $(bicep --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Bicep CLI (bicep) Not Found"
    }

    Write-Header -Header "git"
    if (Get-Command -Name "git" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Git CLI (git) Version"
        $(git --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Git CLI (git) Not Found"
    }

    Write-Header -Header "gh"
    if (Get-Command -Name "gh" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting GitHub CLI (gh) Version"
        $(gh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "GitHub CLI (gh) Not Found"
    }

    Write-Header -Header "nuget"
    if (Get-Command -Name "nuget" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting NuGet (nuget) Version"
        $(nuget | Select-String -SimpleMatch "NuGet Version") |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "NuGet (nuget) Not Found"
    }

    Write-Header -Header "pwsh"
    if (Get-Command -Name "pwsh" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting PowerShell (pwsh) Version"
        $(pwsh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "PowerShell (pwsh) Not Found"
    }

    Write-Header -Header "python"
    if (Get-Command -Name "python" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Python (python) Version"
        $(python --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Python (python) Not Found"
    }

    Write-Header -Header "code"
    if (Get-Command -Name "code" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Visual Studio Code (code) Version"
        $(code --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Visual Studio Code (code) Not Found"
    }

    Write-Header -Header "wsl"
    if (Get-Command -Name "wsl" -ErrorAction SilentlyContinue) {
        Write-Verbose "Getting Windows Subsystem For Linux (wsl) Version"
        $(wsl --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Windows Subsystem For Linux (wsl) Not Found"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
