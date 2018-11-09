$params = @{
    key  = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    from = "ru"
    to   = "en"
}

$main = @{
    text = @{
        paragraphs = @()
    }
}

function Yandex-Translater ([string]$inp, [string]$key, [string]$from, [string]$to) {
    Invoke-RestMethod -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$inp&lang=$from-$to&format=plain"
}

$Inp = (Get-Content 'C:\git\ALipinski\PowerShell\Task-2\text.txt')
$InpParagraphs = $inp.Split("`n")

for ($i = 0; $i -lt $InpParagraphs.Length; $i++) {
    if ($InpParagraphs[$i] -match "[a-z]") {
        $main.text.paragraphs += [Ordered]@{
            Index      = "$($i+1)";
            Original   = $InpParagraphs[$i];
            Translated = $InpParagraphs[$i]
        }
    }
    else {
        $main.text.paragraphs += [Ordered]@{
            Index      = "$($i+1)";
            Original   = $InpParagraphs[$i];
            Translated = "$((Yandex-Translater -inp $InpParagraphs[$i] @params).text)"
        }
    }
}
$main | ConvertTo-Json -Depth 10 | Out-File .\text.json

$main | Export-Clixml -Depth 10 -Path text.xml