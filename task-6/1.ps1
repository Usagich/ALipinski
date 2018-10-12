$dscStorageAccountRG = "Task4.1"

$dscStorageAccount = "mystorageaccounttask4"
$MyLOcation = "westeurope"
$dscName = 'FinalDSC.ps1.zip'
$TemplateParametersUri='https://raw.githubusercontent.com/daniilkorytko/Task4Final/master/FinalTemplateTask4Parametrs.json'
$TemplateParametersDSCUri='https://raw.githubusercontent.com/daniilkorytko/Task4Final/master/FinalDSC.ps1'

#new resource group
New-AzureRmResourceGroup -Name $dscStorageAccountRG -Location $MyLOcation

#new storage account
New-AzureRmStorageAccount -ResourceGroupName $dscStorageAccountRG -AccountName $dscStorageAccount -Location $MyLOcation -SkuName Standard_GRS 

$ParametersFilePath = "$env:TEMP\FinalJSON.json" 
$ParametersFilePath1 = "$env:TEMP\FinalDSC.ps1" 

#downoload file parametr.json
$webContent = Invoke-WebRequest -Uri $TemplateParametersUri
$webContent.Content | Out-File $ParametersFilePath

#downoload DSC file parametr
Invoke-WebRequest -Uri $TemplateParametersDSCUri -OutFile $ParametersFilePath1 

#create blob in storage accoun
Publish-AzureRmVMDscConfiguration -ConfigurationPath FinalDSC.ps1 `
-ResourceGroupName $dscStorageAccountRG -StorageAccountName $dscStorageAccount -Force

$key = ((Get-AzureRMStorageAccountKey -ResourceGroupName $dscStorageAccountRG -Name $dscStorageAccount) | where {$_.KeyName -Like 'key1'}).Value
$ctx = New-AzureStorageContext -StorageAccountName $dscStorageAccount -StorageAccountKey $key
$sasToken = New-AzureStorageBlobSASToken -Container "windows-powershell-dsc" -Blob $dscName -Permission rwl `
-ExpiryTime ([DateTime]::Now.AddHours(1.0)) -FullUri -Context $ctx



New-AzureRmResourceGroupDeployment -ResourceGroupName $dscStorageAccountRG `
  -TemplateUri https://raw.githubusercontent.com/daniilkorytko/Task4Final/master/FinalTemplateTask4.json `
  -TemplateParameterFile FinalJSON.json  -DSC $sasToken
 