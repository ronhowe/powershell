function New-ShellConfiguration {
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

        Write-Host "Copying Shell Configuration"
        Copy-Item -Path "$PSScriptRoot\Shell.json" -Destination $Path -Force
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
