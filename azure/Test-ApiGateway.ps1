while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "https://apim-ronhowe-000.azure-api.net/httpbin/v1" ; "CustomHeader" = "apim-ronhowe-000" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 1
}