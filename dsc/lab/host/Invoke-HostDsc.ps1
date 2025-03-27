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

    Write-Host "Creating Mof Folder"
    if (-not (Test-Path "$PSScriptRoot\bin\HostDsc")) {
        New-Item -Path "$PSScriptRoot\bin\HostDsc" -ItemType Directory
    }

    Write-Host "Importing Host Dsc"
    . "$PSScriptRoot\HostDsc.ps1"

    Write-Host "Compiling Host Dsc"
    HostDsc -ConfigurationData "$PSScriptRoot\HostDsc.psd1" -Nodes $Nodes -Ensure $Ensure -OutputPath "$PSScriptRoot\bin\HostDsc"

    Write-Host "Starting Host Dsc"
    Start-DscConfiguration -Path "$PSScriptRoot\bin\HostDsc" -Force -Wait:$Wait -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
