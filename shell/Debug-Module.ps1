#requires -PSEdition "Core"
#requires -Module "Pester"
[CmdletBinding()]
param (
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Configuration"
    . "$PSScriptRoot\Import-Configuration.ps1" -Debug -Verbose

    Get-Module -Name $moduleName |
    Remove-Module -Force -Verbose

    & "$PSScriptRoot\Start-Build.ps1" -Debug -Verbose

    # TODO - Getting an assembly already loaded error on some machines. -ErrorAction SilentlyContinue as workaround.
    Import-Module -Name "$modulePath\$moduleName" -Force -Verbose -ErrorAction SilentlyContinue

    ###############################################################################
    #region Debugging

    # Set breakpoints in the build output PSM1 module file.
    # Call function under debug with appropriate parameters.

    # Exmaple: Simple direct call.
    # Get-IDIQuote -Debug

    # or

    # Example: Complex call with Pester.  Useful if you need to mock inner dependencies.
    # Note: Has side effect of this script running twice; once on run here and once again as part of Pester auto-discovery and execution.

    # Describe "Debugging Function" {
    #     It "Invoking Function" {
    #         Get-IDICatFact
    #     }
    # }

    #endregion Debugging
    ###############################################################################

    Write-Host "OK" -ForegroundColor Green
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
