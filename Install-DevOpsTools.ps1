#requires -RunAsAdministrator
#requires -PSEdition Desktop

$ProgressPreference = "SilentlyContinue"

winget install --id Microsoft.Powershell --source winget
winget install --id Microsoft.VisualStudioCode --source winget
winget install --id Microsoft.DotNet.SDK.7 --source winget
winget install --id Microsoft.WindowsAdminCenter --source winget
winget install --id Microsoft.WindowsTerminal --source winget
winget install --id Git.Git --source winget
winget install --id GitHub.cli --source winget
winget install --id GitHub.GitHubDesktop --source winget
winget install --id Microsoft.NuGet --source winget
winget install --id Python.Python.3.10 --source winget

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

code --install-extension ms-vscode.powershell 2>$null
code --install-extension ms-dotnettools.dotnet-interactive-vscode 2>$null
code --install-extension ms-dotnettools.vscode-dotnet-runtime 2>$null
code --install-extension ms-dotnettools.vscode-dotnet-sdk 2>$null
code --install-extension ms-python.python 2>$null
code --install-extension ms-azuretools.vscode-bicep 2>$null
code --install-extension tyriar.sort-lines 2>$null
code --install-extension oderwat.indent-rainbow 2>$null

python -m pip install --upgrade pip
python -m pip install jupyter notebook -U
pip install powershell_kernel
python -m powershell_kernel.install

Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools*" -Online | Add-WindowsCapability -Online
Get-WindowsCapability -Name "Rsat.DHCP.Tools*" -Online | Add-WindowsCapability -Online
Get-WindowsCapability -Name "Rsat.Dns.Tools*" -Online | Add-WindowsCapability -Online

code --version
dotnet --version
gh --version
git --version
nuget | Select-String "NuGet Version"
pwsh --version
python --version
Get-WindowsCapability -Name "Rsat*" -Online | Where-Object { $_.State -eq "Installed" } | Format-Table -AutoSize
