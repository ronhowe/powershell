#requires -Module "PSDesiredStateConfiguration"
#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Nodes,

    [Parameter(Mandatory = $true)]
    [ValidateSet("Present", "Absent")]
    [string]
    $Ensure,

    [switch]
    $Wait
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Host Dsc"
    . "$PSScriptRoot\HostDsc.ps1" |
    Out-Null

    Write-Verbose "Compiling Host Dsc"
    HostDsc -ConfigurationData "$PSScriptRoot\HostDsc.psd1" -Nodes $Nodes -Ensure $Ensure -OutputPath "$env:TEMP\HostDsc" |
    Out-Null

    Write-Verbose "Starting Host Dsc"
    Start-DscConfiguration -Path "$env:TEMP\HostDsc" -Force -Wait:$Wait -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
