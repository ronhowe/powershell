[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullorEmpty()]
    [string[]]
    $Nodes,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $PfxPath,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [securestring]
    $PfxPassword
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    foreach ($node in $Nodes) {
        Write-Host "Getting PSSession To $node"
        $session = New-PSSession -ComputerName $node -Credential $Credential

        Write-Host "Copying PFX To $node"
        Copy-Item -Path $PfxPath -Destination "C:\DscPrivateKey.pfx" -ToSession $session

        Write-Host "Importing PFX On $node"
        $scriptBlock = {
            Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:PfxPassword |
            Out-Null

            Remove-Item -Path "C:\DscPrivateKey.pfx"
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Removing PSSession To $node"
        $session |
        Remove-PSSession
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
