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
Import-Module -Name "Az.ApplicationInsights"
Import-Module -Name "Az.OperationalInsights"
Import-Module -Name "Az.Resources"
Import-Module -Name "Az.Websites"

#endregion imports
###############################################################################

###############################################################################
#region secrets

Set-Secret -Name "tenantId"
Set-Secret -Name "subscriptionName"
Set-Secret -Name "credential" -Secret (Get-Credential)

#endregion secrets
###############################################################################

###############################################################################
#region authentication

$tenantId = Get-Secret -Name "tenantId" -AsPlainText
$subscriptionName = Get-Secret -Name "subscriptionName" -AsPlainText
$credential = Get-Secret -Name "credential"

Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -Credential $credential
az login --username $($credential.UserName) --password $($credential.Password | ConvertFrom-SecureString -AsPlainText) --tenant $tenantId
az account set --subscription $subscriptionName

Disconnect-AzAccount
az logout

#endregion authentication
###############################################################################

###############################################################################
#region resources

# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
# https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming-and-tagging-decision-guide

Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

$location = "eastus"
$resource = "rg-ronhowe-0"
$plan = "plan-ronhowe-0"
$app = "app-ronhowe-0"
$config = "config-ronhowe-0"
$log = "log-ronhowe-0"
$insights = "insights-ronhowe-0"
$parameters = ".\parameters.0.json"

#or

$location = "eastus"
$resource = "rg-ronhowe-1"
$plan = "plan-ronhowe-1"
$app = "app-ronhowe-1"
$config = "config-ronhowe-1"
$log = "log-ronhowe-1"
$insights = "insights-ronhowe-1"
$parameters = ".\parameters.1.json"

New-AzResourceGroup -Name $resource -Location $location -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resource -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile $parameters -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name $resource
Get-AzAppServicePlan -ResourceGroupName $resource -Name $plan
Get-AzWebApp -ResourceGroupName $resource -Name $app
Get-AzAppConfigurationStore -ResourceGroupName $resource -Name $config
Get-AzOperationalInsightsWorkspace -ResourceGroupName $resource -Name $log
Get-AzApplicationInsights -ResourceGroupName $resource -Name $insights

Remove-AzResourceGroup -Name $resource -Force -Verbose

#endregion resources
###############################################################################

###############################################################################
#region managed identity

$webApp = Get-AzWebApp -ResourceGroupName $resource -Name $app
$identity = $webApp.Identity

$appConfig = Get-AzAppConfigurationStore -ResourceGroupName $resource -Name $config 
New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "App Configuration Data Reader" -Scope $appConfig.Id

#endregion managed identity
###############################################################################

$appInsights = Get-AzApplicationInsights -ResourceGroupName $resource -Name $insights
$instrumentationKey = $appInsights.InstrumentationKey
$connectionString = $appInsights.ConnectionString

###############################################################################
#region settings

# https://mohitgoyal.co/2018/02/26/apply-update-application-settings-for-azure-app-service-using-powershell/

# danger! this wipes out *all* of the app settings and replaces them solely with what is specified here
Set-AzWebApp -ResourceGroupName $resource -Name $app -AppSettings @{ "AppConfig__Endpoint" = "https://$config.azconfig.io" } -Verbose

Restart-AzWebApp -ResourceGroupName $resource -Name $app -Verbose

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

$newAppSettings.CustomHeader = "$app"

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

az appconfig kv export --name $config --destination file --path .\configuration.json --yes --format json

Get-Content -Path .\configuration.json
code .\configuration.json

az appconfig kv import --name $config --source file --path .\configuration.json --yes --format json --import-mode all

# work in progress - trying to do the same as above but with Az PowerShell module (it may not be supported, have seen this before)

# $exportedConfig = Get-AzAppConfigurationKeyValue -Endpoint (Get-Secret -Name "endpoint" -AsPlainText)
# $exportedConfig | ConvertTo-Json | Out-File -FilePath .\appconfig.json

# $importedConfig = Get-Content -Path .\appconfig.json | ConvertFrom-Json
# Set-AzAppConfigurationKeyValue -Name $config -InputObject $importedConfig

#endregion configuration
###############################################################################

###############################################################################
#region continuous integration

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test

#endregion continuous integration
###############################################################################

###############################################################################
#region continuous deployment

Set-Location -Path "$HOME\repos\ronhowe\dotnet"
Remove-Item -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -Recurse -Force -Verbose -ErrorAction SilentlyContinue
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -ErrorAction Stop
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resource -Name $app -ArchivePath ".\deploy.zip" -Force -Verbose

#endregion build and deployment
###############################################################################

###############################################################################
#region live tests

Set-Location -Path "$HOME\repos\ronhowe\powershell\api"
.\Test-Api.ps1 -Name WebApplication1 -Platform AppService

#endregion live tests
###############################################################################
