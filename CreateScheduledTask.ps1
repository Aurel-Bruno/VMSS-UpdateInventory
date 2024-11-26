$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -Command "& {New-Item -Path C:\HotFix -ItemType Directory -Force; Get-Hotfix | Export-Csv -Path C:\HotFix\Get-Hotfix.csv -NoTypeInformation}"'
$trigger = New-ScheduledTaskTrigger -Daily -At 11pm
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "Daily Update Inventory" -Description "This is a scheduled task to run a PowerShell script to list Updates Installed on the server daily at 11 PM."