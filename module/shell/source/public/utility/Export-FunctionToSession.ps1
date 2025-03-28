function Export-FunctionToSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.Runspaces.PSSession[]]
        $Session,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $FunctionName
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        Write-Verbose "Getting Function Definition"
        $command = "function $FunctionName() {" + (Get-Command -Name $FunctionName).Definition + "}"
        Write-Debug "`$command = $command"

        Write-Verbose "Creating Script Block From Function Definition"
        $scriptBlock = { Invoke-Expression $using:command }

        foreach ($node in $Session) {
            Write-Verbose "Exporting Script Block To Session"
            Invoke-Command -Session $node -ScriptBlock $scriptBlock
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
