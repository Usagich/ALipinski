$path = 'C:\git\ALipinski\PowerShell\Module-4\HtmlAgilityPack.dll'
$site = "https://github.com/trending"

[Reflection.Assembly]::LoadFile($path)|Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser($site) 

$main = @{
    GitHub_Trends = @()
}

for ($i = 0; $i -lt 25; $i++) {
    [HtmlAgilityPack.HtmlNodeCollection]$NameHtml = $doc.DocumentNode.SelectNodes("//li[$i]/div[1]/h3[1]/a[1]/text()")
    [HtmlAgilityPack.HtmlNodeCollection]$AddressHtml = $doc.DocumentNode.SelectNodes("//li[$i]/div[1]/h3[1]/a[1]")
    [HtmlAgilityPack.HtmlNodeCollection]$LanguageHtml = $doc.DocumentNode.SelectNodes("//li[$i]/div[4]/span[1]/span[2]/text()")
    [HtmlAgilityPack.HtmlNodeCollection]$StarsTotalHtml = $doc.DocumentNode.SelectNodes("//li[$i]/div[4]/a[1]/text()")
    [HtmlAgilityPack.HtmlNodeCollection]$StarsTodayHtml = $doc.DocumentNode.SelectNodes("//li[$i]/div[4]/span[3]/text()")

    $Name = $NameHtml.Text -replace '\s', ''
    $Address = $AddressHtml.InnerText -replace '\s', ''
    $Language = $LanguageHtml.InnerText -replace '\s', ''
    $StarsTotal = $StarsTotalHtml.Text -replace '\s', ''
    $StarsToday = $StarsTodayHtml.Text -replace '[a-z]', '' -replace '\s', ''
    
    $fullAddress += $site + $Address

    $main.GitHub_Trends += [ordered]@{
        Name       = $Name[$i];
        Address    = $fullAddress[$i];
        Language   = $Language[$i];
        StarsTotal = $StarsTotal[$i];
        StarsToday = $StarsToday[$i]
    }
}


$main | ConvertTo-Json | Out-File .\github.json

# $Name.Length


# New-Variable -Name "Top:$i" -Value 

# Get-Variable