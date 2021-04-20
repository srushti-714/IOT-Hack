Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 
 

#Import Common Functions
#. cloudlabs-common\cloudlabs-windows-functions.ps1
$path = pwd 
$ImportCommonFunctions = $path.Path + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $ImportCommonFunctions


#Run Common Functions
WindowsServerCommon
InstallEdgeChromium
DisableServerMgrNetworkPopup
Disable-InternetExplorerESC
Enable-IEFileDownload


#Download and Install IoT simulator
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://experienceazure.blob.core.windows.net/iotapp/Setup.msi","C:\LabFiles\Setup.msi")

$Directory= "C:\Packages"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("https://raw.githubusercontent.com/srushti-714/IOT-Hack/main/setup/logontask.ps1","C:\Packages\logontask.ps1")

#Enable Autologon
$AutoLogonRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultUsername" -Value "$($env:ComputerName)\hackuser" -type String  
Set-ItemProperty -Path $AutoLogonRegPath -Name "DefaultPassword" -Value "Password.1!!" -type String
Set-ItemProperty -Path $AutoLogonRegPath -Name "AutoLogonCount" -Value "1" -type DWord

# Scheduled Task
$Trigger= New-ScheduledTaskTrigger -AtLogOn
$User= "$($env:ComputerName)\hackuser" 
$Action= New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe" -Argument "-executionPolicy Unrestricted -File $Directory\logontask.ps1"
Register-ScheduledTask -TaskName "setup" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force 

Restart-Computer -Force
