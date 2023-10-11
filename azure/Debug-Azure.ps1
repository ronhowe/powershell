<###############################################################################
https://github.com/ronhowe/dotnet
###############################################################################>

throw

###############################################################################
#region dependencies

Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force

#endregion dependencies
###############################################################################

###############################################################################
#region imports

Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.AppConfiguration"
Import-Module -Name "Az.Resources"
Import-Module -Name "Az.Websites"

#endregion imports
###############################################################################

###############################################################################
#region secrets

Set-Secret -Name "tenantId"
Set-Secret -Name "subscriptionName"
Set-Secret -Name "azure-user" -Secret (Get-Credential)

#endregion secrets
###############################################################################

###############################################################################
#region authentication

$tenantId = Get-Secret -Name "tenantId" -AsPlainText
$subscriptionName = Get-Secret -Name "subscriptionName" -AsPlainText

Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -Credential (Get-Secret -Name "azure-user")
az login --username $((Get-Secret -Name "azure-user").UserName) --password $((Get-Secret -Name "azure-user").Password | ConvertFrom-SecureString -AsPlainText) --tenant $tenantId
az account set --subscription $subscriptionName

Disconnect-AzAccount
az logout

#endregion authentication
###############################################################################

###############################################################################
#region resources

Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

$location = "eastus"
$resource = "rg-ronhowe-0"
$plan = "plan-ronhowe-0"
$app = "app-ronhowe-0"
$config = "config-ronhowe-0"
$parameters = ".\parameters.0.json"

#or

$location = "westus"
$resource = "rg-ronhowe-1"
$plan = "plan-ronhowe-1"
$app = "app-ronhowe-1"
$config = "config-ronhowe-1"
$parameters = ".\parameters.1.json"

New-AzResourceGroup -Name $resource -Location $location -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resource -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile $parameters -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name $resource
Get-AzAppServicePlan -ResourceGroupName $resource -Name $plan
Get-AzWebApp -ResourceGroupName $resource -Name $app
Get-AzAppConfigurationStore -ResourceGroupName $resource -Name $config

Remove-AzResourceGroup -Name $resource -Force -Verbose

#endregion resources
###############################################################################

###############################################################################
#region settings

# https://mohitgoyal.co/2018/02/26/apply-update-application-settings-for-azure-app-service-using-powershell/

# danger! this wipes out *all* of the app settings and replaces them solely with what is specified here
Set-AzWebApp -ResourceGroupName $resource -Name $app -AppSettings @{ "MockService1PermanentExceptionToggle" = "true" }

# preserve settings by exporting them, modifying them, importing them
$appSettings = (Get-AzWebApp -ResourceGroupName $resource -Name $app).SiteConfig.AppSettings |
Sort-Object -Property "Name"
$appSettings

$newAppSettings = @{}
foreach ($item in $appSettings) {
    $newAppSettings[$item.Name] = $item.Value
}
$newAppSettings

$newAppSettings.Add("AppConfig__Endpoint", "https://$config.azconfig.io")
$newAppSettings.CustomHeader = "default"
$newAppSettings.MockService1PermanentExceptionToggle = "false"
$newAppSettings.MockService1TransientExceptionToggle = "false"
$newAppSettings.MockService1CpuThrottleToggle = "false"
$newAppSettings.MockService1CpuThrottleIterations = 0

Set-AzWebApp -ResourceGroupName $resource -Name $app -AppSettings $newAppSettings

#endregion settings
###############################################################################

###############################################################################
#region configuration

Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

az appconfig kv export --name $config --destination file --path .\appconfig.json --yes --format json

Get-Content -Path .\appconfig.json
code .\appconfig.json

az appconfig kv import --name $config --source file --path .\appconfig.json --yes --format json --import-mode all

# work in progress - trying to do the same as above but with Az PowerShell module (it may not be supported, have seen this before)
# $exportedConfig = Get-AzAppConfigurationKeyValue -Endpoint (Get-Secret -Name "endpoint" -AsPlainText)
# $exportedConfig | ConvertTo-Json | Out-File -FilePath .\appconfig.json

# $importedConfig = Get-Content -Path .\appconfig.json | ConvertFrom-Json
# Set-AzAppConfigurationKeyValue -Name $config -InputObject $importedConfig

#endregion configuration
###############################################################################

###############################################################################
#region build and test

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test

#endregion build and test
###############################################################################

###############################################################################
#region build and publish

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
Remove-Item -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -ErrorAction Stop
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resource -Name $app -ArchivePath ".\deploy.zip" -Force -Verbose

#endregion build and publish
###############################################################################

###############################################################################
#region live tests

Set-Location -Path "$HOME\repos\ronhowe\powershell\api"
.\Test-Api.ps1 -Name WebApplication1 -Platform AppService

#endregion live tests
###############################################################################
