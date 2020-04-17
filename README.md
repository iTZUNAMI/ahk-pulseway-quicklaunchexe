# Pulseway remote lauch exe, psexec fix #
Main thread: https://forum.pulseway.com/topic/2436-launch-exe-files-with-pulseway/

my fix:

hello, i just want to share my solution for this problem: often the parameter -i 1 will not work when your current user has a different interface ID, so when launching some programs, like PLEX Web Server for example the program will be launched with wrong settings/default settings instead of your current users settings. For some programs there are no difference but i found this problem for plex and others tool.

You can get the current ID with this command on powershell: query session and use it on the script/remote powershell every time or if you want here my solution

my solution, i hope can help someone

on pulseway script editor run as powershell this script :

cd\
cd "C:\myScriptRUN\PSTools"
.\id_plex.cmd


the script with this mod:

id_plex.cmd

for /f "tokens=4 delims= " %%G in ('tasklist /FI "IMAGENAME eq ctfmon.exe" /NH') do SET RDP_SESSION=%%G
echo Current RDP Session ID: %RDP_SESSION%
cd\
cd "C:\myScriptRUN\PSTools"
.\psexec.exe -i %RDP_SESSION% -d -u YOURUSERNAME -p YOURPASSWORD "S:\....\plex.exe"


This script will get the current ID from a classic process cftfom.exe (for example) that is usually with the current ID of the user and than run psexec with that ID

Username and password are optional but I recommend them.

PS: yes the first time run /accepteula and follow the guide to add psexec for windows %path%


#one exe to run all -> S:\....\plex.exe

Instead of running different path for every program i have created this script to run different programs using the parameter number, so you can just update your main exe if there are any updates on your local paths

so replace this 
.\psexec.exe -i %RDP_SESSION% -d -u YOURUSERNAME -p YOURPASSWORD "S:\....\plex.exe"
with :
.\psexec.exe -i %RDP_SESSION% -d --u YOURUSERNAME -p YOURPASSWORD "S:\myREPO\pulseway\pulseway.exe" 1

Where :
pulseway.exe is this script 
and 
1 = your program, 
in my example 1 = plex, 2 = Team Viewer , 3 = etc..











