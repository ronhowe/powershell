#requires -Module "PSDesiredStateConfiguration"
#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Output "Creating Mof Folder"
    if (-not (Test-Path "$PSScriptRoot\bin\DevBoxDsc")) {
        New-Item -Path "$PSScriptRoot\bin\DevBoxDsc" -ItemType Directory
    }

    Write-Output "Importing DevBox Dsc"
    . "$PSScriptRoot\DevBoxDsc.ps1"

    Write-Output "Compiling DevBox Dsc"
    DevBoxDsc -ConfigurationData "$PSScriptRoot\DevBoxDsc.psd1" -OutputPath "$PSScriptRoot\bin\DevBoxDsc"

    Write-Output "Starting DevBox Dsc"
    Start-DscConfiguration -Path "$PSScriptRoot\bin\DevBoxDsc" -Force -Wait -Verbose
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
