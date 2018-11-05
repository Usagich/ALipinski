function scheck {
    param ($status)
    Begin {
        Write-Warning "############### Services on $env:computername"
    }
    Process {
        get-service | Where-Object { $_.status -eq $status}
    }
    End {
        Write-Warning "############################################"
    }
}



scheck stopped


get-command | where {$_.commandtype -eq "function"} | format-list


$proc = get-process chrome;
$proc | add-member -Type scriptproperty "UpTime" {return ((Get-Date) - ($this.starttime))};

$proc | Select-Object Name, @{name='Uptime'; Expression={«{0:n0}» -f $_.UpTime.TotalMinutes}};

$proc | Get-Member

$proc.UpTime.TotalMinutes


$iexp = new-object –comobject "InternetExplorer.Application"
$iexp.navigate("www.williamstanek.com")
$iexp.visible = $true

function speaker {
    param (
        [Parameter(Mandatory=$false)]
        [String[]]$text = 'Fuck you'
    )
    $voice = new-object -comobject "SAPI.SPVoice"
    $voice.speak("$text")
    
}

Invoke-WebRequest -Uri $templateParametersURI -OutFile $ParametersFilePath
