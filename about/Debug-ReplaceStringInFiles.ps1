[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Include = "*",

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$OldString,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$NewString
)

Write-Error "Untested" -ErrorAction Stop

Get-ChildItem -Path $Path -Recurse -Include $Include |
ForEach-Object {
    (Get-Content $_) |
    ForEach-Object { $_ -replace $OldString, $NewString } |
    Set-Content $_
}
