#requires -Module "Pester"
#requires -PSEdition Desktop
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
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Doing Something ; Please Wait"
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
