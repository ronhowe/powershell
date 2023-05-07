[CmdletBinding()]
param()
Describe "TestingInvokeFunctionTemplate" {
    BeforeAll {
        . "$PSScriptRoot/../../Source/Private/Invoke-FunctionTemplate.ps1"
    }
    It "SwitchParameterPresentThrows" {
        { Invoke-FunctionTemplate -SwitchParameter }
        | Should -Throw -ExpectedMessage "SwitchParameterThrows"
    }
    It "SwitchParameterAbsentDoesNotThrow" { 
        { Invoke-FunctionTemplate }
        | Should -Not -Throw
    }
    It "BooleanParameterTrueReturnsFalse" {
        Invoke-FunctionTemplate -BooleanParameter $true
        | Should -Be $false
    }
    It "BooleanParameterFalseReturnsTrue" {
        Invoke-FunctionTemplate -BooleanParameter $false
        | Should -Be $true
    }
}