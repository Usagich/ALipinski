Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task7'
)
Clear-Host
$StorageAccountName = 'task7storage'
#Generate random number for backup vault name

New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $StorageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2 

Publish-AzureRmVMDscConfiguration -ConfigurationPath "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-7/dsc.ps1" -ResourceGroupName TestRG5 -StorageAccountName $StorageAccountName

#Check resource group name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (!$resourceGroup) {
    New-AzureRmResourceGroup -Name $resourceGroupName -Location 'West Europe'
}

#Create SAS token for DSC
$accountKeys = Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $accountKeys[0].Value
$sastokenurl = New-AzureStorageBlobSASToken -Container "windows-powershell-dsc" -Blob $dscName -Permission rwl -StartTime (Get-Date).AddHours(-1) -ExpiryTime (get-date).AddMonths(1) -FullUri -Context $storageContext
