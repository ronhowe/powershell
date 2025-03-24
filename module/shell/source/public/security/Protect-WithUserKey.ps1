## LINK: https://devblogs.microsoft.com/powershell-community/encrypting-secrets-locally/
function Protect-WithUserKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $UnencryptedSecret
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Add-Type -AssemblyName System.Security
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($UnencryptedSecret)
        $SecureStr = [Security.Cryptography.ProtectedData]::Protect(
            $bytes, # contains data to encrypt
            $null, # optional data to increase entropy
            [Security.Cryptography.DataProtectionScope]::CurrentUser # scope of the encryption
        )
        $SecureStrBase64 = [System.Convert]::ToBase64String($SecureStr)
        return $SecureStrBase64
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
