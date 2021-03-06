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

$proc | Select-Object Name, @{name = 'Uptime'; Expression = {« {0:n0}» -f $_.UpTime.TotalMinutes}};

$proc | Get-Member

$proc.UpTime.TotalMinutes


$iexp = new-object –comobject "InternetExplorer.Application"
$iexp.navigate("www.williamstanek.com")
$iexp.visible = $true

function speaker {
    param (
        [Parameter(Mandatory = $false)]
        $GitText = 'https://raw.githubusercontent.com/AzureLabDevOps/ALipinski/master/PowerShell/text.txt'
    )
    $day = (Get-Date).DayOfWeek
    $text = Invoke-WebRequest -Uri $GitText
    $text.Content
    $voice = new-object -comobject "SAPI.SPVoice"
    $voice.speak("happy $day $($text.Content)")
}

Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 `
    -ComputerName . | Format-List * 


workflow hello {
    'Hello World'
}

workflow Invoke-ParallelForEach {
    foreach -parallel ($i in 1..10) {
        InlineScript 
        {
            "foo: $using:i"
        }
        $count = Get-Process -Name PowerShell* | Measure-Object | Select-Object -ExpandProperty Count
        "Number of PowerShell processes = $count"
    }
} 
$startcount = Get-Process -Name PowerShell* | Measure-Object |Select-Object -ExpandProperty Count
"Number of starting PowerShell processes = $startcount"
Invoke-ParallelForEach


for ($i = 0; $i -lt 5; $i++) {

    Write-Host $i
    $Private:S = 'sdfsdfs'
    
}

Write-Host $s




(Get-Date).Year -100