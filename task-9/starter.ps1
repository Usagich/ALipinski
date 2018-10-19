Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)

$template = "C:\git\ALipinski\task-9\vm_and_network.json"

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -Verbose