throw

#region dependencies
Get-Module -Name "Az" -ListAvailable
Find-Module -Name "Az" -Repository "PSGallery"
Install-Module -Name "Az" -Repository "PSGallery" -Force
#endregion dependencies

#region imports
Import-Module -Name "Az.Accounts"
Import-Module -Name "Az.Websites"
#endregion imports

#region context
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
$configuration = Import-PowerShellDataFile -Path ".\Configuration.psd1" ; $configuration
$tenantId = Read-Host -Prompt "tenantId" ; $tenantId
$subscriptionName = Read-Host -Prompt "subscriptionName" ; $subscriptionName
$resourceGroupName = $configuration.resourceGroupName ; $resourceGroupName
$appName = $configuration.appName ; $appName
$planName = $configuration.planName ; $planName
$location = $configuration.location ; $location
#endregion context

#region authenticate
Connect-AzAccount -SubscriptionName $subscriptionName -TenantId $tenantId -UseDeviceAuthentication
#endregion authenticate

#region resources
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force -Verbose
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name (New-Guid) -TemplateFile ".\template.json" -TemplateParameterFile ".\parameters.json" -Mode Incremental -Force -Verbose

Get-AzResourceGroup -Name $resourceGroupName
Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName
Get-AzAppServicePlan -ResourceGroupName $resourceGroupName -Name $planName

Remove-AzResourceGroup -Name $resourceGroupName -Force -Verbose
#endregion resources

#region unit test
Set-Location -Path "$HOME\repos\ronhowe\dotnet"
dotnet build
dotnet test
#endregion unit test

#region publish
dotnet build
dotnet publish
Set-Location -Path "$HOME\repos\ronhowe\dotnet\WebApplication1\bin\Debug\net7.0\publish" -ErrorAction Stop
Compress-Archive -Path * -DestinationPath ".\deploy.zip" -Force -Verbose
Publish-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName -ArchivePath ".\deploy.zip" -Force -Verbose
#endregion publish

#region integration test @ kestrel
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
Invoke-Pester -Path ".\Azure.Tests.ps1" -Output Detailed -TagFilter "kestrel"
#endregion integration test @ kestrel

#region integration test @ docker
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
Invoke-Pester -Path ".\Azure.Tests.ps1" -Output Detailed -TagFilter "docker"
#endregion integration test @ docker

#region integration test @ app service
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
Invoke-Pester -Path ".\Azure.Tests.ps1" -Output Detailed -TagFilter "appservice"
#endregion integration test @ app service

#region integration test @ api gateway
Set-Location -Path "$HOME\repos\ronhowe\powershell\azure"
Invoke-Pester -Path ".\Azure.Tests.ps1" -Output Detailed -TagFilter "apigateway"
#endregion integration test @ api gateway
