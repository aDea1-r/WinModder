aDea1's Windows 10 Mining Settings Modder

This script will save you some time when setting up your new mining rig, by automatically setting optimal power settings, and a virtual memory page size,
installing gpedit, setting a large page size, setting explorer to show all file extensions, install chrome, install notepad++, install Winrar, optionally 
install Teamviewer, disable automatic Windows Update, and disable automatic driver updates. This script has been tested on Windows 10 Home and Pro.

If this saved you some time, please consider leaving a donation:
Ethereum: 0xbA0d587A1E8eB194BB623796b089E1AF90d95441
Monero: 4AMfnd9arURLak1dVs6G4qQ1Fsw3686rwNLGDEp3oKCPbDRcmMQtHJD335bBMAb3Rj6XWQtawmvZdYjWhTHcUW3r45KKAMp
Electroneum: etnkKr6gsfsdX9TbcUdwvCCgjYykkWaEsKf3F5zThWYajTE6NDTKbgiRNbwLQux715apjhVTTWrv6GUha1F4rRip4Zb6zDXijB
Any amount is better than none, I'm not greedy! Every little bit helps towards making this script better! 
Developing this scirpt has been VERY time consuming, so show your support if you want me to keep going. 

I am /u/2001blader on reddit, and author of polarismining.blogspot.com. Please contact me if you find any bugs, and I will consider fixing them for the betterment of this script. 
NO HELP IS GUARANTEED. This script is released with no guaranteed support.

Credits:
CircusDad - List of Windows Tweaks Needed
TheJerichoJones - I shamelessly stole the admin elevation code from his hashmonitor script. The stucture of this code is also similar to his, since I was introduced to powershell through his script. 
Pratik Patil (https://stackoverflow.com/questions/37813441/powershell-script-to-set-the-size-of-pagefile-sys) - Pagefile Code, used under CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0/legalcode)
ASKVG.com (https://www.askvg.com/how-to-enable-group-policy-editor-gpedit-msc-in-windows-7-home-premium-home-basic-and-starter-editions/) - Provided Code for Enabling gpedit.msc on Windows Home. His bat is integrated into this script. 
KeepingITGeek (http://keepingitgeek.blogspot.com/2015/01/grant-sql-server-account-access-to-lock.html) - I shamelessly used his code for setting the large page size
Ninite - Application Installers for Chrome, Notepad, Teamviewer, and Winrar. 
TheSAS (https://superuser.com/questions/666891/script-to-set-hide-file-extensions) - Code for showing file extensions

This work is licensed under a Creative Commons Attribution 4.0 International License. (https://creativecommons.org/licenses/by/4.0/). 
Please don't sue me, I don't know what I'm doing when it comes to licensing. Contact me if you have any issues.

-------------------------INSTRUCTIONS-------------------------
1) Edit aDea1's_WindowsModder_P2, and scroll down to User Modifiable Varriables. Change them if you desire, but they are fine on default.
   I reccomend Chrome Remote Desktop over Teamviewer, which is why Teamviewer installation is disabled by default. 
2) Double Click on start.cmd. Press Yes on any UAC boxes that come up. The script will ask you to click a button one or two times, so be ready. 
3) If and When your PC restarts, log back in and the script should resume. If it does not relaunch, then it is done and your PC is ready.
4) Be Patient. The script may hang on a black command prompt window for a few minutes. If it gets stuck on a black Window after reboot, close it and execute RunP2.cmd. 
5) Leave a donation, if you think I deserve one. 