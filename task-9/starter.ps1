Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)

$template = "C:\git\ALipinski\task-9\vm_and_network.json"

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -Verbose

Set-AzureRMStorageBlobContent - "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9/Workflow_Stop-AzureVM.ps1" `
    -Container $containerName `
    -Blob "Image001.jpg" `
    -Context $ctx 

$workflowURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9/Workflow_Stop-AzureVM.ps1"
$workflow = "$env:TEMP\main-parameters.json"

Invoke-WebRequest -Uri $workflowURI -OutFile $workflow

Set-AzureRMStorageBlobContent - `
    -Container $containerName `
    -Blob "Image001.jpg" `
    -Context $ctx 