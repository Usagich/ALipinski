$path = $env:TEMP
$JobsCount = 6
$folders = (Get-ChildItem $path  | ? { $_.PSIsContainer}).FullName

function Get-ChildItemAsJob {
    param ($folder)
    Start-Job -ScriptBlock {
        param ($folder)
        Set-Location $folder
        Get-ChildItem $folder -Recurse
    } -Arg "$folder"
}

foreach ($folder in $folders) {
    $running = Get-Job | ? { $_.State -eq 'Running' }
    if ($running.Count -lt $JobsCount) {
        Get-ChildItemAsJob $folder
    }
    else {
        $running | Wait-Job
        Get-ChildItemAsJob $folder
    }
    $param += @((Get-Job -State Completed | Receive-Job).FullName)
    Get-Job -State Completed | remove-Job
}
$param