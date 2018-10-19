Param(
    [Parameter(Mandatory = $False)]
    [string]$resourceGroupName = 'task9'
)
Clear-Host
$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
$storageAccountName = 'task9storage'
$dscName = 'dsc-all.ps1.zip'
$templateURI = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/main.json'
$templateParametersURI = "https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/task-4/main-parameters.json"
$ParametersFilePath = "$env:TEMP\main-parameters.json"
$skuName = "Standard_LRS"



#Download from URI to %temp%
Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath

Select-AzureRmSubscription -Subscriptionid $Sub

$resourceGroup = Get-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -ErrorAction SilentlyContinue

$storageAccount = Get-AzureRmStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName 

if (!$resourceGroup) {
    New-AzureRmResourceGroup `
        -Name $resourceGroupName `
        -Location 'West Europe'
}
 
if (!$storageAccount) {
    New-AzureRmStorageAccount `
        -ResourceGroupName $resourceGroupName `
        -Name $storageAccountName `
        -Location $location `
        -SkuName $skuName
}

$accountKeys = Get-AzureRmStorageAccountKey `
    -ResourceGroupName "$ResourceGroupName" `
    -Name "$StorageAccountName"

$storageContext = New-AzureStorageContext `
    -StorageAccountName $StorageAccountName `
    -StorageAccountKey $accountKeys[0].Value
    
$sastokenurl = New-AzureStorageBlobSASToken `
    -Container "windows-powershell-dsc" `
    -Blob $dscName -Permission rwl `
    -StartTime (Get-Date).AddHours(-1) `
    -ExpiryTime (get-date).AddMonths(1) `
    -FullUri -Context $storageContext

New-AzureRmResourceGroupDeployment -TemplateUri $templateURI -ResourceGroupName $resourceGroupName -sastokenurl $sastokenurl -TemplateParameterFile $ParametersFilePath

Remove-Item $ParametersFilePath
