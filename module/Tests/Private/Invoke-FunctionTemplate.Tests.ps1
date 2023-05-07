[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path = "$PSScriptRoot\..\..\Source\Module.psd1"
)
Describe "Testing Invoke-FunctionTemplate" {
    BeforeAll {
        Write-Debug $(Resolve-Path -Path $Path)

        Write-Verbose "Invoking Import-Configuration"
        . "$PSScriptRoot\..\..\Import-Configuration.ps1" -Path $Path

        Write-Debug $(Resolve-Path -Path "$PSScriptRoot\..\..\Output\Module\$Name")
        Import-Module -Name "$PSScriptRoot\..\..\Output\Module\$Name" -Force

        . "$PSScriptRoot\..\..\Source\Private\Invoke-FunctionTemplate.ps1"
    }
    It "Switch Parameter Present Throws" {
        { Invoke-FunctionTemplate -ComputerName "testComputerName" -SwitchParameter } |
        Should -Throw -ExpectedMessage "SwitchParameterThrows"
    }
    It "Switch Parameter Absent Does Not Throw" { 
        { Invoke-FunctionTemplate -ComputerName "testComputerName" } |
        Should -Not -Throw
    }
    It "Boolean Parameter True Returns False" {
        Invoke-FunctionTemplate -ComputerName "testComputerName" -BooleanParameter $true |
        Should -Be $false
    }
    It "Boolean Parameter False Returns True" {
        Invoke-FunctionTemplate -ComputerName "testComputerName" -BooleanParameter $false |
        Should -Be $true
    }
}