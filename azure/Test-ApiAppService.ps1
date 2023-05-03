while ($true) {
    Invoke-Pester -Path "$PSScriptRoot\Api.Tests.ps1" -Output Detailed -Container (New-PesterContainer -Path "$PSScriptRoot\Api.Tests.ps1" -Data @{ "Uri" = "https://app-ronhowe-000.azurewebsites.net" ; "CustomHeader" = "app-ronhowe-000" })
    Start-Sleep -Seconds 1
}