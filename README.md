# WinModder
Prepare Windows 10 to Mine Crypto

This script is designed to take you from a clean install of Windows 10, up to installing your GPU drivers. Don't worry if you have already made some of the tweaks included in the script, it won't affect those.

Download Latest Version

Here is a list of all the modifications the script will make:
Set power settings to never sleep, turn off screen, or turn off hard drive.
	You don't want your PC turning off while mining, do you? 
Setup windows virtual memory
Set a large page size
	This allows your miner to take full advantage of your memory, without running as admin
Install Group Policy Editor on Windows 10 Home
	Group Policy Editor is used for setting the large page size. It comes pre-installed on Windows 10 Pro. 
Install Notepad++, Google Chrome, and Winrar
Disable "hide file extensions of known file types"
Disable Automatic Windows Update
	You can still install updates  manually from time to time
	This will prevent Windows from restarting while you're away, and save you some downtime.
Disable automatic driver updates
	The newest AMD driver might not always work the same as the old ones when it comes to mining. This gives you the freedom to only update drivers when you see fit. 

Here's how to run the script:
Extract the zip to a folder, preferably on your desktop.
Right click aDea1's_WindowsModder_P2, and click edit. (Windows Powershell ISE takes a while to load, so be patient)
Scroll down to the User Modifiable Variables. (Line 40) There's two options to change here:
PageFileSize: This is the size of the virtual memory the script will setup (in GB). I recommend leaving it on the default 60 GB. This will eat up 60 GB of your hard drive. If you don't have enough space, Claymore recommends a minimum of 16 GB. 
installTeamViewer: If you want to use Teamviewer, change this to $true. Later in this guide, we will be installing Chrome Remote Desktop, which I find to be superior. However, you can use Teamviewer if you really want. 
Save the file, and close it. 
A few things to keep in mind before you run the script: 
Your PC may restart mid-script. If it does, just log back in and the script should resume shortly. It will also restart when done. 
Windows 10 Pro: 1 restart total
Windows 10 Home: 2 restarts total
If it gets stuck on an empty black window after the first restart, close it and run RunP2.cmd
Click Yes to any UAC boxes that come up. The script will ask you to click "close" on the ninite installer once its done, so be ready. 
Be patient, the script may hang for a few minutes sometimes.
Run start.cmd, and wait for the script to finish
Leave me a donation, if you are feeling generous.