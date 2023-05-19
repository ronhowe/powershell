[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "~\repos\ronhowe\dotnet"
)
Measure-Command {
    try {
        Push-Location -Path $Path
        Write-Host "dotnet clean" -ForegroundColor Green
        dotnet clean
        if ($LASTEXITCODE -ne 0){
            throw "dotnet clean failed"
        }
        Write-Host "dotnet restore" -ForegroundColor Green
        dotnet restore
        if ($LASTEXITCODE -ne 0){
            throw "dotnet restore failed"
        }
        Write-Host "dotnet build" -ForegroundColor Green
        dotnet build
        if ($LASTEXITCODE -ne 0){
            throw "dotnet build failed"
        }
        Write-Host "dotnet test" -ForegroundColor Green
        dotnet test
        if ($LASTEXITCODE -ne 0){
            throw "dotnet test failed"
        }
    }
    catch {
        Write-Error $_
    }
    finally {
        Pop-Location
    }
}
