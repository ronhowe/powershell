#requires -Module "PSDesiredStateConfiguration"
#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Importing DevBox Dsc"
    . "$PSScriptRoot\DevBoxDsc.ps1"

    Write-Host "Compiling DevBox Dsc"
    DevBoxDsc -ConfigurationData "$PSScriptRoot\DevBoxDsc.psd1" -OutputPath "$env:TEMP\DevBoxDsc"

    Write-Host "Starting DevBox Dsc"
    Start-DscConfiguration -Path "$env:TEMP\DevBoxDsc" -Force -Wait -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
