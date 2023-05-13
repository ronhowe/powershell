#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @(
        @{ Name = "Kestrel" ; Uri = "https://localhost:444"; CustomHeader = "default" }
        @{ Name = "App Service" ; Uri = "https://app-ronhowe-000.azurewebsites.net:443"; CustomHeader = "appcs-ronhowe-000" }
        @{ Name = "Gateway" ; Uri = "https://apim-ronhowe-000.azure-api.net:443/httpbin/v1"; CustomHeader = "apim-ronhowe-000" }
        @{ Name = "Front Door" ; Uri = "https://fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net/httpbin/v1" ; CustomHeader = "apim-ronhowe-000" }
    )
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 5
}
