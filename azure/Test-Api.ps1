[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [Uri]$Uri = "https://localhost:444",

    [Parameter(Mandatory = $false)]
    [switch]$Loop,

    [Parameter(Mandatory = $false)]
    [int]$Seconds = 1
)

$path = "$HOME\repos\ronhowe\powershell\azure\Api.Tests.ps1"

[hashtable]$data = @{
    "Uri"          = "https://localhost:444"
    "CustomHeader" = "default"
}
$container = New-PesterContainer -Path $path -Data $data

do {
    Invoke-Pester -Path $path -Output Detailed -Container $container

    if ($Loop) {
        Start-Sleep -Seconds $Seconds
    }
} until (-not $Loop)
