#region dependencies
Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force
#endregion dependencies

#region imports
Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.AppConfiguration"
Import-Module -Name "Az.Resources"
Import-Module -Name "Az.Websites"
#endregion imports

#region secrets
Set-Secret -Name "tenantId"
Set-Secret -Name "subscriptionName"
Set-Secret -Name "azure-user" -Secret (Get-Credential)
#endregion secrets

#region authenticate
$tenantId = Get-Secret -Name "tenantId" -AsPlainText
$subscriptionName = Get-Secret -Name "subscriptionName" -AsPlainText

Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -Credential (Get-Secret -Name "azure-user")
az login --username $((Get-Secret -Name "azure-user").UserName) --password $((Get-Secret -Name "azure-user").Password | ConvertFrom-SecureString -AsPlainText) --tenant $tenantId
az account set --subscription $subscriptionName

Disconnect-AzAccount
az logout
#endregion authenticate

#region resources
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

New-AzResourceGroup -Name "rg-ronhowe-0" -Location "eastus" -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName "rg-ronhowe-0" -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile ".\parameters.0.json" -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name "rg-ronhowe-0"
Get-AzAppServicePlan -ResourceGroupName "rg-ronhowe-0" -Name "plan-ronhowe-0"
Get-AzWebApp -ResourceGroupName "rg-ronhowe-0" -Name "app-ronhowe-0"

New-AzResourceGroup -Name "rg-ronhowe-1" -Location "westus" -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName "rg-ronhowe-1" -Name (New-Guid) -TemplateFile ".\template.bicep" -TemplateParameterFile ".\parameters.1.json" -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name "rg-ronhowe-1"
Get-AzAppServicePlan -ResourceGroupName "rg-ronhowe-1" -Name "plan-ronhowe-1"
Get-AzWebApp -ResourceGroupName "rg-ronhowe-1" -Name "app-ronhowe-1"

Remove-AzResourceGroup -Name "rg-ronhowe-0" -Force -Verbose
Remove-AzResourceGroup -Name "rg-ronhowe-1" -Force -Verbose
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
Publish-AzWebApp -ResourceGroupName "rg-ronhowe-0" -Name "app-ronhowe-0" -ArchivePath ".\deploy.zip" -Force -Verbose
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

$appSettings = (Get-AzWebApp -ResourceGroupName "rg-ronhowe-0" -Name "app-ronhowe-0").SiteConfig.AppSettings |
Sort-Object -Property "Name"
$appSettings

$newAppSettings = @{}
foreach ($item in $appSettings) {
    $newAppSettings[$item.Name] = $item.Value
}
$newAppSettings

$newAppSettings.CustomHeader = "default"
$newAppSettings.MockService1PermanentExceptionToggle = "false"
$newAppSettings.MockService1TransientExceptionToggle = "false"
$newAppSettings.MockService1CpuThrottleToggle = "false"
$newAppSettings.MockService1CpuThrottleIterations = 0

$newAppSettings.Add("AppConfig__Endpoint","https://config-ronhowe-0.azconfig.io")
$newAppSettings

Set-AzWebApp -ResourceGroupName "rg-ronhowe-0" -Name "app-ronhowe-0" -AppSettings $newAppSettings

#endregion break and fix

#region configuration
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"

az appconfig kv export --name "config-ronhowe-0" --destination file --path .\appconfig.json --yes --format json

Get-Content -Path .\appconfig.json
code .\appconfig.json

az appconfig kv import --name "config-ronhowe-0" --source file --path .\appconfig.json --yes --format json --import-mode all

# $exportedConfig = Get-AzAppConfigurationKeyValue -Endpoint (Get-Secret -Name "endpoint" -AsPlainText) --auth-mode login
# $exportedConfig | ConvertTo-Json | Out-File -FilePath .\appconfig.json

# $importedConfig = Get-Content -Path .\appconfig.json | ConvertFrom-Json
# Set-AzAppConfigurationKeyValue -Name "config-ronhowe-0" -InputObject $importedConfig
#endregion configuration
