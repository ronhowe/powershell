#requires -PSEdition "Core"
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Source\Module.psd1",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputDirectory = "$PSScriptRoot\Output"
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Configuration"
    $configuration = Import-PowerShellDataFile -Path $Path
    $name = $configuration.Name
    $version = $configuration.Version
    Write-Debug "`$name=$name"
    Write-Debug "`$version=$version"

    Write-Verbose "Getting Module Directory"
    $moduleDirectory = "$OutputDirectory/Module"
    Write-Debug "`$moduleDirectory=$moduleDirectory"

    Write-Verbose "Getting Package Directory"
    $packageDirectory = "$OutputDirectory/Package"
    Write-Debug "`$packageDirectory=$packageDirectory"

    Write-Verbose "Removing Package Directory"
    Remove-Item -Path $packageDirectory -Recurse -Force -ErrorAction SilentlyContinue

    Write-Verbose "Updating Nuspec Version"
    (Get-Content -Path "$moduleDirectory/$name/$name.nuspec").Replace("<version>0.0.0</version>", "<version>$version</version>") |
    Set-Content "$moduleDirectory/$name/$name.nuspec"

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
            "$name.nuspec",
            "-Exclude",
            "*.user.json",
            "-NoPackageAnalysis",
            "-OutputDirectory",
            "../../Package", # nuget on linux workaround
            "-Verbosity",
            "detailed",
            "-Version",
            "$version"
        )
        NoNewWindow      = $true
        Wait             = $true
        WorkingDirectory = Resolve-Path -Path "$moduleDirectory/$name"
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

    Write-Verbose "Getting Package Directory"
    if (Test-Path -Path $packageDirectory) {
        Get-ChildItem -Path $packageDirectory -Recurse
    }
    else {
        Write-Error "Package Directory Not Found"
    }
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
