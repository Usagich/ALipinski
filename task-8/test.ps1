Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task8'
)
$location = 'West europe'
#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

$template = "C:\git\ALipinski\task-8\kbs.json"
$templateParameters = "C:\git\ALipinski\task-8\kbs-parameters.json"


New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -TemplateParameterFile $templateParameters `
    -Verbose