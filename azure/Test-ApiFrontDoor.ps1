#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    Write-Ascii -InputObject "FRONT DOOR"
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "https://fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net:443" ; "CustomHeader" = "fd-ronhowe-000" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 3
}