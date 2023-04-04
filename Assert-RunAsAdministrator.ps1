function Assert-RunAsAdministrator {
    $identity = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())

    if (-not $identity.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        throw "Process is not running with administrator privileges."
    }
}