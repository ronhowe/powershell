function Test-RunAsAdministrator {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Getting Current Identity"
        $identity = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())
        Write-Debug "`$identity = $identity"

        Write-Verbose "Returning Administrator Is In Administrator Role"
        return $identity.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
