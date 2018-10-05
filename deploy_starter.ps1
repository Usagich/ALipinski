$templateFilePath = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/OwnTemplate.json'
New-AzureRmResourceGroupDeployment -ResourceGroupName TestRG -TemplateFile $templateFilePath