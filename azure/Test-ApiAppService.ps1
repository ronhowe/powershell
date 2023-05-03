#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    Write-Ascii -InputObject "APP SERVICE"
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "https://app-ronhowe-000.azurewebsites.net:443" ; "CustomHeader" = "app-ronhowe-000" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 3
}