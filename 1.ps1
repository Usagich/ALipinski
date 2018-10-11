login-azurermaccount
$subscb= "e6bc14a2-0713-4c44-9ea3-edb56ada4772"
select-AzureRmSubscription -SubscriptionId $subscb





login-azurermaccount

$subscb= "e6bc14a2-0713-4c44-9ea3-edb56ada4772"
select-AzureRmSubscription -SubscriptionId $subscb


#create vault and secret
$vaultname = "mykvfortask4"
Write-Host("login:azureuser | enter password for secret")
$password = read-host
New-AzureRmKeyVault `
  -VaultName $vaultname `
  -ResourceGroupName TestRG1 `
  -Location "westeurope" `
  -EnabledForTemplateDeployment `    
$secretvalue = ConvertTo-SecureString $password -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $vaultname -Name "testtaskfoursecret" -SecretValue $secretvalue

$Maindeploy= 'https://raw.githubusercontent.com/AzureLabDevOps/DBychkouski/master/test/main.json'
$Mainpar = 'https://raw.githubusercontent.com/AzureLabDevOps/DBychkouski/master/test/mainparam.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG1 -TemplateFile  $maindeploy -TemplateParameterUri $mainpar