function Translate-English ([string]$inp) {
    $key = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    $from = "ru"
    $to = "en"
    $out = Invoke-RestMethod -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$inp&lang=$from-$to&format=plain"
    write-output $out.text
}

$inp = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')

$main = @{
    text = @{
        paragraphs = @()
    }
}

foreach ($item in $inp.Split("`n")) {
    
    Translate-English -inp $item
}

for ($nomerString = 0; $nomerString -lt $strings.Length; $nomerString++) {
    if ($strings[$nomerString] -match "[a-z]") {
        $finalTest += $strings[$nomerString] + '.'
    }
    else {
        $finalTest += $rezStrings[$nomerString] + '.'
    }
}



for ($i = 1; $i -le $inp.Split("`n").Count; $i++) {
    $num = "$i"
    $main.text.paragraphs += @{
        "$num" = @{
            Original   = "Привет";
            Translated = "Hello";
        }
    }
}

#$main.text.paragraphs.Clear()
$main | ConvertTo-Json -Depth 10
$main.text.paragraphs
