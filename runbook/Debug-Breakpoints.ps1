[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]
    $InputObject = "MyInputObject"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Doing Something"

    Write-Host $InputObject
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
