$params = @{
    key     = 'trnsl.1.1.20181108T111043Z.f85c4ecbdca8a18f.f6d21f508063bc4448229ac30745b254de960f97'
    from    = "ru"
    to      = "en"
    textUrl = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/PowerShell/Module-3/text.txt'
}

function Yandex-Translater {

    [CmdletBinding()]
    Param(
        [string]$textUrl,
        [string]$key,
        [string]$from,
        [string]$to) 
    Begin {
        $main = @{
            text = @{
                paragraphs = @()
            }
        }
        $text = Invoke-WebRequest -Uri $textUrl
        $InpParagraphs = $text.Content.Split("`n")
    }
    
    Process {
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
    }

    End {
        $main | ConvertTo-Json -Depth 10 | Out-File .\text.json
        $main | Export-Clixml -Depth 10 -Path text.xml
    }
}


Yandex-Translater @params
