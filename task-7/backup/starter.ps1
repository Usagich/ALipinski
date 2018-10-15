Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main.json'
$templateParametersURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/main-parameters.json"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West Europe'
}

New-AzureRmResourceGroupDeployment -TemplateUri $templateURI -ResourceGroupName $resourceGroupName -TemplateParameterUri $templateParametersURI
