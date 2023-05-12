#requires -PSEdition "Core"
[CmdletBinding()]
param (
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1"

    Write-Verbose "Removing Package Path"
    Remove-Item -Path $packagePath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Updating Nuspec Version"
    (Get-Content -Path "$modulePath\$moduleName\$moduleName.nuspec").Replace("<version>0.0.0<\version>", "<version>$moduleVersion)<\version>") |
    Set-Content "$modulePath\$moduleName\$moduleName.nuspec"

    Write-Verbose "Getting Nuget Path"
    $nugetPath = Get-Command -Name "nuget" -CommandType Application |
    Sort-Object -Property "Version" -Descending |
    Select-Object -ExpandProperty "Source" -First 1
    Write-Debug "`$nugetPath=$nugetPath"

    Write-Verbose "Packaging Module"
    $parameters = @{
        Path             = $nugetPath
        ArgumentList     = @(
            "pack",
            "$moduleName.nuspec",
            "-Exclude",
            "*.user.json",
            "-NoPackageAnalysis",
            "-OutputDirectory",
            "..\..\$packageDirectory", # nuget on linux workaround
            "-Verbosity",
            "detailed",
            "-Version",
            "$moduleVersion"
        )
        NoNewWindow      = $true
        Verbose          = $true
        Wait             = $true
        WorkingDirectory = Resolve-Path -Path "$modulePath\$moduleName"
    }
    for ([int]$i = 0; $i -lt $parameters.ArgumentList.Length; $i++) {
        Write-Debug "`$parameters.ArgumentList[$i]=$($parameters.ArgumentList[$i])"
    }
    try {
        Start-Process @parameters
    }
    catch {
        Write-Error "Nuget Pack Failed"
    }

    Write-Verbose "Test Package Path"
    if (Test-Path -Path $packagePath) {
        Get-ChildItem -Path $packagePath -Recurse
    }
    else {
        Write-Error "Package Path Not Found"
    }

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
