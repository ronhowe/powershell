while ($true) {
    Invoke-Pester -Path "$PSScriptRoot\Api.Tests.ps1" -Output Detailed -Container (New-PesterContainer -Path "$PSScriptRoot\Api.Tests.ps1" -Data @{ "Uri" = "https://apim-ronhowe-000.azure-api.net/httpbin/v1" ; "CustomHeader" = "apim-ronhowe-000" })
    Start-Sleep -Seconds 1
}