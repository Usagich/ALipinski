$path = $env:TEMP
$JobsCount = 3
$folders = (Get-ChildItem $path  | ? { $_.PSIsContainer}).FullName

foreach ($folder in $folders) {
    $running = Get-Job | ? { $_.State -eq 'Running' }
    if ($running.Count -lt $JobsCount) {
        Start-Job -ScriptBlock {
            param ($folder)
            Set-Location $folder
            Get-ChildItem $folder -Recurse
        } -Arg "$folder"
    }
    else {
        $running | Wait-Job 
    }
    $param += @((Get-Job -State Completed | Receive-Job).FullName)
    Get-Job -State Completed | remove-Job
}
$param