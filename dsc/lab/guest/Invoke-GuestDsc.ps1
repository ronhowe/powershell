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
    [string]
    $DscEncryptionCertificateThumbprint,

    [switch]
    $Wait
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Host "Importing Guest Dsc"
    . "$PSScriptRoot\GuestDsc.ps1" |
    Out-Null

    Write-Host "Compiling Guest Dsc"
    $parameters = @{
        ConfigurationData                  = "$PSScriptRoot\GuestDsc.psd1"
        OutputPath                         = "$env:TEMP\GuestDsc"
        Credential                         = $Credential
        DscEncryptionCertificateThumbprint = $DscEncryptionCertificateThumbprint
    }
    GuestDsc @parameters |
    Out-Null

    Write-Host "Invoking Guest Dsc On $node"
    foreach ($node in $Nodes) {
        Write-Host "Setting Guest Dsc Local Configuration Manager On $node"
        Set-DscLocalConfigurationManager -ComputerName $node -Credential $Credential -Path "$env:TEMP\GuestDsc" -Force -Verbose

        Write-Host "Starting Guest Dsc On $node"
        Start-DscConfiguration -ComputerName $node -Credential $Credential -Path "$env:TEMP\GuestDsc" -Force -Wait:$Wait -Verbose
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
