[CmdletBinding()]
param(
    [switch]$Loop,

    [int]$Seconds = 1
)

& "$PSScriptRoot/Test-Api.ps1" -Uri "https://localhost:444" -Loop:$Loop -Seconds $Seconds
