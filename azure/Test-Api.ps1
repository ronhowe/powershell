param(
    [Uri]$Uri = "https://localhost:444",

    [switch]$Loop,

    [int]$Seconds = 1
)

$container = New-PesterContainer -Path "$HOME\repos\ronhowe\powershell\azure\Api.Tests.ps1" -Data @{ Uri = "https://localhost:444" }

do {
    Invoke-Pester -Path "$HOME\repos\ronhowe\powershell\azure\Api.Tests.ps1" -Output Detailed -Container $container

    if ($Loop) {
        Start-Sleep -Seconds $Seconds
    }
} until (-not $Loop)
