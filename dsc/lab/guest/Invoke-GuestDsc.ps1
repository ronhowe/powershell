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
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $SqlCredential,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $Thumbprint,

    [switch]
    $Wait
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Creating Mof Folder"
    if (-not (Test-Path "$PSScriptRoot\bin\GuestDsc")) {
        New-Item -Path "$PSScriptRoot\bin\GuestDsc" -ItemType Directory
    }

    Write-Host "Importing Guest Dsc"
    . "$PSScriptRoot\GuestDsc.ps1"

    Write-Host "Compiling Guest Dsc"
    $parameters = @{
        ConfigurationData = "$PSScriptRoot\GuestDsc.psd1"
        OutputPath        = "$PSScriptRoot\bin\GuestDsc"
        Credential        = $Credential
        SqlCredential     = $SqlCredential
        Thumbprint        = $Thumbprint
    }
    GuestDsc @parameters

    Write-Host "Invoking Guest Dsc On $node"
    foreach ($node in $Nodes) {
        Write-Host "Setting Guest Dsc Local Configuration Manager On $node"
        Set-DscLocalConfigurationManager -ComputerName $node -Credential $Credential -Path "$PSScriptRoot\bin\GuestDsc" -Force -Verbose

        Write-Host "Starting Guest Dsc On $node"
        Start-DscConfiguration -ComputerName $node -Credential $Credential -Path "$PSScriptRoot\bin\GuestDsc" -Force -Wait:$Wait -Verbose |
        Out-Null
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
