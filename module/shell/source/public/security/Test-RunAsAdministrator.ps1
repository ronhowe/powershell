function Test-RunAsAdministrator {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $identity = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())
        return $identity.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
