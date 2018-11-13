$path = 'C:\git'
$folders = (Get-ChildItem $path  | ? { $_.PSIsContainer}).FullName
foreach ($folder in $folders) {
    $running = Get-Job | Where-Object { $_.State -eq 'Running' }
    if ($running.Count -lt 3) {
        Start-Job -ScriptBlock {
            param ($folder)
            Set-Location $folder
            Get-ChildItem $folder
        } -Arg "$folder"
    }
    else {
        $running | Wait-Job 
    }
}

Get-Job -State Completed | Receive-Job
Get-Job  | remove-Job

