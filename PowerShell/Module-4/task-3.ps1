$site = "https://github.com/trending"
[Reflection.Assembly]::LoadFile("$pwd\HtmlAgilityPack.dll") | Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser($site) 
[HtmlAgilityPack.HtmlNodeCollection]$nodes = $doc.DocumentNode.SelectNodes("//html/body/div[4]/div[2]/div/div[1]/div[2]/ol/*")

$main = @{
    GitHub_Trends = @()
}
 
foreach ($node in $nodes) {
    $Name = (($node.InnerText.Split("`n"))[2]).replace(' ', '').Trim()
    ($node.InnerText.Split("`n"))[6] -match "((.*)\s)?(.*\d)\s(.*\d)\s(.*\w)\s(.*\w)(.*\s)(.*\d)" | Out-Null

    $repo = [ordered]@{
        Name       = $Name
        Address    = "https://github.com/$Name"
        Language   = $Matches[1]
        Starstoday = $Matches[8]
        Starstotal = $Matches[3]
    }
    $main.GitHub_Trends += $repo
}

$main | ConvertTo-Json | Out-File .\github.json