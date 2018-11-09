#Task 1-2
#$psswd = (Get-Random -Count 12 -InputObject ([char[]]"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) -join ''

#######################################################################################

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


$Inp = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')
$InpParagraphs = $inp.Split("`n")

for ($i = 0; $i -lt $InpParagraphs.Length; $i++) {
    $toOriginal = ''
    $toTranslate =''
    if ($InpParagraphs[$i] -match "[a-z]") {
        $toOriginal += $InpParagraphs[$i]
        $toTranslate += $InpParagraphs[$i]
    }
    else {
        $toOriginal += $InpParagraphs[$i]
        $toTranslate += Translate-English $InpParagraphs[$i]
    }
    $main.text.paragraphs += [Ordered]@{
        Index      = "$($i+1)";
        Original   = $toOriginal;
        Translated = $toTranslate;
    }
}

$main | ConvertTo-Json -Depth 10 | Out-File .\text.json

