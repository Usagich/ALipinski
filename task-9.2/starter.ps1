Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
Select-AzureRmSubscription -Subscriptionid $Sub

$storageAccountName = 'task9storage'
$containerName = "task9"
$blob_name = "Workflow_Stop-AzureVM.ps1"
$skuName = "Standard_LRS"
$location = 'West Europe'
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9.1/main.json'
$workflowURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-9.1/Workflow_Stop-AzureVM.ps1"
$workflow = "$env:TEMP\Workflow_Stop-AzureVM.ps1"
#Download from URI to %temp%
Invoke-WebRequest -Uri $workflowURI -OutFile $workflow

$resourceGroup = Get-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -ErrorAction SilentlyContinue

if (!$resourceGroup) {
    New-AzureRmResourceGroup `
        -Name $resourceGroupName `
        -Location 'West Europe'
}

$storageAccount = Get-AzureRmStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -ErrorAction SilentlyContinue

if (!$storageAccount) {
    New-AzureRmStorageAccount `
        -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName `
        -Location $location `
        -SkuName $skuName
}

$storageAccountContext = (get-AzureRmStorageAccount `
        -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName).Context

New-AzureStorageContainer -Name $containerName `
    -Context $storageAccountContext `
    -Permission blob `
    -ErrorAction SilentlyContinue

Set-AzureStorageBlobContent -file  $workflow `
    -Container $containerName `
    -Blob $blob_name `
    -Context $storageAccountContext `
    -Force

Remove-Item $workflow

$accountKeys = Get-AzureRmStorageAccountKey `
    -ResourceGroupName "$ResourceGroupName" `
    -Name "$StorageAccountName"

$storageContext = New-AzureStorageContext `
    -StorageAccountName $StorageAccountName `
    -StorageAccountKey $accountKeys[0].Value

$sastokenurl = ConvertTo-SecureString -AsPlainText (New-AzureStorageBlobSASToken `
        -Container $containerName `
        -Blob $blob_name -Permission rwl `
        -StartTime (Get-Date).AddHours(-1) `
        -ExpiryTime (get-date).AddMonths(1) `
        -FullUri -Context $storageContext) -Force

$jobid = [System.Guid]::NewGuid().toString()

#Enter login name for VM
Write-Host "Please enter login name for VM: "
$vm_login = Read-Host

#Enter password for VM
Write-Host "Please enter password for VM: "
$vm_passwd = Read-Host -AsSecureString

#Enter password for app registration secret
Write-Host "Enter password for app registration secret: "
$app_pass = Read-Host -AsSecureString

$application = Get-AzureRmADApplication | `
    Where-Object {$_.HomePage -like "http://task9.com"}
    
$obj_id = $application.ObjectId

$app_id = ($application.ApplicationId).Guid

$app_key = Get-AzureRmADAppCredential `
    -ObjectId $obj_id `
    -ErrorAction SilentlyContinue

if ($app_key) {
    Remove-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Force

    New-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Password $app_pass
}
else {
    New-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Password $app_pass 
}

New-AzureRmResourceGroupDeployment `
    -TemplateUri $templateURI `
    -ResourceGroupName $resourceGroupName `
    -vm_login $vm_login `
    -vm_passwd $vm_passwd `
    -app_id $app_id `
    -app_pass $app_pass `
    -jobid $jobid `
    -sastokenurl $sastokenurl `
    -Verbose




