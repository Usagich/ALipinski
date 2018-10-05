$Sub = "1f1fe2e5-5f13-4687-aef3-063acc693dd3"
Select-AzureRmSubscription -Subscriptionid $Sub
$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/OwnTemplate.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG -TemplateFile $templateFilePath