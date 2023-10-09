#region dependencies
Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force
#endregion dependencies

#region imports
Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.Websites"
#endregion imports

#region secrets
Set-Secret -Name "tenantId"
Set-Secret -Name "subscriptionName"
#endregion secrets

#region authenticate
[string]$tenantId = Get-Secret -Name "tenantId" -AsPlainText -OutVariable tenantId
[string]$subscriptionName = Get-Secret -Name "subscriptionName" -AsPlainText
Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -UseDeviceAuthentication
#endregion authenticate

#region context
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
$configuration = Import-PowerShellDataFile -Path ".\Configuration.psd1" ; $configuration
$resourceGroupName = $configuration.resourceGroupName ; $resourceGroupName
$appName = $configuration.appName ; $appName
$planName = $configuration.planName ; $planName
$location = $configuration.location ; $location
#endregion context

#region resources
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name (New-Guid) -TemplateFile ".\template.json" -TemplateParameterFile ".\parameters.json" -Mode Incremental -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile ".\parameters.json" -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name $resourceGroupName -OutVariable "resourceGroup"
Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -OutVariable "webApp"
Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $planName -OutVariable "plan"

Remove-AzResourceGroup -Name $resourceGroupName -Force -Verbose
#endregion resources

#region unit test
Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test
#endregion unit test

#region publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
Remove-Item -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -ErrorAction Stop
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath ".\deploy.zip" -Force -Verbose
#endregion publish

#region integration test
Set-Location -Path "$HOME\repos\ronhowe\powershell\api"
.\Test-Api.ps1 -Name WebApplication1 -Platform AppService
.\Test-Api.ps1 -Name Application -Platform FrontDoor
#endregion integration test

#region break and fix

# https://mohitgoyal.co/2018/02/26/apply-update-application-settings-for-azure-app-service-using-powershell/

# does not preserver existing settings
# Set-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -AppSettings @{ "MockService1PermanentExceptionToggle" = "true" }

$webApp.SiteConfig.AppSettings | Sort-Object -Property "Name" -OutVariable "appSettings"

$newAppSettings = @{}
foreach ($item in $appSettings) {
    $newAppSettings[$item.Name] = $item.Value
}
$newAppSettings

# choose
$newAppSettings.MockService1PermanentExceptionToggle = "false"
$newAppSettings.MockService1TransientExceptionToggle = "false"
$newAppSettings.MockService1CpuThrottleToggle = "false"
$newAppSettings.MockService1CpuThrottleIterations = 0

# choose
$newAppSettings.MockService1PermanentExceptionToggle = "true"
$newAppSettings.MockService1TransientExceptionToggle = "true"
$newAppSettings.MockService1CpuThrottleToggle = "true"
$newAppSettings.MockService1CpuThrottleIterations = 20000

# choose
$newAppSettings.CustomHeader = "default"
$newAppSettings.CustomHeader = $appName

Set-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -AppSettings $newAppSettings

#endregion break and fix
