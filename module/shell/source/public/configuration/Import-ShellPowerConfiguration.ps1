function Import-ShellPowerConfiguration {
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
            Write-Host "Creating New Shell Configuration Builder"
            $configBuilder = New-PowerConfig

            Write-Host "Adding Shell Configuration Sources"
            @(
                "$PSScriptRoot\Shell.json",
                "$HOME\Shell.json",
                $Path
            ) |
            Where-Object { $_ -and $_ -ne ""} |
            ForEach-Object {
                Write-Debug "`$_ = $_"
                Write-Host "Asserting Shell Configuration Source Exists"
                if (Test-Path -Path $_) {
                    Write-Host "Adding Shell Configuration Source"
                    $configBuilder |
                    Add-PowerConfigJsonSource -Path $_ |
                    Out-Null
                }
                else {
                    Write-Host "Shell Configuration Source Not Found"
                }
            }

            Write-Host "Building Shell Configuration"
            $config = $configBuilder |
            Get-PowerConfig
            Write-Debug "`$config = $config"

            Write-Host "Defining Shell Configuration Global Variable"
            New-Variable -Name "ShellConfig" -Value $config -Force -Scope "Global"

            Write-Host "Returning Shell Configuration"
            return $config
        }
        catch {
            Write-Error "Import Failed Because $($_.Exception.Message)"
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
