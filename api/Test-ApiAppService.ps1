#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @(
        @{ Name = "App Service" ; Uri = "https://app-ronhowe-000.azurewebsites.net:443"; CustomHeader = "appcs-ronhowe-000" }
    )
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Write-Ascii $data.Name
    Start-Sleep -Seconds 5
}
