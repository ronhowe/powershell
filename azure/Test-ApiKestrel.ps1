#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    Write-Ascii -InputObject "KESTREL"
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "https://localhost:444" ; "CustomHeader" = "default" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 3
}