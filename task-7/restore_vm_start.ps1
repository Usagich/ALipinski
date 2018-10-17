Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7restore'
)

Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$templateRestoreURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/restore-main.json'
$location = 'West Europe'

Select-AzureRmSubscription -Subscriptionid $Sub

#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

$storageAccount = get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName
$ctx = $storageAccount.Context
$container = Get-AzureRmStorageContainer -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccount.StorageAccountName
$vm_links = (Get-AzureStorageBlob -Container ($container.Name) -Context $ctx).ICloudBlob.Uri.AbsoluteUri
foreach ($item in $vm_links) {
    if (($item -like '*vhd') -and ($item -like '*osdisk*')) {
        $osDisk = $item 
    }
    elseif (($item -like '*vhd') -and ($item -like '*datadisk*')) {
        $dataDisk = $item     
    }
}

#Deploy main template
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateUri $templateRestoreURI `
    -osDisk $osDisk `
    -dataDisk $dataDisk `
    -Verbose