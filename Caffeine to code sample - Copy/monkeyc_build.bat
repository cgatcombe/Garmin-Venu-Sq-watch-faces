@echo off
set monkeyc=C:\Users\chris\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-4.0.6-2021-10-06-af9b9d6e2\bin
rem set device=vivoactive_hr
rem set device=venusq
set device=fenix5plus
set prg=SurfsUp.prg

echo ConnectIQ...
call %monkeyc%\connectiq
timeout 5
echo MonkeyC...
rem call %monkeyc%\monkeyc -d %device% -f monkey.jungle -o %prg% -y .vscode\developer_key -z resources/layouts/WatchFace.xml -z resources/strings/strings.xml
call %monkeyc%\monkeyc -d %device% -f monkey.jungle -o %prg% -y .vscode\developer_key 
rem pause
echo MonkeyDo...
call %monkeyc%\monkeydo %prg% %device%