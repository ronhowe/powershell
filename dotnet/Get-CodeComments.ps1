[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "~\repos\ronhowe\dotnet",

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Match = "//"
)
Get-ChildItem -Path $Path -Include @("*.cs", "*.json") -Recurse |
Select-String -SimpleMatch $Match
