# #requires -module "WriteAscii"
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @(
        @{ Name = "API Gateway" ; Uri = "https://apim-ronhowe-000.azure-api.net:443/httpbin/v1"; CustomHeader = "apim-ronhowe-000" }
    )
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Write-Ascii $data.Name
    Start-Sleep -Seconds 5
}
