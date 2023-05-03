while ($true) {
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @{ "Uri" = "http://localhost:82" ; "CustomHeader" = "default" }
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Start-Sleep -Seconds 1
}