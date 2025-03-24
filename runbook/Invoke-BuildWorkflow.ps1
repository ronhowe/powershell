[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path = "$HOME\repos\ronhowe\dotnet"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    Write-Verbose "Pushing Location"
    Push-Location -Path $Path

    try {
        Write-Verbose "Running .NET Clean"
        dotnet clean
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Clean Failed"
        }
    
        Write-Verbose "Running .NET Restore"
        dotnet restore
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Restore Failed"
        }

        Write-Verbose "Running .NET Build"
        dotnet build --no-restore
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Build Failed"
        }

        Write-Verbose "Running .NET Test"
        dotnet test --no-build --nologo --filter "TestCategory=UnitTest" --verbosity normal
        if ($LASTEXITCODE -ne 0) {
            throw ".NET Test Failed"
        }
    }
    catch {
        Write-Error "Build Workflow Failed Because $($_.Message)"
    }
    finally {
        Write-Verbose "Popping Location"
        Pop-Location
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
