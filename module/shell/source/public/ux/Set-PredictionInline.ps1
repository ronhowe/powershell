
function Set-PredictionInline {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Set-PSReadLineOption -PredictionViewStyle InlineView -WarningAction SilentlyContinue -Verbose
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
