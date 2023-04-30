# safety
throw

# dependencies
Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.Websites"

# context
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
$configuration = Import-PowerShellDataFile -Path ".\Configuration.psd1"
$configuration
$tenantId = $configuration.tenantId
$subscriptionName = $configuration.subscriptionName
$resourceGroupName = $configuration.resourceGroupName
$appName = $configuration.appName
$planName = $configuration.planName
$location = $configuration.location

# authenticate
Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -UseDeviceAuthentication

# resources
New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name (New-Guid) -TemplateFile ".\template.json" -TemplateParameterFile ".\parameters.json" -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name $resourceGroupName
Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName
Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $planName

Remove-AzResourceGroup -Name $resourceGroupName -Force -Verbose

# publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish"
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath ".\deploy.zip" -Force -Verbose

# test
Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet test
