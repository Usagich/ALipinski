$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$resourceGroupName = "testRG"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'North Europe'
}

$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-3-MainTemplate.json' 
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG -TemplateFile $templateFilePath
