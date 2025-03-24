function Get-HostByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("Name", "Node", "NodeName", "VMName")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ComputerName
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        foreach ($computer in $ComputerName) {
            try {
                [System.Net.Dns]::GetHostByName($computer).HostName.ToUpper()
            }
            catch {
                Write-Error "Error converting $computer to fully qualified domain name."
            }
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
