$ScriptBlock1 = {
    param(
        [ValidateNotNullorEmpty()]
        [string]
        $UserName,

        [ValidateNotNullorEmpty()]
        [securestring]
        $Password
    )
    Write-Output $UserName
    Write-Output $Password
}

$ScriptBlock2 = {
    param(
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $Credential
    )
    Write-Output $Credential.UserName
    Write-Output $Credential.Password
}

$Credential = Get-Credential
Invoke-Command -ComputerName "localhost" -Credential $Credential -ScriptBlock $ScriptBlock1 -ArgumentList @($Credential.UserName, $Credential.Password)
Invoke-Command -ComputerName "localhost" -Credential $Credential -ScriptBlock $ScriptBlock2 -ArgumentList $Credential
