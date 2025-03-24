function Set-PredictionList {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction SilentlyContinue -Verbose
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
