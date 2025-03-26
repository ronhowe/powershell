throw

Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"

# all at once
$nodes = @("LAB-DC-00", "LAB-APP-00", "LAB-SQL-00", "LAB-WEB-00")
# or one at a time
$nodes = @("LAB-DC-00")
$nodes = @("LAB-APP-00")
$nodes = @("LAB-SQL-00")
$nodes = @("LAB-WEB-00")

$credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"
$pfxPassword = Read-Host -Prompt "Enter PFX Password" -AsSecureString

& "$HOME\repos\ronhowe\powershell\dsc\lab\New-DscEncryptionCertificate.ps1" -PfxPassword $pfxPassword

Get-ChildItem -Path "Cert:\LocalMachine\My\" |
Where-Object { $_.Subject -eq "CN=DscEncryptionCert" } |
Format-Table -AutoSize -OutVariable thumbprint

& "$HOME\repos\ronhowe\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Absent" -Wait
& "$HOME\repos\ronhowe\powershell\dsc\lab\host\Invoke-HostDsc.ps1" -Nodes $nodes -Ensure "Present" -Wait

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "NEW" -Verbose
$nodes | Start-VM -Verbose

Invoke-Pester -Script "$HOME\repos\ronhowe\powershell\dsc\lab\host\HostDsc.Tests.ps1" -Output Detailed

## NOTE: Launching this many vmconnect processes is taxing.
$nodes | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) ; Start-Sleep -Seconds 3 }

## NOTE: Complete the OOBE process including login for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-OOBE" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Rename-Guest is idempotent.
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Rename-Guest.ps1" -Nodes $nodes -Credential $credential

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-RENAME" -Verbose
$nodes | Start-VM -Verbose

## NOTE: Initialize-Guest is idempotent.
& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Initialize-Guest.ps1" -Nodes $nodes -Credential $credential

## NOTE: Patch Windows for each node.

$nodes | Stop-VM -Force -Verbose
$nodes | Checkpoint-VM -SnapshotName "POST-INITIALIZE" -Verbose
$nodes | Start-VM -Verbose

& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Install-GuestResources.ps1" -Nodes $nodes -Credential $credential

& "$HOME\repos\ronhowe\powershell\dsc\lab\Publish-DscEncryptionCertificate.ps1" -Nodes $nodes -Credential $credential -PfxPath "$HOME\repos\ronhowe\powershell\dsc\lab\DscPrivateKey.pfx" -PfxPassword $pfxPassword

& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Invoke-GuestDsc.ps1" -Nodes $nodes -Credential $credential -DscEncryptionCertificateThumbprint $thumbprint

& "$HOME\repos\ronhowe\powershell\dsc\lab\guest\Wait-GuestDsc.ps1" -Nodes $nodes -Credential $credential -RetryInterval 3

Invoke-Pester -Script ".\powershell\prototypes\hyper-v\GuestDsc.Tests.ps1" -Output Detailed

## NOTE: Install-PowerShell is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-PowerShell.ps1"
## NOTE: It works, but causes this error due to WinRm being reset by the installer.
# OpenError: [LAB-DC-00] Processing data from remote server LAB-DC-00 failed with the following error message:
# The I/O operation has been aborted because of either a thread exit or an application request.
# For more information, see the about_Remote_Troubleshooting Help topic.

## NOTE: Install-WebDeploy is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-WebDeploy.ps1"

## NOTE: Install-NetCoreHostingBundle is idempotent.
Invoke-Command -ComputerName $nodes -Credential $credential -FilePath ".\powershell\runbooks\Install-NetCoreHostingBundle.ps1"

## TODO: Refactor into GuestDsc.  Enables Web Management Service for publishing web applications.
$port = 8172
New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Domain" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Domain
New-NetFirewallRule -DisplayName "Allow TCP Inbound Port $port - Private" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Private

Copy-Item -Path ".\repos\ronhowe\code\powershell\module\bin\Shell" -Recurse -Destination "C:\installers" -ToSession $session -Verbose -Force

Install-Module -Name "Pester" -Repository "PSGallery" -Force -SkipPublisherCheck
Remove-Module -Name "Pester" -Force -Verbose
Import-Module -Name "Pester" -Force -Verbose
