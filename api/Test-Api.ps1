#requires -module "WriteAscii"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "Application", "FunctionApp1", "WebApplication1")]
    [string]$Name = "*",

    [Parameter(Mandatory = $false)]
    [ValidateSet("*", "AppService", "Docker", "FrontDoor", "FunctionApp", "Gateway", "Kestrel")]
    [string]$Platform = "*",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]$Sleep = 5,

    [switch]$SkipApplicationChecks,

    [switch]$SkipHealthChecks,

    [switch]$Ping
)
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = (Import-PowerShellDataFile -Path "$PSScriptRoot\Api.Tests.psd1").Endpoints |
    Where-Object { ($_.Enabled -eq $true) -and ($_.Endpoint.Name -like $Name) -and ($_.Endpoint.Platform -like $Platform) } |
    Select-Object -ExpandProperty "Endpoint"
    if ($data) {
        $includeTags = @()
        $excludeTags = @()
        if ($SkipApplicationChecks) {
            $excludeTags += "application"
        }
        if ($SkipHealthChecks) {
            $excludeTags += "healthcheck"
        }
        if ($Ping) {
            $includeTags += "ping"
        }
        Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data) -TagFilter $includeTags -ExcludeTagFilter $excludeTags
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
