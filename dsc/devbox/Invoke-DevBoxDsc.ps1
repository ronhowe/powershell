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

    Write-Verbose "Importing DevBox Dsc"
    . "$PSScriptRoot\DevBoxDsc.ps1" |
    Out-Null

    Write-Verbose "Compiling DevBox Dsc"
    DevBoxDsc -ConfigurationData "$PSScriptRoot\DevBoxDsc.psd1" -OutputPath "$env:TEMP\DevBoxDsc" |
    Out-Null

    Write-Verbose "Starting DevBox Dsc"
    Start-DscConfiguration -Path "$env:TEMP\DevBoxDsc" -Force -Wait
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
