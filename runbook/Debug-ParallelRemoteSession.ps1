$credential = Get-Credential
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "NOT-EXISTING-00")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "NOT-EXISTING-00", "localhost")
$computers = @("LAB-APP-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00", "LAB-DC-00", "LAB-SQL-00", "LAB-WEB-00")
$thumbprint = "F59627BB6A2B553E68A5565A5DFA639CB91574DE"

$computers |
ForEach-Object {
    $session = New-PSSession -ComputerName $_ -Credential $credential -ErrorAction Continue
    if ($session) {
        Invoke-Command -Session $session -ScriptBlock {
            Get-ChildItem -Path "Cert:\LocalMachine\My\$thumbprint" |
            Select-Object -First 1 |
            Select-Object -Property "Thumbprint", "NotBefore", "NotAfter", "Subject", "Issuer"
        } -ErrorAction Continue
    }
    $session | Remove-PSSession
} |
Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
Format-Table -AutoSize

# by script block
$computers |
ForEach-Object -Parallel {
    $thumbprint = $using:thumbprint
    $session = New-PSSession -ComputerName $_ -Credential $using:credential -ErrorAction Continue
    if ($session) {
        Invoke-Command -Session $session -ScriptBlock {
            Get-ChildItem -Path "Cert:\LocalMachine\My\$using:thumbprint" |
            Select-Object -Property "Thumbprint", "NotBefore", "NotAfter", "Subject", "Issuer"
        } -ErrorAction Continue
    }
} -ThrottleLimit 20 |
Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
Format-Table -AutoSize

# by file
$computers |
ForEach-Object -Parallel {
    $session = New-PSSession -ComputerName $_ -Credential $using:credential -ErrorAction Continue
    if ($session) {
        Invoke-Command -Session $session -FilePath "D:\repos\ronhowe\powershell\runbook\Debug-ParallelRemoteSessionScript.ps1" -ArgumentList $using:thumbprint -ErrorAction Continue -Verbose
    }
} -ThrottleLimit 20 |
Select-Object -Property @(@{Name = "ComputerName"; Expression = { $_.PSComputerName } }, "Thumbprint", "NotAfter") |
Format-Table -AutoSize
