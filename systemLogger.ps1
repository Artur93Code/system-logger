Function Log-Message()
{
 param
    (
    [Parameter(Mandatory=$true)] [System.Object[]] $Message
    )
 
    Try {
        #Get the current date
        $LogDate = (Get-Date).tostring("yyyyMMdd")
 
        #Get the Location of the script
        #$psise check if script is run by Windows PowerShell ISE
        If ($psise) {
            $CurrentDir = Split-Path $psise.CurrentFile.FullPath
        }
        Else {
            $CurrentDir = $Global:PSScriptRoot
        }
        #Frame Log File with Current Directory and date
        $LogFile = $CurrentDir+ "\Logs\" + $LogDate + ".txt"
 
        #Add Content to the Log File
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")

        $NumberOfProcesses = $Message.Count

        Add-content -Path $Logfile -Value "$TimeStamp $NumberOfProcesses Process(es)"
        foreach($Process in $Message){
            $WindowTitle = $Process.mainWindowTitle
            $Line = "$TimeStamp - $WindowTitle"
            Add-content -Path $Logfile -Value $WindowTitle
        }
        Add-content -Path $Logfile -Value ""
 
        Write-host "$Timestamp [Message] $NumberOfProcesses Process(es) has been Logged to File: $LogFile"

    }
    Catch {
        Write-host -f Red "Error:" $_.Exception.Message 
    }
}

Function Check-Process(){
 param()
    #Get all processes with mainWindowTitle (windowed)
    $Process = Get-Process | Where-Object {$_.mainWindowTitle} | Select-Object ProcessName, MainWindowTitle #| Format-Table Id, Name, mainWindowtitle -AutoSize

        Log-Message $Process
}
 
#Call the function to Log messages
while($true){
    Check-Process
    Start-Sleep -Seconds 10
}