#Task 1-2
#$psswd = (Get-Random -Count 12 -InputObject ([char[]]"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) -join ''

$key = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
$url = 'https://translate.yandex.net/api/v1.5/tr/'
$detect = "$($url)detect?key=$key&text=$text"
$transl = "$($url)translate?key=$key&text=$text%t&lang=%l-en&format=plain"

#######################################################################################
$file = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')
foreach ($Sentence in (Get-Content $file)) {
    $i = $Sentence.Split("[`n]")
    $Sentences = $i.Length
}
$Sentences

$paragraphs = ((Get-Content $file).Split("`n"))

foreach ($item in $inp.Split("`n")) {
    Write-Host "`n" $item 
}


$newfile = $file.Split("`n")

$inp = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')

$MainParag = $inp.Split("`n")

function Translate-English ([string]$inp) {
    $key = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    $from = "ru"
    $to = "en"
    $out = Invoke-RestMethod -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$inp&lang=$from-$to&format=plain"
    write-output $out.text
}

Translate-English -inp $inp

$strings = $inp


$iphashes = @();
# for each array ip
for($i = 0; $i -lt $arrayip.Count; $i++){
    $hash = @{
        name = "Name";
        ip = $arrayip[$i];
    }
    # add hash to array of ip hashes
    $iphashes += $hash;
}

