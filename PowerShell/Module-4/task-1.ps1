$log = ".\dism.log"
$errors = (Get-Content $log).Split("`n") | where {$_ -match "^(.{21})error"}
foreach ($item in $errors) {
    if (($item -match "(?<=hr:0x).*\+?(?=\))") -or ($item -match "(?<=HRESULT\=).*$")) {
        "`tERROR_CODE:$($Matches[0]) " + $item | out-file -Append .\errors.txt
    }
}
