[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "Shell"
)
Describe "TestingInvokeFunctionTemplate" {
    BeforeAll {
        Write-Debug $(Resolve-Path -Path "$PSScriptRoot\..\..\Output\Module\$Name")
        Import-Module -Name "$PSScriptRoot\..\..\Output\Module\$Name" -Force

        . "$PSScriptRoot\..\..\Source\Private\Invoke-FunctionTemplate.ps1"
    }
    It "SwitchParameterPresentThrows" {
        { Invoke-FunctionTemplate -ComputerName "testComputerName" -SwitchParameter } |
        Should -Throw -ExpectedMessage "SwitchParameterThrows"
    }
    It "SwitchParameterAbsentDoesNotThrow" { 
        { Invoke-FunctionTemplate -ComputerName "testComputerName" } |
        Should -Not -Throw
    }
    It "BooleanParameterTrueReturnsFalse" {
        Invoke-FunctionTemplate -ComputerName "testComputerName" -BooleanParameter $true |
        Should -Be $false
    }
    It "BooleanParameterFalseReturnsTrue" {
        Invoke-FunctionTemplate -ComputerName "testComputerName" -BooleanParameter $false |
        Should -Be $true
    }
}