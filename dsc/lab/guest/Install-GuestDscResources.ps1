[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullorEmpty()]
    [string[]]
    $Nodes,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [pscredential]
    $Credential
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    foreach ($node in $Nodes) {
        Write-Host "Getting PSSession To $node"
        $session = New-PSSession -ComputerName $node -Credential $Credential

        Write-Host "Installing Nuget Package Provider On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-PackageProvider -Name "nuget" -Force |
            Out-Null
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Installing ActiveDirectoryCSDsc Resource On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-Module -Name "ActiveDirectoryCSDsc" -RequiredVersion "5.0.0" -Repository "PSGallery" -Scope AllUsers -Force
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Installing ActiveDirectoryDsc Resource On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-Module -Name "ActiveDirectoryDsc" -RequiredVersion "6.6.2" -Repository "PSGallery" -Scope AllUsers -Force
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Installing ComputerManagementDsc Resource On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-Module -Name "ComputerManagementDsc" -RequiredVersion "10.0.0" -Repository "PSGallery" -Scope AllUsers -Force
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Installing NetworkingDsc Resource On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-Module -Name "NetworkingDsc" -RequiredVersion "9.0.0" -Repository "PSGallery" -Scope AllUsers -Force
        }
        Invoke-Command -Session $session -ScriptBlock $scriptBlock

        Write-Host "Installing SqlServerDsc Resource On $node"
        $scriptBlock = {
            $ProgressPreference = "SilentlyContinue"
            Install-Module -Name "SqlServerDsc" -RequiredVersion "17.0.0" -Repository "PSGallery" -Scope AllUsers -Force
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
