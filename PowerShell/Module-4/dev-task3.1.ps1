$dll = "$env:temp\HtmlAgilityPack.dll"
Invoke-WebRequest -Uri "https://github.com/AzureLabDevOps/ALipinski/raw/master/PowerShell/Module-4/HtmlAgilityPack.dll" -OutFile $dll
$site = "https://github.com/trending"

[Reflection.Assembly]::LoadFile($dll)|Out-Null
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.LoadFromBrowser($site) 
[HtmlAgilityPack.HtmlNodeCollection]$nodes = $doc.DocumentNode.SelectNodes("//li[@class='col-12 d-block width-full py-4 border-bottom']")

$main = @{
    GitHub_Trends = @()
}

for ($i = 0; $i -lt $nodes.Count; $i++) {
    $Name = ($nodes[$i].ChildNodes[1].ChildNodes[1].InnerText).replace(" ", '')
    $Address = "https://github.com/$Name"
    ($nodes[0].InnerText.Split("`n"))[6] -match "((.*)\s)?(.*\d)\s(.*\d)\s(.*\w)\s(.*\w)(.*\s)(.*\d)" | Out-Null
    $Language = $Matches[1]
    $Starstoday = $Matches[8]
    $Starstotal = $Matches[3]

    # if ( $nodes[$i].ChildNodes[7].ChildNodes[0].OuterHtml -match "programmingLanguage" ) {
    #     $Language = ($nodes[$i].ChildNodes[7].ChildNodes[0].InnerText).replace(" ", '')
    # }
    # else {$Language = "not found"}
    # $nodes[$i].ChildNodes[7].ChildNodes[4].InnerText -match ".*\d" | Out-Null
    # $Starstoday = $Matches[0]
    # $Starstotal = ($nodes[$i].ChildNodes[7].ChildNodes[1].InnerText).replace(" ", '')

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

Remove-Item $dll
