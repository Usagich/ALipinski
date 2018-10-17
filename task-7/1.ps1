$resourceGroupName = 'task7restore'
$storageAccount = get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName 
$ctx = $storageAccount