$resourceGroupName = 'task7restore'
$storageAccount = get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName 
$ctx = $storageAccount.Context
$container = Get-AzureRmStorageContainer -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccount.StorageAccountName

foreach ($item in $vm_links) {
    if (($item -like '*vhd') -and ($item -like '*osdisk*')) {
        $osDisk = $item 
    }elseif (($item -like '*vhd') -and ($item -like '*datadisk*')) {
        $dataDisk = $item     
    }
}

$vm_links = (Get-AzureStorageBlob -Container ($container.Name) -Context $ctx).ICloudBlob.Uri.AbsoluteUri