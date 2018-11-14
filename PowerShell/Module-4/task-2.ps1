$params = @{
    key     = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    from    = "ru"
    to      = "en"
    textUrl = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/PowerShell/Module-3/text.txt'
}
function Yandex-Translater {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^http")][string]$textUrl,
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^trnsl")][string]$key,
        [Parameter(Mandatory = $true)]
        [ValidatePattern("ru|en")][string]$from,
        [Parameter(Mandatory = $true)]
        [ValidatePattern("ru|en")][string]$to)
        $main = @{
            text = @{
                paragraphs = @()
            }
        }
        try {
            $text = Invoke-WebRequest -Uri $textUrl
            $InpParagraphs = $text.Content.Split("`n")
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
                        Translated = "$((Invoke-RestMethod -Uri "https://translate.yandex.net/api/v1.5/tr.json/translate?key=$key&text=$($InpParagraphs[$i])&lang=$from-$to&format=plain").text)"
                    }
                }
            }
            $main | ConvertTo-Json -Depth 10 | Out-File .\text.json
            $main | Export-Clixml -Depth 10 -Path text.xml
        }
        catch [System.NotSupportedException] {
            Write-Host -BackgroundColor Yellow -ForegroundColor Red ($error[0].Exception).Message
        }
        catch [System.Net.WebException] {
            Write-Host -BackgroundColor Yellow -ForegroundColor Red ($error[0].Exception).Message
        }
        catch {
            Write-Host -BackgroundColor Yellow -ForegroundColor Red "You have some problems with your code" 
        }
}

try {
    Yandex-Translater @params
}
catch [System.Management.Automation.ParameterBindingException] {
    Write-Host ($error[0].Exception).Message
}
