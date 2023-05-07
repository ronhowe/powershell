function Invoke-FunctionTemplate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName,
        #
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path = $PSScriptRoot,
        #
        [Parameter()]
        [bool]$BooleanParameter,
        #
        [Parameter()]
        [switch]$SwitchParameter
    )
    begin {
        Write-Debug "Begin$($MyInvocation.MyCommand.Name)"
        #
        Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
        Select-Object -Property @("Name", "Value") |
        ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
    }
    process {
        Write-Debug "Process$($MyInvocation.MyCommand.Name)"
        #
        foreach ($computer in $ComputerName) {
            Write-Information $computer
        }
        # if ($SwitchParameter.IsPresent) {
        #     throw "SwitchParameterThrows"
        # }
        # #
        # return -not $BooleanParameter
    }
    end {
        Write-Debug "End$($MyInvocation.MyCommand.Name)"
    }
}
# Invoke-FunctionTemplate -ComputerName @(1..5) -Path "~" -Debug -InformationAction Continue -Verbose
# @(1..50) | Invoke-FunctionTemplate -Debug -InformationAction Continue -Verbose
