Param(
    [Parameter(Mandatory=$False)]
    [string]$resourceGroupName = 'TestRG5'
)
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West Europe'
}

$Template = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4-3/main.json'
$TemplatePar = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4-3/main-parameters.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG5 -TemplateUri $Template -TemplateParameterUri $TemplatePar
