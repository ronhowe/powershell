function Open-ShellConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path = "$HOME\Shell.json"
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Opening Shell Configuration"
        notepad $Path
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
