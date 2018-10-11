Param(
    [Parameter(Mandatory=$False)]
    [string]$resourceGroupName = 'TestRG6'
)
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West US'
}

$Template = 'C:\git\ALipinski\task-5\main.json'
$TemplatePar = 'C:\git\ALipinski\task-5\main-parameters.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG5 -TemplateFile $Template -TemplateParameterFile $TemplatePar