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

        Write-Verbose "Defining Function"
        $command = "function $FunctionName() {" + (Get-Command -Name $FunctionName).Definition + "}"
        Write-Debug "`$command = $command"

        Write-Verbose "Defining Script Block From Function"
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
