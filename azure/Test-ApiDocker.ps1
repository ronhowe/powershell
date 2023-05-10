#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @(
        @{ Name = "Docker HTTP" ; Uri = "http://localhost:82"; CustomHeader = "default" }
        # @{ Name = "Docker HTTPS" ; Uri = "https://localhost:32772"; CustomHeader = "default" }
    )
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Write-Ascii $data.Name
    Start-Sleep -Seconds 5
}
