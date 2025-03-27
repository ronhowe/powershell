function Import-ShellConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]
        $Path
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        try {
            Write-Host "Adding Shell Configuration Sources"
            @(
                "$PSScriptRoot\Shell.json",
                "$HOME\Shell.json",
                $Path
            ) |
            Where-Object { $_ -and $_ -ne "" } |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Host "Asserting Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Host "Adding Shell Configuration Source"
                    $global:ShellConfig = Get-Content -Path $_ |
                    ConvertFrom-Json
                }
                else {
                    Write-Host "Shell Configuration Source Not Found"
                }
            }
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }

        try {
            Write-Host "Adding Shell Configuration Sources"
            @(
                "$HOME\repos\ronhowe\azure\parameters.json"
            ) |
            Where-Object { $_ -and $_ -ne "" } |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Host "Asserting Azure Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Host "Importing Azure Shell Configuration"
                    Import-ShellAzureConfiguration -Path $_ |
                    Out-Null
                }
                else {
                    Write-Host "Azure Shell Configuration Source Not Found"
                }
            }
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }

        Write-Host "Returning Shell Configuration"
        return $global:ShellConfig
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
