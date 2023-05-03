while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net" ; "CustomHeader" = "app-ronhowe-000" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 1
}