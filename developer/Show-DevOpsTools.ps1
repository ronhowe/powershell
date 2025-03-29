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

    Write-Host "Getting .NET (dotnet) Version"
    if (Get-Command -Name "dotnet" -ErrorAction SilentlyContinue) {
        $(dotnet --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning ".NET (dotnet) Not Found"
    }

    Write-Host "Getting Azure CLI (az) Version"
    if (Get-Command -Name "az" -ErrorAction SilentlyContinue) {
        $(az --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Azure CLI (az) Not Found"
    }

    Write-Host "Getting Bicep CLI (bicep) Version"
    if (Get-Command -Name "bicep" -ErrorAction SilentlyContinue) {
        $(bicep --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Bicep CLI (bicep) Not Found"
    }

    Write-Host "Getting Git CLI (git) Version"
    if (Get-Command -Name "git" -ErrorAction SilentlyContinue) {
        $(git --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Git CLI (git) Not Found"
    }

    Write-Host "Getting GitHub CLI (gh) Version"
    if (Get-Command -Name "gh" -ErrorAction SilentlyContinue) {
        $(gh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "GitHub CLI (gh) Not Found"
    }

    Write-Host "Getting NuGet (nuget) Version"
    if (Get-Command -Name "nuget" -ErrorAction SilentlyContinue) {
        $(nuget | Select-String -SimpleMatch "NuGet Version") |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "NuGet (nuget) Not Found"
    }

    Write-Host "Getting PowerShell (pwsh) Version"
    if (Get-Command -Name "pwsh" -ErrorAction SilentlyContinue) {
        $(pwsh --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "PowerShell (pwsh) Not Found"
    }

    Write-Host "Getting Python (python) Version"
    if (Get-Command -Name "python" -ErrorAction SilentlyContinue) {
        $(python --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Python (python) Not Found"
    }

    Write-Host "Getting Visual Studio Code (code) Version"
    if (Get-Command -Name "code" -ErrorAction SilentlyContinue) {
        $(code --version) |
        Out-String |
        Write-Host
    }
    else {
        Write-Warning "Visual Studio Code (code) Not Found"
    }

    Write-Host "Getting Windows Subsystem For Linux (wsl) Version"
    if (Get-Command -Name "wsl" -ErrorAction SilentlyContinue) {
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
