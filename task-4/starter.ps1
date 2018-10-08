Param(
    [Parameter(Mandatory=$False)]
    [string]$resourceGroupName = 'TestRG'
)
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'North Europe'
}

#$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/main.json' 
#New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath

$templateFilePath = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/public-ip-create.json" 
$templateFilePathPar = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/public-ip-create-parameters.json"
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $templateFilePathPar