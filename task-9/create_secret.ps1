
$password = Read-Host -AsSecureString

New-AzureRmADAppCredential `
    -ObjectId 'db9611c2-b3b9-4ba0-9b1f-3440e83e56c3' -Password $password

$ADApp = Get-AzureRmADApplication -DisplayName "task9"
write-host $ADApp.ApplicationId



$application = Get-AzureRmADApplication | `
    where {$_.HomePage -like "http://task9.com"}
    
$obj_id = $application.ObjectId

$app_key = Get-AzureRmADAppCredential `
    -ObjectId $obj_id `
    -ErrorAction SilentlyContinue

if ($app_key) {
    Remove-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Force
}
else {
    New-AzureRmADAppCredential `
        -ObjectId $obj_id `
        -Password $password 
}