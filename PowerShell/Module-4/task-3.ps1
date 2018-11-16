$urifile = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
Invoke-WebRequest -Uri $urifile -OutFile "nuget.exe" -UseBasicParsing -Verbose 
.\nuget.exe install HtmlAgilityPack -Version 1.8.10 
$site = "https://github.com/trending"

[Reflection.Assembly]::LoadFile("$PWD\HtmlAgilityPack.1.8.10\lib\Net45\HtmlAgilityPack.dll") | Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser($site) 
[HtmlAgilityPack.HtmlNodeCollection]$nodes = $doc.DocumentNode.SelectNodes("//html/body/div[4]/div[2]/div/div[1]/div[2]/ol/*")

$main = @{
    GitHub_Trends = @()
}

for ($i = 0; $i -lt $nodes.Count; $i++) {
    $Name = (($nodes[$i].InnerText.Split("`n"))[2]).Replace(" ", "").Trim()
    $Address = "https://github.com/$Name"
    ($nodes[$i].InnerText.Split("`n"))[6] -match "((.*)\s)?(.*\d)\s(.*\d)\s(.*\w)\s(.*\w)(.*\s)(.*\d)" | Out-Null
    $Language = $Matches[1]
    $Starstoday = $Matches[8]
    $Starstotal = $Matches[3]

    $repo = [ordered]@{
        Name       = $Name
        Address    = $Address
        Language   = $Language
        Starstoday = $Starstoday
        Starstotal = $Starstotal
    }
    $main.GitHub_Trends += $repo
}

$main | ConvertTo-Json | Out-File .\github.json
