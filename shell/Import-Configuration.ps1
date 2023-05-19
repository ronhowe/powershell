#requires -PSEdition "Core"
#requires -Module "ModuleBuilder"
[CmdletBinding()]
param (
)
begin {
    Write-Debug "Begin $($MyInvocation.MyCommand.Name)"

    Get-Variable -Scope "Local" -Include @($MyInvocation.MyCommand.Parameters.Keys) |
    Select-Object -Property @("Name", "Value") |
    ForEach-Object { Write-Debug "`$$($_.Name)=$($_.Value)" }
}
process {
    $ErrorActionPreference = "Stop"

    Write-Debug "Process $($MyInvocation.MyCommand.Name)"

    Write-Verbose "Importing Build Definition"
    $buildDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Build.psd1"
    $moduleDirectory = $buildDefinition.ModuleDirectory
    $outputDirectory = $buildDefinition.OutputDirectory
    $packageDirectory = $buildDefinition.PackageDirectory
    $sourceDirectory = $buildDefinition.SourceDirectory
    $testsDirectory = $buildDefinition.TestsDirectory
    Write-Debug "`$moduleDirectory=$moduleDirectory"
    Write-Debug "`$outputDirectory=$outputDirectory"
    Write-Debug "`$packageDirectory=$packageDirectory"
    Write-Debug "`$sourceDirectory=$sourceDirectory"
    Write-Debug "`$testsDirectory=$testsDirectory"

    Write-Verbose "Importing Certificate Definition"
    $certificateDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Certificate.psd1"
    $certificatePath = $certificateDefinition.Path
    $certificateThumbprint = $cercertificateDefinitionificate.Thumbprint
    Write-Debug "`$certificatePath=$certificatePath"
    Write-Debug "`$certificateThumbprint=$certificateThumbprint"

    Write-Verbose "Importing Module Definition"
    $moduleDefinition = Import-PowerShellDataFile -Path "$PSScriptRoot\Module.psd1"
    $moduleName = $moduleDefinition.Name
    $moduleVersion = $moduleDefinition.Version
    Write-Debug "`$moduleName=$moduleName"
    Write-Debug "`$moduleVersion=$moduleVersion"

    Write-Verbose "Setting Output Path"
    $outputPath = "$PSScriptRoot\$outputDirectory"
    Write-Debug "`$outputPath=$outputPath"

    Write-Verbose "Setting Module Path"
    $modulePath = "$outputPath\$moduleDirectory"
    Write-Debug "`$modulePath=$modulePath"

    Write-Verbose "Setting Package Path"
    $packagePath = "$outputPath\$packageDirectory"
    Write-Debug "`$packagePath=$packagePath"

    Write-Verbose "Setting Source Path"
    $sourcePath = "$PSScriptRoot\$sourceDirectory"
    Write-Debug "`$sourcePath=$sourcePath"

    Write-Verbose "Setting Tests Path"
    $testsPath = "$PSScriptRoot\$testsDirectory"
    Write-Debug "`$testsPath=$testsPath"
}
end {
    Write-Debug "End $($MyInvocation.MyCommand.Name)"
}
