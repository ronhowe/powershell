while ($true) {
    Invoke-Pester -Path "$PSScriptRoot\Api.Tests.ps1" -Output Detailed -Container (New-PesterContainer -Path "$PSScriptRoot\Api.Tests.ps1" -Data @{ "Uri" = "https://localhost:444" })
    Start-Sleep -Seconds 1
}