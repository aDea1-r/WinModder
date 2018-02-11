<#
    aDea1's Windows 10 Mining Settings Modder Part 1
    Part 1 will elevate to admin privileges, install GPedit if you don't already have it, reboot the PC, and start Part 2.

    This script will save you some time when setting up your new mining rig, by automatically setting optimal power settings, and a virtual memory page size,
    installing gpedit, setting a large page size, setting explorer to show all file extensions, install chrome, install notepad++, install Winrar, optionally 
    install Teamviewer, disable automatic Windows Update, and disable automatic driver updates.
    
    If this saved you time, please consider leaving a donation (Even though I don't deserve one):
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

$ver = "1.0"
$Host.UI.RawUI.WindowTitle = "aDea1's Windows 10 Mining Settings Modder v $ver"
$Host.UI.RawUI.BackgroundColor = "DarkBlue"

Push-Location $PSScriptRoot
$global:gpeditInstalled = $false #Whether gpedit was installed by the script. Used to determine whether to restart later

###### Start Functions ######
function getGpedit
{
    # Install gpedit if needed
    $WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
    if ($WindowsVersion.Contains("Home")) {
        Write-Host "You are using Windows 10 Home, enabling gpedit"
        Start-Process "Install Group Policy Editor.bat" -wait
        Write-Host "Done"
        $global:gpeditInstalled = $true
    }
    else {
        Write-Host "You are using Windows 10 Pro, gpedit is enabled by default"
        $global:gpeditInstalled = $false
    }
}

function makeP2Task
{
    Write-Host "Making Task to Start Part 2 Upon Reboot"
    $action = New-ScheduledTaskAction -Execute $PSScriptRoot\RunP2.cmd -WorkingDirectory $PSScriptRoot
    $trigger =  New-ScheduledTaskTrigger -AtLogon
    Register-ScheduledTask -TaskName "WindowsModder_P2" -Trigger $trigger -Action $action -RunLevel Highest
    Write-Host "Done: Task will be automatically removed when Part 2 Starts"
}

function runP2now
{
    Write-Host "Starting Part 2"
    PowerShell.exe -ExecutionPolicy UnRestricted -File "aDea1's_WindowsModder_P2.ps1"
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

###### End All Functions ######

###### Start Main Method #######

Invoke-RequireAdmin $script:MyInvocation

Clear-Host
Write-Host "Modifying Windows 10 Settings for Mining, by aDea1"
Write-Host "Please Consider Donating if this helps you"
Write-Host "This Script is not 100% Automatic Yet, User input may be required"
Write-Host "Your PC May Restart Several Times. Close Window to Abort, or"
pause

getGpedit
makeP2Task
if ($gpeditInstalled) {
    Restart-Computer
}
else {
    runP2now
}