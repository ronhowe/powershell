#requires -module "WriteAscii"
while ($true) {
    Clear-Host
    $path = "$PSScriptRoot\Api.Tests.ps1"
    $data = @(
        @{ Name = "Kestrel" ; Uri = "https://localhost:444"; CustomHeader = "default" }
    )
    Invoke-Pester -Path $path -Output Detailed -Container (New-PesterContainer -Path $path -Data $data)
    Write-Ascii $data.Name
    Start-Sleep -Seconds 5
}
