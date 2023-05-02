$container = New-PesterContainer -Path "$HOME\repos\ronhowe\powershell\azure\Api.Tests.ps1" -Data @{ Uri = "http://localhost:82" }
Invoke-Pester -Path "$HOME\repos\ronhowe\powershell\azure\Api.Tests.ps1" -Output Detailed -Container $container
