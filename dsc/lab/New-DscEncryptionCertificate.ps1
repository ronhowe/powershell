#requires -PSEdition "Desktop"
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

    Write-Warning "Creating Self-Signed Certificate" -WarningAction Continue

    Write-Host "Creating Certificate"
    $certificate = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName "DscEncryptionCert" -HashAlgorithm SHA256

    Write-Host "Exporting Private Key"
    $certificate |
    Export-PfxCertificate -FilePath "$PSScriptRoot\DscPrivateKey.pfx" -Password $PfxPassword -Force

    Write-Host "Exporting Public Key"
    $certificate |
    Export-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -Force

    Write-Host "Removing Certificate"
    $certificate |
    Remove-Item -Force

    Write-Host "Importing Public Key"
    Import-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -CertStoreLocation $CertStoreLocation
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
