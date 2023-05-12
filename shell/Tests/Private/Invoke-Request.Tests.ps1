[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\Source\Module.psd1"
)
Describe "Testing Invoke-Request" {
    BeforeAll {
        Write-Debug $(Resolve-Path -Path $Path)

        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1" -Path $Path

        Write-Debug $(Resolve-Path -Path "$PSScriptRoot\..\..\Output\Module\$Name")
        Import-Module -Name "$PSScriptRoot\..\..\Output\Module\$Name" -Force

        . "$PSScriptRoot\..\..\Source\Private\Invoke-Request.ps1"
    }
    It "Uri Invalid Throws" {
        { Invoke-Request -Uri "https://b276ec7d-1d97-46a1-af03-4a0fbb646b63" } |
        Should -Throw
    }
    It "Switch Present Returns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        Should -Not -BeNullOrEmpty
    }
    It "Switch Absent Returns" {
        Invoke-Request -Uri "https://catfact.ninja/fact" |
        Should -Not -BeNullOrEmpty
    }
}