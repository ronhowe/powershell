#requires -Module "Pester"
#requires -PSEdition "Core"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $Path,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [Alias("Name", "Node", "NodeName", "VMName")]
    [ValidateNotNullorEmpty()]
    [string[]]
    $ComputerName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Doing Something ; Please Wait"

    foreach ($computer in $ComputerName) {
        Write-Host "Doing Something On $computer ; Please Wait"
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
