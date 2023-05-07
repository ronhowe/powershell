#requires -PSEdition "Core"
#requires -Module "Pester"
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\Source\Module.psd1"
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Invoking Import-Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1" -Path $Path -Debug -Verbose

    Get-Module -Name $name |
    Remove-Module -Force -Verbose

    & "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

    Import-Module -Name "$PSScriptRoot\Output\Module\Shell" -Force -Verbose

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
