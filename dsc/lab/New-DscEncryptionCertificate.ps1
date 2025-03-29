#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]
    $Subject = "DscEncryptionCert",

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

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Warning "Creating Self-Signed Certificate" -WarningAction Continue

    Write-Output "Creating Certificate"
    $certificate = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName $Subject -HashAlgorithm SHA256

    Write-Output "Exporting Private Key"
    $certificate |
    Export-PfxCertificate -FilePath "$PSScriptRoot\DscPrivateKey.pfx" -Password $PfxPassword -Force

    Write-Output "Exporting Public Key"
    $certificate |
    Export-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -Force

    Write-Output "Removing Certificate"
    $certificate |
    Remove-Item -Force

    Write-Output "Importing Public Key"
    Import-Certificate -FilePath "$PSScriptRoot\DscPublicKey.cer" -CertStoreLocation $CertStoreLocation
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
