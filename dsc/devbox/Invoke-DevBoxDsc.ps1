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

    Write-Host "Creating Mof Folder"
    if (-not (Test-Path "$PSScriptRoot\bin\DevBoxDsc")) {
        New-Item -Path "$PSScriptRoot\bin\DevBoxDsc" -ItemType Directory
    }

    Write-Host "Importing DevBox Dsc"
    . "$PSScriptRoot\DevBoxDsc.ps1"

    Write-Host "Compiling DevBox Dsc"
    DevBoxDsc -ConfigurationData "$PSScriptRoot\DevBoxDsc.psd1" -OutputPath "$PSScriptRoot\bin\DevBoxDsc"

    Write-Host "Starting DevBox Dsc"
    Start-DscConfiguration -Path "$PSScriptRoot\bin\DevBoxDsc" -Force -Wait -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
