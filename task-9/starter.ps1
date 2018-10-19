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
$workflow = "$env:TEMP\Workflow_Stop-AzureVM.ps1"

Invoke-WebRequest -Uri $workflowURI -OutFile $workflow

$storageAccount = get-AzureRmStorageAccount -ResourceGroupName task9 `
  -Name "task9storage" 

$ctx = $storageAccount.Context


$containerName = "quickstartblobs"
New-AzureStorageContainer -Name $containerName -Context $ctx -Permission blob

Set-AzureStorageBlobContent -file  $workflow `
  -Container $containerName `
  -Blob "Workflow_Stop-AzureVM.ps1" `
  -Context $ctx 

