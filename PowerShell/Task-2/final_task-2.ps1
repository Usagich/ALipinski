function Translate-English ([string]$inp) {
    $key = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    $from = "ru"
    $to = "en"
    $out = Invoke-RestMethod -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$inp&lang=$from-$to&format=plain"
    return $out.text
}

$main = @{
    text = @{
        paragraphs = @()
    }
}


$InpParagraphs = $inp.Split("`n")
$Inp = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')

for ($i = 1; $i -lt $InpParagraphs.Length; $i++) {
    [string[]]$paragraph = $InpParagraphs[$i]
    $Translated = Translate-English -inp $paragraph
    $Index = $i+1
    $main.text.paragraphs += [Ordered]@{
        Index      = "$Index";
        Original   = 'null';
        Translated = $Translated;
    }
}


#$main.text.paragraphs.Clear()
$main | ConvertTo-Json -Depth 10
$main.text.paragraphs
