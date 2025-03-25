[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]
    $LogsPath = "D:\home\LogFiles\MyLogs"
)
begin {
    Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
}
process {
    Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Truncating Database Table"
    Invoke-SqlCmd -ConnectionString "Server=LOCALHOST;Database=MyDatabase;Integrated Security=True;Application Name=$($MyInvocation.MyCommand.Name);Encrypt=False;Connect Timeout=1;Command Timeout=0;" -Query "TRUNCATE TABLE [MyTable];"
    
    Write-Verbose "Removing Azure Storage Table"
    New-AzStorageContext -ConnectionString "UseDevelopmentStorage=true;" |
    Get-AzStorageTable -Name "MyCloudTable" -ErrorAction SilentlyContinue |
    Remove-AzStorageTable -Name "MyCloudTable" -Force
    
    Write-Verbose "Removing Log Files"
    Get-ChildItem -Path $LogsPath -Recurse |
    Remove-Item -Force -ErrorAction Continue
}
end {
    Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
}
