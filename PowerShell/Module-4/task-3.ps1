$path = 'C:\git\ALipinski\PowerShell\Module-4\HtmlAgilityPack.dll'
[Reflection.Assembly]::LoadFile($path) | Out-Null
$site = "https://github.com/trending"

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.Load($site)

$repo_names = @()
# [HtmlAgilityPack.HtmlNodeCollection]$repo_names = $doc.DocumentNode.SelectNodes("//span[@class='text-normal']")
[HtmlAgilityPack.HtmlNodeCollection]$nameNodes = $doc.DocumentNode.SelectNodes("//div[@class='d-inline-block col-9 mb-1']/h3/a")
$nameNodes | ForEach-Object { $_.OuterHtml} | where {$_ -match "\/.*..\+?(?=`")"} | foreach {$repo_names += $Matches[0] + "`n"}
$repos = $repo_names.Split("`n")
$address = ""
for ($i = 0; $i -lt ($repos.Length)-1; $i++) {
    $address += "https://github.com" + $repos[$i] + "`n"
}
$addr = $address.Split("`n")