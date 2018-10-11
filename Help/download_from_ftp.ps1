#ftp server 
$ftp = "ftp://waws-prod-db3-117.ftp.azurewebsites.windows.net" 
$user = "XX" 
$pass = "XXX"
$SetType = "bin"  
$remotePickupDir = Get-ChildItem 'c:\test' -recurse
$webclient = New-Object System.Net.WebClient 

$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  
foreach($item in $remotePickupDir){ 
    $uri = New-Object System.Uri($ftp+$item.Name) 
    #$webclient.UploadFile($uri,$item.FullName)
    $webclient.DownloadFile($uri,$item.FullName)
}
