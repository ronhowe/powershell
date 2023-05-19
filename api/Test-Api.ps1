#requires -module "WriteAscii"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "Application", "FunctionApp1", "WebApplication1")]
    [string]$Name = "*",

    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "AppService", "Docker", "FrontDoor", "FunctionApp", "Gateway", "VisualStudio")]
    [string]$Platform = "*",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]$Sleep = 5,

    [switch]$SkipHealthChecks
)
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = (Import-PowerShellDataFile -Path "$PSScriptRoot\Api.Tests.psd1").Endpoints |
    Where-Object { ($_.Enabled -eq $true) -and ($_.Endpoint.Name -like $Name) -and ($_.Endpoint.Platform -like $Platform) } |
    Select-Object -ExpandProperty "Endpoint"
    if ($data) {
        if ($SkipHealthChecks) {
            Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data) -ExcludeTagFilter @("healthcheck")
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
        Write-Error "No API Test Data Found" -ErrorAction Stop
    }
}
