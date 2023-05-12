#requires -PSEdition "Core"
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Configuration.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath = "$PSScriptRoot\Output"
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
    $configuration = Import-PowerShellDataFile -Path $Path

    Write-Verbose "Getting Module Path"
    $modulePath = "$OutputPath\Module"
    Write-Debug "`$modulePath=$modulePath"

    Write-Verbose "Getting Package Path"
    $packagePath = "$OutputPath\Package"
    Write-Debug "`$packagePath=$packagePath"

    Write-Verbose "Removing Package Path"
    Remove-Item -Path $packagePath -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Updating Nuspec Version"
    (Get-Content -Path "$modulePath\$($configuration.ModuleName)\$($configuration.ModuleName).nuspec").Replace("<version>0.0.0<\version>", "<version>$($configuration.ModuleVersion)<\version>") |
    Set-Content "$modulePath\$($configuration.ModuleName)\$($configuration.ModuleName).nuspec"

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
            "$script:ModuleName.nuspec",
            "-Exclude",
            "*.user.json",
            "-NoPackageAnalysis",
            "-OutputDirectory",
            "..\..\Package", # nuget on linux workaround
            "-Verbosity",
            "detailed",
            "-Version",
            "$script:ModuleVersion"
        )
        NoNewWindow      = $true
        Wait             = $true
        WorkingDirectory = Resolve-Path -Path "$modulePath\$script:ModuleName"
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
