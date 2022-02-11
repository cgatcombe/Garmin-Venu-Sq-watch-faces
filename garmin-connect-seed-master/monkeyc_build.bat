@echo off
set monkeyc=C:\Users\chris\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-4.0.6-2021-10-06-af9b9d6e2\bin
set device=venusq
rem set device=fenix5s
set prg=GarminConnectSeedMaster.prg

echo ConnectIQ...
call %monkeyc%\connectiq
timeout 10
echo MonkeyC...
call %monkeyc%\monkeyc -d %device% -f monkey.jungle -o %prg% -y .vscode\developer_key
rem pause
echo MonkeyDo...
call %monkeyc%\monkeydo %prg% %device%