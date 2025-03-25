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
        Write-Verbose "Getting PSSession To $node"
        $session = New-PSSession -ComputerName $node -Credential $Credential

        Write-Verbose "Copying PFX To $node"
        Copy-Item -Path $PfxPath -Destination "C:\DscPrivateKey.pfx" -ToSession $session

        Write-Verbose "Importing PFX On $node"
        $ScriptBlock = {
            Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:PfxPassword |
            Out-Null

            Remove-Item -Path -Path "C:\DscPrivateKey.pfx"
        }
        Invoke-Command -Session $session -ScriptBlock $ScriptBlock

        Write-Verbose "Removing PSSession To $node"
        $session |
        Remove-PSSession
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
