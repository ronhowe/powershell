[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $SourceCdfPath = $PSScriptRoot,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $TargetCdfPath = $env:HOLOTABLE_PATH,

    [switch]
    $IncludeImages
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    $ErrorActionPreference = "Stop"

    Write-Verbose "Copying Card Definitions"
    Copy-Item -Path (Join-Path -Path $SourceCdfPath -ChildPath "*.cdf") -Destination $TargetCdfPath -Force -PassThru

    ## NOTE: Only needed if file hashes are incorrect.
    Write-Verbose "Asserting Include Images Switch"
    if ($IncludeImages) {
        Write-Verbose "Copying Card Images"
        Copy-Item -Path (Join-Path -Path $SourceCdfPaths -ChildPath "Images-HT\starwars") -Destination (Join-Path -Path $TargetCdfPath -ChildPath "cards") -Recurse -Force -PassThru
    }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
