while ($true) {
    Invoke-Pester -Path "$PSScriptRoot\Api.Tests.ps1" -Output Detailed -Container (New-PesterContainer -Path "$PSScriptRoot\Api.Tests.ps1" -Data @{ "Uri" = "http://localhost:82" })
    Start-Sleep -Seconds 1
}