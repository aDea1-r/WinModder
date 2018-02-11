<#
    aDea1's Windows 10 Mining Settings Modder Part 2
    Part 2 will do the rest of the stuff I said it would do. 

    This script will save you some time when setting up your new mining rig, by automatically setting optimal power settings, and a virtual memory page size,
    installing gpedit, setting a large page size, setting explorer to show all file extensions, install chrome, install notepad++, install Winrar, optionally 
    install Teamviewer, disable automatic Windows Update, and disable automatic driver updates.  
    
    If this saved you time, please consider leaving a donation:
    Ethereum: 0xbA0d587A1E8eB194BB623796b089E1AF90d95441
    Monero: 4AMfnd9arURLak1dVs6G4qQ1Fsw3686rwNLGDEp3oKCPbDRcmMQtHJD335bBMAb3Rj6XWQtawmvZdYjWhTHcUW3r45KKAMp
    Electroneum: etnkKr6gsfsdX9TbcUdwvCCgjYykkWaEsKf3F5zThWYajTE6NDTKbgiRNbwLQux715apjhVTTWrv6GUha1F4rRip4Zb6zDXijB
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

    Please don't sue me, I don't know what I'm doing when it comes to licensing. Contact me if you have any issues. 
#>

####################################################################################
#    There are varriables you may want to change
#    Please scroll down to do so
####################################################################################
$ver = "1.0"
$Host.UI.RawUI.WindowTitle = "aDea1's Windows 10 Mining Settings Modder v $ver"
$Host.UI.RawUI.BackgroundColor = "DarkBlue"

Push-Location $PSScriptRoot
####################################################################################
#    User Modifiable Varriables: Optional to Change
####################################################################################
$PageFileSize = 60 #Pagefile.sys file, in GB.
$installTeamviewer = $false #Change to $true to install Teamviewer
####################################################################################
#    End User Modifiable Varriables: Do Not Change Anything Below Here
####################################################################################

###### Start Functions ######

function powerSettings 
{
    Write-Host "Changing Power Settings"
    Write-Host "Setting Screen Timeout to Never"
    powercfg -change -monitor-timeout-ac 0
    Write-Host "Setting Standby Timeout to Never"
    powercfg -change -standby-timeout-ac 0
    Write-Host "Setting Hard Disk Timeout to Never"
    powercfg -change -disk-timeout-ac 0
    Write-Host "Done"
}

function virtualMemory 
{
    Write-Host "Setting up Virtual Memory"
    $computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
    $computersys.AutomaticManagedPagefile = $False;
    $computersys.Put();
    $pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
    $pagefile.InitialSize = 1000*$PageFileSize;
    $pagefile.MaximumSize = 1000*$PageFileSize;
    $pagefile.Put();
    Write-Host "Done"
}

function pageSize 
{
    Write-Host "Setting Large Page Size"
    
    # Search for then add SQL group to SecPol and also grant an account to Lock Pages in Memory

    # Variables used - change as required
    $TempLocation = "$PSScriptRoot"
    $SQLServiceAccount = "$env:COMPUTERNAME\$env:UserName" #Account used for the SQL Service
    $SQLInstance = "MSSQLSERVER"

    # Variables that you don't need to change

    # This is the line we need to change in the cfg file
    $ChangeFrom = "SeManageVolumePrivilege = "
    $ChangeFrom2 = "SeLockMemoryPrivilege = "

    # Build the new line using local computername (needs the ` to escape the $)
    $ChangeTo = "SeManageVolumePrivilege = SQLServerSQLAgentUser$" + $env:computername + "`$" + "$SQLInstance,"
    $ChangeTo2 = "SeLockMemoryPrivilege = $SQLServiceAccount,"

    # Check if temp location exists and create if it doesn't

    IF ((Test-Path $TempLocation) -eq $false)
    {
        New-Item -ItemType Directory -Force -Path $TempLocation
        Write-Host "Folder $TempLocation created"
    }

    # Set a name for the Security Policy cfg file.
    $fileName = "$TempLocation\SecPolExport.cfg"

    #export currect Security Policy config
    Write-Host "Exporting Security Policy to file"
    secedit /export /cfg $filename

    # Use Get-Content to change the text in the cfg file and then save it
    (Get-Content $fileName) -replace $ChangeFrom, $ChangeTo | Set-Content $fileName

    # As the line for SeLockMemoryPrivilege only exists if there is something already in the group
    # this will check for it and add your $SQLServiceAccount or use Add-Contect to append SeLockMemoryPrivilege and your $SQLServiceAccount
    IF ((Get-Content $fileName) | where { $_.Contains("SeLockMemoryPrivilege") })
    {
        Write-Host "Appending line containing SeLockMemoryPrivilege with $SQLServiceAccount"
        (Get-Content $fileName) -replace $ChangeFrom2, $ChangeTo2 | Set-Content $fileName
    }
    else
    {
        Write-Host "Adding new line containing SeLockMemoryPrivilege"
        Add-Content $filename "`nSeLockMemoryPrivilege = $SQLServiceAccount"
    }

    # Import new Security Policy cfg (using '1> $null' to keep the output quiet)
    Write-Host "Importing Security Policy..."
    secedit /configure /db secedit.sdb /cfg $fileName 1> $null
    Write-Host "Security Policy has been imported"
}

function ninite
{
    Write-Host "Installing Chrome, Notepad++, and Winrar"
	Write-Host "Please Click Close When Ninite Finishes"
    Start-Process "Ninite Chrome Notepad WinRAR Installer.exe" -wait
    if ($installTeamviewer) {
        Write-Host "Installing TeamViewer"
		Write-Host "Please Click Close When Ninite Finishes"
        Start-Process "Ninite TeamViewer 13 Installer.exe" -wait
    }
    Write-Host "Done"
}

function showFileExtensions 
{
    Write-Host "Setting Explorer to Show Extensions for Known File Types"
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
	Write-Host "Done"
}

function disableUpdates
{    
    Write-Host "Disabling Windows Updates"
    Push-Location
    Set-Location hklm:
    $path = ".\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
	if(-not (Test-Path $path)) 
	{	
		if (-not (Test-Path ".\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"))
		{
			New-Item ".\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -type directory
		}
		New-Item $path -type directory
	}
	New-ItemProperty -Path $path -Name "AuOptions" -PropertyType "DWord" -Value "2"
    Set-ItemProperty -Path $path -Name "AuOptions" -Value "2"
	Pop-Location
    (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow() #Check for Updates. Used to apply regedits. 
    Write-Host "Done. Don't Worry if you get an error saying `"The property already exists.`""
}

function removeTask 
{
    Write-Host "Removing P2 from Task Scheduler"
    Unregister-ScheduledTask -TaskName "WindowsModder_P2" -Confirm:$false
    Write-Host "Done"
}

function disableDriverUpdate
{
    Write-Host "Disabling Automatic Driver Updates"
    Push-Location
    Set-Location hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching
    Set-ItemProperty . SearchOrderConfig "0"
    Pop-Location
    Write-Host "Done"
}

###### Start Admin Functions ######
function Test-IsAdmin() 
{
    # Get the current ID and its security principal
    $windowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($windowsID)
 
    # Get the Admin role security principal
    $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
    # Are we an admin role?
    if ($windowsPrincipal.IsInRole($adminRole))
    {
        $true
    }
    else
    {
        $false
    }
}

function Get-UNCFromPath
{
   Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [String]
    $Path)

    if ($Path.Contains([io.path]::VolumeSeparatorChar)) 
    {
        $psdrive = Get-PSDrive -Name $Path.Substring(0, 1) -PSProvider 'FileSystem'

        # Is it a mapped drive?
        if ($psdrive.DisplayRoot) 
        {
            $Path = $Path.Replace($psdrive.Name + [io.path]::VolumeSeparatorChar, $psdrive.DisplayRoot)
        }
    }

    return $Path
 }

function Invoke-RequireAdmin
{
    Param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    [System.Management.Automation.InvocationInfo]
    $MyInvocation)

    if (-not (Test-IsAdmin))
    {
        # Get the script path
        $scriptPath = $MyInvocation.MyCommand.Path
        $scriptPath = Get-UNCFromPath -Path $scriptPath

        # Need to quote the paths in case of spaces
        $scriptPath = '"' + $scriptPath + '"'

        # Build base arguments for powershell.exe
        [string[]]$argList = @('-NoLogo -NoProfile', '-ExecutionPolicy Bypass', '-File', $scriptPath)

        # Add 
        $argList += $MyInvocation.BoundParameters.GetEnumerator() | Foreach {"-$($_.Key)", "$($_.Value)"}
        $argList += $MyInvocation.UnboundArguments

        try
        {    
            $process = Start-Process PowerShell.exe -PassThru -Verb Runas -WorkingDirectory $pwd -ArgumentList $argList
            exit $process.ExitCode
        }
        catch {}

        # Generic failure code
        exit 1 
    }
}

###### End Functions ######

###### Start Main Method #######

Invoke-RequireAdmin $script:MyInvocation

removeTask
powerSettings
virtualMemory
pageSize
ninite
showFileExtensions
disableUpdates
disableDriverUpdate

Restart-Computer