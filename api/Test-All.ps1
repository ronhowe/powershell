#requires -module "WriteAscii"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]$Filter = "*",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [int]$Sleep = 5
)
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = (Import-PowerShellDataFile -Path "$PSScriptRoot\Api.Tests.psd1").Endpoints |
    Where-Object { $_.Enabled -and $_.Endpoint.Name -like $Filter } |
    Select-Object -ExpandProperty "Endpoint"
    if ($data) {
        Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
        if ($Filter -ne "*") {
            Write-Ascii -InputObject $data.Name -ForegroundColor Cyan
        }
        Write-Host "Sleeping $Sleep Second(s)..." -ForegroundColor Cyan
        Start-Sleep -Seconds $Sleep
    }
    else {
        Write-Error "No Endpoint Data Found" -ErrorAction Stop
    }
}
