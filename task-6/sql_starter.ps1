Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'test6'
)
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West Europe'
}

#$Template = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-6/main.json'
#$TemplatePar = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-6/main-parameters.json'

$Template = 'C:\git\ALipinski\task-6\azure-sql.json'
$TemplatePar = 'C:\git\ALipinski\task-6\azure-sql-parameters.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $Template -TemplateParameterFile $TemplatePar