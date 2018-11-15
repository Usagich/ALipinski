$path = 'C:\git\ALipinski\PowerShell\Module-4\HtmlAgilityPack.dll'
$site = "https://github.com/trending"

[Reflection.Assembly]::LoadFile($path)|Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser("https://github.com/trending") 
[HtmlAgilityPack.HtmlNodeCollection]$NameHtml = $doc.DocumentNode.SelectNodes("//div[@class='d-inline-block col-9 mb-1']/h3/a/text()")
[HtmlAgilityPack.HtmlNodeCollection]$AddressHtml = $doc.DocumentNode.SelectNodes("//div[@class='d-inline-block col-9 mb-1']/h3/a")
[HtmlAgilityPack.HtmlNodeCollection]$LanguageHtml = $doc.DocumentNode.SelectNodes("//span[@itemprop='programmingLanguage']")
[HtmlAgilityPack.HtmlNodeCollection]$StarsTotalHtml = $doc.DocumentNode.SelectNodes("//div[@class='f6 text-gray mt-2']/a[1]/text()")
[HtmlAgilityPack.HtmlNodeCollection]$StarsTodayHtml = $doc.DocumentNode.SelectNodes("//div[@class='f6 text-gray mt-2']/span[3]/text()")

$Name = $NameHtml.Text
$Address = $AddressHtml.InnerText
$Language = $LanguageHtml.InnerText
$StarsTotal = $StarsTotalHtml.Text
$StarsToday = $StarsTodayHtml.Text

$main = @()

for ($i = 0; $i -lt $Name.Length; $i++) {
    $main += [ordered]@{
        Name       = $Name[$i];
        Address    = $Address[$i];
        Language   = $Language[$i];
        StarsTotal = $StarsTotal[$i];
        StarsToday = $StarsToday[$i]
    }
}

$main | ConvertTo-Json | Out-File .\github.json
