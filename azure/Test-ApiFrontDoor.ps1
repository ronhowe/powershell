while ($true) {
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "https://fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net:443" ; "CustomHeader" = "app-ronhowe-000" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 1
}