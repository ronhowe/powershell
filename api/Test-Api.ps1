#requires -module "WriteAscii"
[CmdletBinding()]
param(
    # [Parameter(Mandatory = $false)]
    # [ValidateNotNullorEmpty()]
    # [string]$Filter = "*",

    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "FunctionApp1", "WebApplication1", "Application")]
    [string]$Name = "*",

    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "Docker", "VisualStudio", "AppService", "FunctionApp", "Gateway", "FrontDoor")]
    [string]$Platform = "*",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]$Sleep = 5,

    [switch]$SkipHealthchecks
)
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = (Import-PowerShellDataFile -Path "$PSScriptRoot\Api.Tests.psd1").Endpoints |
    # Where-Object { $_.Enabled -and $_.Endpoint.Name -like $Runtime } |
    Where-Object { ($_.Endpoint.Name -like $Name ) -and ($_.Endpoint.Platform -like $Platform ) } |
    Select-Object -ExpandProperty "Endpoint"
    if ($data) {
        if ($SkipHealthchecks) {
            Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data) -TagFilter "api"
        }
        else {
            Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
        }
        if ($Filter -ne "*") {
            Write-Ascii -InputObject "$Name ($Platform)" -ForegroundColor Cyan
        }
        Write-Host "Sleeping $Sleep Second(s)..." -ForegroundColor Cyan
        Start-Sleep -Seconds $Sleep
    }
    else {
        Write-Error "No Endpoint Data Found" -ErrorAction Stop
    }
}
