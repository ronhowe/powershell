#requires -PSEdition Desktop
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [securestring]
    $PfxPassword,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]
    $CertStoreLocation = "Cert:\LocalMachine\My"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Warning "Creating Self-Signed Certificate"

    Write-Verbose "Creating Certificate"
    $certificate = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName "DscEncryptionCert" -HashAlgorithm SHA256

    Write-Verbose "Exporting Private Key"
    $certificate |
    Export-PfxCertificate -FilePath "$PSScriptRoot\DscPrivateKey.pfx" -Password $PfxPassword -Force

    Write-Verbose "Exporting Public Key"
    $certificate |
    Export-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -Force

    Write-Verbose "Removing Certificate"
    $certificate |
    Remove-Item -Force

    Write-Verbose "Importing Certificate"
    Import-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -CertStoreLocation $CertStoreLocation
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
