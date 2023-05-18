[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]$Runtime = "Visual Studio"
)
& "$PSScriptRoot\Test-All.ps1" -Filter "FunctionApp1 ($Runtime)" -SkipHealthchecks
