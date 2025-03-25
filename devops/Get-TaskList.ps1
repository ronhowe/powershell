[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    $Path = "$HOME\repos\ronhowe"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    ## TODO: Add ability to exclude filters by -Skip* parameters.
    Get-ChildItem -Path $Path -Include @("*.bicep", "*.cs", "*.json", "*.md", "*.ps*", "*.sql", "*.txt", "*.xml") -Recurse |
    Where-Object { $_.FullName -notlike "*\bin\*" -and $_.FullName -notlike "*\obj\*" } |
    Sort-Object -Property "FullName" |
    Select-String -Pattern "(LINK|NOTE|TODO)" -CaseSensitive |
    Select-Object -Property @("Path", @{Name = "Line"; Expression = { $_.Line.Trim() } }) |
    Where-Object { $_.Line -notlike "*(LINK|NOTE|TODO)*" }
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
