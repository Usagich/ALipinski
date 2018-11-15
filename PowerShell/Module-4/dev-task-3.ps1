$path = 'C:\git\ALipinski\PowerShell\Module-4\HtmlAgilityPack.dll'
$site = "https://github.com/trending"

[Reflection.Assembly]::LoadFile($path)|Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser($site) 
[HtmlAgilityPack.HtmlNodeCollection]$NameHtml = $doc.DocumentNode.SelectNodes("//div[1]/h3[1]/a[1]/text()")
[HtmlAgilityPack.HtmlNodeCollection]$AddressHtml = $doc.DocumentNode.SelectNodes("//div[1]/h3[1]/a[1]")
[HtmlAgilityPack.HtmlNodeCollection]$LanguageHtml = $doc.DocumentNode.SelectNodes("//div[4]/span[1]/span[2]/text()")
[HtmlAgilityPack.HtmlNodeCollection]$StarsTotalHtml = $doc.DocumentNode.SelectNodes("//div[4]/a[1]/text()")
[HtmlAgilityPack.HtmlNodeCollection]$StarsTodayHtml = $doc.DocumentNode.SelectNodes("//div[4]/span[3]/text()")

$Name = $NameHtml.Text
$Address = $AddressHtml.InnerText -replace '\s', ''
$Language = $LanguageHtml.InnerText
$StarsTotal = $StarsTotalHtml.Text
$StarsToday = $StarsTodayHtml.Text  -replace '[a-z]', '' -replace '\s',''

$fullAddress = @()

foreach ($item in $Address) {
    $fullAddress += $site + $item
}

$main = @()

for ($i = 0; $i -lt $Name.Length; $i++) {
    $main += [ordered]@{
        Name       = $Name[$i];
        Address    = $fullAddress[$i];
        Language   = $Language[$i];
        StarsTotal = $StarsTotal[$i];
        StarsToday = $StarsToday[$i]
    }
}

$main | ConvertTo-Json | Out-File .\github.json

$Language.Length
$Name.Length
