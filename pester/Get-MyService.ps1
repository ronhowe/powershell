function Get-MyService {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [boolean]
        $MyInput
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        return $MyInput
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
