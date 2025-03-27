#requires -PSEdition "Desktop"
#requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullorEmpty()]
    [string]
    $Subject = "DscEncryptionCert",

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

    Write-Host "Removing Certificates"
    Get-ChildItem -Path $CertStoreLocation |
    Where-Object { $_.Subject -eq "CN=$Subject" } |
    Remove-Item -Force
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
