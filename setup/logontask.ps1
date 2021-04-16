Set-ExecutionPolicy -ExecutionPolicy bypass -Force
Start-Transcript -Path C:\WindowsAzure\Logs\logontasklogs.txt -Append

#Install IOT simulator
Start-Process msiexec.exe -Wait '/I C:\LabFiles\Setup.msi /qn' -Verbose

Unregister-ScheduledTask -TaskName "setup" -Confirm:$false 
Stop-Transcript
