#requires -Module "Pester"
[CmdletBinding()]
param(
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name) = $($_.Value)" }
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Module"
    Import-Module -Name "$PSScriptRoot\bin\Shell" -Global -Force -Verbose:$false 4>&1 |
    Out-Null

    ## TODO: Remove \module\ such as to include \dependencies\ Pester tests?
    Get-ChildItem -Path "$PSScriptRoot\test\*.Tests.ps1" -Recurse |
    ForEach-Object {
        Invoke-Pester -Path $($_.FullName) -Output Detailed
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
