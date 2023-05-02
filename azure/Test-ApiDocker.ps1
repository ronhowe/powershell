[CmdletBinding()]
param(
    [switch]$Loop,

    [int]$Seconds = 1
)

& "$PSScriptRoot/Test-Api.ps1" -Uri "http://localhost:82" -Loop:$Loop -Seconds $Seconds
