@echo off

:: Startup checks

:: Windows NT (kernel) release
for /f "tokens=2 delims=[]" %%a in ('ver') do set ver=%%a
for /f "tokens=2,3,4 delims=. " %%a in ("%ver%") do set v=%%a.%%b

:: Windows Build Number (Windows 8+)
for /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuildNumber"') do set BuildNumber=%%b

:: Windows Service Pack (Windows 7)
for /f "tokens=2 delims==" %%a in ('wmic os get ServicePackMajorVersion /value') do set ServicePack=%%a

:: OS Architecture (x86_64/x86)
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" >nul && set OSArchitecture=x86 || set OSArchitecture=x64

:: Unsupported OS releases (Vista, XP, W2K)
if %v% == 6.0 echo The Windows release that you're on is Vista, which is unsupported by us! Wait for the legacy pack :P & pause & exit
if %v% == 5.1 echo The Windows release that you're on is XP, which is unsupported by us! Wait for the legacy pack :P & pause & exit
if %v% == 5.0 echo The Windows release that you're on is 2000, which is unsupported by us! Wait for the legacy pack :P & pause & exit

:: Unsupported OS Architecture
if %OSArchitecture%==x86 echo The Windows release that you're on is using the x86 architecture, which is unsupported by us! & pause & exit

:: Admin permissions
    if "%PROCESSOR_ARCHITECTURE%" == "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs" & del "%temp%\getadmin.vbs" & exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: Setting up the size of the console window
mode con: cols=80 lines=40
:: Setting up directory variables
set Desktop=%userprofile%\Desktop
:: Setting up GX_ Pack variables
set packversion=v1.2
set GXFolder=%temp%\GXDownloads
:: Setting the current directory to the GXDownloads folder in %temp%.
if exist %GXFolder% cd /d %GXFolder%
if not exist %GXFolder% md %GXFolder% & cd /d %GXFolder%


:: Check for dependencies existing (Don't redownload them if the script has already been launched once)
if exist wget.exe (
    if exist 7za.exe (
        if exist nsudo.exe (
            goto start
        ) else (
            goto nsudo
        )
    ) else (
        goto 7z
    )
) else (
    goto wget
)
:: Downloading the dependency list:
:: Wget GNU; 7z Extra; NSudoLC
:wget
title Preparing GX_ Pack...
bitsadmin /create wgetdownloadforgx
bitsadmin /SetSecurityFlags wgetdownloadforgx 0
bitsadmin /SetMinimumRetryDelay wgetdownloadforgx 60
bitsadmin /transfer wgetdownloadtaskforgx /download /priority high https://eternallybored.org/misc/wget/1.21.4/64/wget.exe %GXFolder%\wget.exe
bitsadmin /reset /allusers
:7z
if exist 7za.exe goto start
cls
wget.exe --no-check-certificate https://cdn.discordapp.com/attachments/1122511966167109634/1122513182938902579/7za.exe -O 7za.exe
:nsudo
if exist nsudo.exe goto start
cls
wget.exe --no-check-certificate https://cdn.discordapp.com/attachments/1122511966167109634/1122513183316393994/nsudo.exe -O nsudo.exe

:start
if %v%==6.1 set OSID=1 & set OSVer=7 & goto start7
if %v%==6.2 set OSID=2 & set OSVer=8 & set Build=Build %BuildNumber% & goto start108
if %v%==6.3 set OSID=3 & set OSVer=8.1 & set Build=Build %BuildNumber%  & goto start108
if /I %BuildNumber% GEQ 21996 set OSID=5 & set OSVer=11 & set Build=Build %BuildNumber% & goto start11
if %v%==10.0 set OSID=4 & set OSVer=10 & set Build=Build %BuildNumber% & goto start108





:start7
title GX_ Pack %packversion% - Windows %OSVer%
cls
echo.
echo.
echo             ,.=:!!t3Z3z.,
echo          :tt:::tt333EE3
echo         Et:::ztt33EEEL${c2} @Ee.,      ..,
echo        ;tt:::tt333EE7${c2} ;EEEEEEttttt33#
echo       :Et:::zt333EEQ.${c2} $EEEEEttttt33QL          GX_ Pack %packversion%
echo       it::::tt333EEF${c2} @EEEEEEttttt33F           Windows %OSVer%
echo      ;3=*^```"*4EEV${c2} :EEEEEEttttt33@.
echo      ,.=::::!t=., ${c1}`${c2} @EEEEEEtt
echo     ;::::::::zt33)${c2}   "4EEEtttji3P*
echo    :t::::::::tt33.${c4}:Z3z..${c2}  ``
echo    i::::::::zt33F${c4} AEEEtttt::::ztF
echo   ;:::::::::t33V${c4} ;EEEttttt::::t3
echo   E::::::::zt33L${c4} @EEEtttt::::z3F               Choose options
echo   {3=*^```"*4E3)${c4} ;EEEtttt:::::tZ`              below.
echo               `${c4} :EEEEtttt::::z7
echo                    "VEzjt:;;z>*`
echo.
echo   -------------------------------
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations
echo    7. Virtualization software
echo    8. Runtimes
echo.
echo    0. Exit.
echo   -------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto software
if %choice%==2 goto webapp
if %choice%==3 goto creator
if %choice%==4 goto gamingsoftware
if %choice%==5 goto game
if %choice%==6 goto config
if %choice%==7 goto virtualization
if %choice%==8 goto runtime
if %choice%==0 exit
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto start



:start108
title GX_ Pack %packversion% - Windows %OSVer%%Build%
cls
echo.
echo.
echo.
echo                          ....,,:;+ccllll
echo            ...,,+:;  cllllllllllllllllll
echo      ,cclllllllllll  lllllllllllllllllll            GX_ Pack %packversion% 
echo      llllllllllllll  lllllllllllllllllll            Windows %OSVer% 
echo      llllllllllllll  lllllllllllllllllll            %Build%
echo      llllllllllllll  lllllllllllllllllll
echo      llllllllllllll  lllllllllllllllllll
echo.
echo      llllllllllllll  lllllllllllllllllll
echo      llllllllllllll  lllllllllllllllllll
echo      llllllllllllll  lllllllllllllllllll            Choose options
echo      llllllllllllll  lllllllllllllllllll            below.
echo      llllllllllllll  lllllllllllllllllll
echo      `'ccllllllllll  lllllllllllllllllll
echo            `' \\*::  :ccllllllllllllllll
echo                             ````''*::cll
echo                                       ``
echo.
echo.
echo   -------------------------------
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations
echo    7. Virtualization software
echo    8. Runtimes
echo.
echo    0. Exit.
echo   -------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto software
if %choice%==2 goto webapp
if %choice%==3 goto creator
if %choice%==4 goto gamingsoftware
if %choice%==5 goto game
if %choice%==6 goto config
if %choice%==7 goto virtualization
if %choice%==8 goto runtime
if %choice%==0 exit
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto start



:start11
title GX_ Pack %packversion% - Windows %OSVer%%Build%
cls
echo.
echo.
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll                GX_ Pack %packversion%
echo    lllllllllllllll   lllllllllllllll                Windows %OSVer%
echo    lllllllllllllll   lllllllllllllll                %Build%
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo.                                 
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll                Choose options
echo    lllllllllllllll   lllllllllllllll                below.
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo.
echo.
echo   -------------------------------
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations
echo    7. Virtualization software
echo    8. Runtimes
echo.
echo    0. Exit.
echo   -------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto software
if %choice%==2 goto webapp
if %choice%==3 goto creator
if %choice%==4 goto gamingsoftware
if %choice%==5 goto game
if %choice%==6 goto config
if %choice%==7 goto virtualization
if %choice%==8 goto runtime
if %choice%==0 exit
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto start





:software
cls 
title Basic software section - GX_ Pack %packversion%
echo.
echo   --------------------------------
echo    Choose a software application!
echo   --------------------------------
echo.
echo   ----------------------------------------------------
echo    1.  7-zip                   15. WizTree
echo    2.  Process Hacker 2        16. WizFile
echo    3.  VLC                     17. Ueli
echo    4.  MPC-HC                  18. Caesium
echo    5.  qBitTorrent             19. Mz CPU Accelerator
echo    6.  Unlocker                20. Winlaunch
echo    7.  Microsoft PC Manager    21. Fences (paid)
echo        (W10 1809+)             22. Groupy (paid)
echo    8.  Google Picasa 3         23. Mem Reduct
echo    9.  HWinfo                  24. Optimizer
echo    10. CrystalDiskInfo         25. BCUninstaller
echo    11. EasyBCD                 26. UltraISO
echo    12. Flux                    27. ShareX
echo    13. MiniBin                 28. Everything Search
echo    14. Unchecky
echo.
echo    0. Go back
echo   ----------------------------------------------------
echo.
echo.
set /p choice=Enter your choice:  
if %choice%==1 goto 7-zip
if %choice%==2 goto process-hacker
if %choice%==3 goto vlc
if %choice%==4 goto mpc-hc
if %choice%==5 goto qbittorrent
if %choice%==6 goto unlocker
if %choice%==7 goto microsoft-pc-manager
if %choice%==8 goto google-picasa
if %choice%==9 goto hw-info
if %choice%==10 goto crystal-disk-info
if %choice%==11 goto easybcd
if %choice%==12 goto flux
if %choice%==13 goto minibin
if %choice%==14 goto unchecky
if %choice%==15 goto wiztree
if %choice%==16 goto wizfile
if %choice%==17 goto ueli
if %choice%==18 goto caesium
if %choice%==19 goto mz-cpu-accelerator
if %choice%==20 goto winlaunch
if %choice%==21 goto fences
if %choice%==22 goto groupy
if %choice%==23 goto mem-reduct
if %choice%==24 goto optimizer
if %choice%==25 goto bcuninstaller
if %choice%==26 goto ultraiso
if %choice%==27 goto sharex
if %choice%==28 goto everythingsearch
if %choice%==0 goto start
if %errorleve%==1 echo choice is not a valid choice. Please try again. & pause & goto software





:webapp
cls & title Web app section - GX_ Pack %packversion%
echo.
echo.
echo   --------------------------------
echo    Select the options to install.
echo   --------------------------------
echo.
echo   ------------Browsers-------------
echo    Chrome:
echo    1. Stable      3. Dev
echo    2. Beta        4. Canary
echo    Edge:
echo    5. Stable      7. Dev
echo    6. Beta        8. Canary
echo    Firefox:
echo    9. Stable      11. Dev Edition
echo    10. Beta       12. Nightly
echo   ------------Other-----------
echo    13. Discord Stable
echo    14. Discord Beta
echo    15. Discord Canary
echo    16. Revolt
echo    17. Spotify
echo    18. iTunes
echo    19. Telegram Desktop
echo    20. Youtube Music
echo    21. Proton VPN
echo.
echo    0. Go back
echo   ----------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto chrome
if %choice%==2 goto chrome-beta
if %choice%==3 goto chrome-dev
if %choice%==4 goto chrome-canary
if %choice%==5 goto edgestable
if %choice%==6 goto edgebeta
if %choice%==7 goto edgedev
if %choice%==8 goto edgecanary
if %choice%==9 goto firefoxstable
if %choice%==10 goto firefoxbeta
if %choice%==11 goto firefoxdevedition
if %choice%==12 goto firefoxnightly
if %choice%==13 goto discordstable
if %choice%==14 goto discordbeta
if %choice%==15 goto discordcanary
if %choice%==16 goto revolt
if %choice%==17 goto spotify
if %choice%==18 goto itunes
if %choice%==19 goto telegram
if %choice%==20 goto youtubemusic
if %choice%==21 goto protonvpn
if %choice%==0 goto start
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto webapp





:creator
cls & title Creator section - GX Pack %packversion%
echo.
echo.
echo   ----------------------------------------
echo    What Creator applications do you want?
echo   ----------------------------------------
echo.
echo   ---------------------------------
echo              Programming
echo    1. VSCode
echo    2. VSCode (Insiders)
echo    3. VSCodium
echo    4. Sublime Text 4
echo    5. Sublime Text 3
echo    6. Notepad++
echo    7. Python 3.11.3
echo    8. Python 2.7.18
echo    9. Git
echo    10. Github Desktop
echo    11. Zealdocs
echo              Creativity
echo    12. Audacity
echo    13. Krita
echo    14. Paint.net
echo    15. OBS Studio
echo    16. FL Studio
echo    17. Figma
echo    18. Figma Beta
echo              Other
echo    19. Format Factory
echo    20. WinSCP
echo    21. PuTTY
echo    22. NoxPlayer
echo.
echo    0. Go back
echo   ---------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto visual-studio-code
if %choice%==2 goto visual-studio-code-insider
if %choice%==3 goto vscodium
if %choice%==4 goto sublimetext-v4
if %choice%==5 goto sublimetext-v3
if %choice%==6 goto notepad++
if %choice%==7 goto python-v3
if %choice%==8 goto python-v2
if %choice%==9 goto git
if %choice%==10 goto github
if %choice%==11 goto zealdocs
if %choice%==12 goto audacity
if %choice%==13 goto krita
if %choice%==14 goto paintdotnet
if %choice%==15 goto obs-studio
if %choice%==16 goto fl-studio
if %choice%==17 goto figma
if %choice%==18 goto figma-beta
if %choice%==19 goto format-factory
if %choice%==20 goto winscp
if %choice%==21 goto putty
if %choice%==22 goto nox
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause & goto creator





:gamingsoftware
cls & title Gaming software section - GX_ Pack %packversion%
echo.
echo.
echo   -----------------------------------
echo    What gaming software do you want?
echo   -----------------------------------
echo.
echo   ------------------------------------------
echo    1. Steam
echo    2. Epic Games Launcher
echo    3. MSI Afterburner + DirectX, RivaTuner
echo    4. AMD Adrenalin Software
echo    5. GeForce Experience
echo    6. Razer Cortex
echo    7. Corsair iCue
echo    8. Steelseries GG
echo    9. Bloody Mouse Software
echo    10. Curseforge
echo    12. Cheat Engine
echo.
echo    20. Go to the Game section
echo    0. Go back
echo   ------------------------------------------
echo.
echo.
set /p choice=...Enter your choice: 
if %choice%==1 goto steam
if %choice%==2 goto epicgameslauncher
if %choice%==3 goto afterburner
if %choice%==4 goto amd
if %choice%==5 goto nvidia
if %choice%==6 goto razer
if %choice%==7 goto corsair-icue
if %choice%==8 goto steelseries-gg
if %choice%==9 goto bloody7
if %choice%==10 goto curseforge
if %choice%==11 goto modrinth
if %choice%==12 goto cheatengine
if %choice%==20 goto game
if %choice%==0 goto start
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto gamingsoftware





:game
cls & title Game section - GX_ Pack %packversion%
echo.
echo.
echo   -------------------------
echo    What games do you want?
echo   -------------------------
echo.
echo   ----------------------------------------
echo    1. Official Minecraft Launcher
echo    2. Official Legacy Minecraft Launcher
echo    3. Lunar Client
echo    4. Badlion Client
echo    5. Feather Client
echo    6. Prism Launcher
echo    7. SKLauncher
echo    8. Osu
echo    9. Osu (Lazer)
echo    10. Roblox
echo    11. 3D Pinball
echo.
echo    0. Go back
echo   ----------------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto minecraft
if %choice%==2 goto minecraftlegacy
if %choice%==3 goto lunar
if %choice%==4 goto badlion
if %choice%==5 goto feather
if %choice%==6 goto prismlauncher
if %choice%==7 goto sklauncher
if %choice%==8 goto osu
if %choice%==9 goto osulazer
if %choice%==10 goto roblox
if %choice%==11 goto pinball
if %choice%==0 goto start
if %errorleve%==1 echo %choice% is not a valid choice. Please try again. & pause & goto game





:config
cls 
title Configuration section - GX_ Pack %packversion%
echo.
echo.
echo   ---------------------------------------
echo    Select the configurations to install.
echo   ---------------------------------------
echo.
echo   -----------------------------
echo    1. StartIsBack++ (W10)
echo    2. StartIsBack+ (W8.1)
echo    3. StartIsBack (W8)
echo    4. StartAllBack (W11)
echo    5. AME Wizard (W10+)
echo    6. Atlas Playbook (W10 22H2)
echo    7. ExplorerPatcher
echo    8. SecureUXThemePatcher
echo    9. Winaero Tweaker
echo    10. OldNewExplorer (W8+)
echo    11. BetterDiscord (W7)
echo    12. OpenAsar (Discord Stable)
echo    13. OpenAsar (Discord Beta)
echo    14. OpenAsar (Discord Canary)
echo.
echo    0. Go back
echo   -----------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto startisbackplusplus
if %choice%==2 goto startisbackplus
if %choice%==3 goto startisback
if %choice%==4 goto startallback
if %choice%==5 goto amewizard
if %choice%==6 goto atlasplaybook
if %choice%==7 goto explorerpatcher
if %choice%==8 goto secureuxthemepatcher
if %choice%==9 goto winaerotweaker
if %choice%==10 goto oldnewexplorer
if %choice%==11 goto betterdiscord
if %choice%==12 goto openasarstable
if %choice%==13 goto openasarbeta
if %choice%==14 goto openasarcanary
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto config





:virtualization
cls
title Virtualization Software section - GX_ Pack %packversion%
echo.
echo.
echo   -------------------------------------------
echo    What Virtualization software do you want?
echo   -------------------------------------------
echo.
echo   --------------------------------------------------
echo    VMware Workstation:
echo    1. Latest for your OS
echo    2. 17 (W10+)
echo    3. 16 (W8.1)
echo    4. 15 (W7 SP1/W8)
echo    5. 14 (W7)
echo    6. 12 (Legacy CPUs (2010))
echo    Pick option 1 if you don't know what to select.
echo.
echo    Virtualbox:
echo    7. 7.0.8 (Latest)
echo    8. 6.1
echo    9. 5.2
echo.
echo    10. Qemu
echo    11. Enable Hyper-V (W8+)
echo.
echo    0. Go back
echo   --------------------------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto vmware
if %choice%==2 goto vmware-v17
if %choice%==3 goto vmware-v16
if %choice%==4 goto vmware-v15
if %choice%==5 goto vmware-v14
if %choice%==6 goto vmware-v12
if %choice%==7 goto vboxver7
if %choice%==8 goto vboxver6
if %choice%==9 goto vboxver5
if %choice%==10 goto qemu
if %choice%==11 goto enablehyperv
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto virtualization





:runtime
cls 
title Runtime/Development Kit section - GX_ Pack %packversion%
echo.
echo.
echo   ---------------------------------
echo    What Runtimes/SDKs do you want?
echo   ---------------------------------
echo.
echo   -------------------------------------
echo    Runtimes:
echo    1. VCRedist 2005-2022 (All in one)
echo    2. Java 8
echo    3. .NET Framework 4.8.1
echo    4. .NET Framework 4.8
echo    5. .NET Framework 4.7.2
echo    6. .NET Framework 4.5.2
echo    7. .NET 8 Preview 4
echo    8. .NET 7
echo    9. .NET 6
echo    10. .NET Core 3.1
echo.
echo    Development Kits:
echo    11. Java 20
echo    12. .NET 8 Preview 4
echo    13. .NET 7
echo    14. .NET 6
echo    15. .NET Core 3.1
echo.
echo    0. Go back
echo   -------------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto vcredist-all-in-one
if %choice%==2 goto java-jre-v8
if %choice%==3 goto dotnetframework-v4_8_1
if %choice%==4 goto dotnetframework-v4_8
if %choice%==5 goto dotnetframework-v4_7_2
if %choice%==6 goto dotnetframework-v4_5_2
if %choice%==7 goto net-v8-runtimep4
if %choice%==8 goto net-v7-runtime
if %choice%==9 goto net-v6-runtime
if %choice%==10 goto net-core-v3_1-sdk
if %choice%==11 goto java-jdk-v20
if %choice%==12 goto net-v8-sdkp4
if %choice%==13 goto net-v7-sdk
if %choice%==14 goto net-v6-sdk
if %choice%==15 goto net-core-v3_1-runtime
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto runtime










:custom
echo.
echo.
echo   ----------------------------
echo    What programs do you want?
echo   ----------------------------
echo.
echo   ---------------------------------------
echo    1. BreadChat (written with Tauri)
echo    (desktop app for chat.breadtm.xyz)
echo    Requires Edge WebView2
echo    Developer: breadtm#7809
echo    2. Bing AI
echo    (desktop app for bing.com/chat)
echo    3. Bard 
echo    (desktop app for bard.google.com)
echo    4. ChatGPT
echo    (desktop app for chat.openai.com)
echo    Options 2-4 are written with Electron,
echo    and their dev is EAZY BLACK#6571.
echo.
echo    0. Go back
echo   ---------------------------------------
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto breadchat
if %choice%==2 goto bing-ai-electron
if %choice%==3 goto bard-electron
if %choice%==4 goto chatgpt-electron
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto custom








:: ------------------------
::  Custom program section
:: ------------------------

:breadchat
    wget.exe --no-check-certificate "https://cdn.breadtm.xyz/breadchat.msi" -O "%Desktop%\BreadChat.msi"
    breadchat.msi /quiet /norestart
    pause
    goto custom
:bing-ai-electron
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/767604199994818580/1113525352858398720/BingAI-DesktopElectron.exe" -O "bing-electron.exe"
    bing-electron.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto custom
:bard-electron
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1113530822570549268/1113788736879198258/BardAI-DesktopElectron.exe" -O "bard-electron.exe"
    bard-electron.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto custom
:chatgpt-electron
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1113530822570549268/1113779765837570119/ChatGPT-DesktopElectron.exe" -O "gpt-electron.exe"
    gpt-electron.exe
    pause
    goto custom

:: ------------------------------------
::  Runtime or Development Kit section
:: ------------------------------------

:java-jre-v8
    wget.exe --no-check-certificate "https://download.bell-sw.com/java/8u372+7/bellsoft-jre8u372+7-windows-amd64-full.msi"-O java-jre-v8.msi
    java-jre-v8.msi /quiet /norestart
    pause
    del java-jre-v8.msi
    goto runtime
:dotnetframework-v4_8_1
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe" -O netframework-v4.8.1.exe
    netframework-v4.8.1.exe /q /norestart
    pause
    del netframework-v4.8.1.exe
    goto runtime
:dotnetframework-v4_8
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O netframework-v4.8.exe
    netframework-v4.8.exe /q /norestart
    pause
    del netframework-v4.8.exe
    goto runtime
:dotnetframework-v4_7_2
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O netframework-v4.7.2.exe
    netframework-v4.7.2.exe /q /norestart
    pause
    del netframework-v4.7.2.exe
    goto runtime
:dotnetframework-v4_5_2
    wget.exe --no-check-certificate "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" -O netframework-v4.5.2.exe
    netframework-v4.5.2.exe /q /norestart
    pause
    del dotnetframework-v4.5.2.exe
    goto runtime
:vcredist-all-in-one
    wget.exe --no-check-certificate "https://dl.comss.org/download/Visual-C-Runtimes-All-in-One-Feb-2023.zip" -O vcredist-all-in-one.zip
    7za e vcredist-all-in-one.zip -aoa > NUL
    vcredist2005_x86.exe /q
    vcredist2005_x64.exe /q
    vcredist2008_x86.exe /qb
    vcredist2008_x64.exe /qb
    vcredist2010_x86.exe /passive /norestart
    vcredist2010_x64.exe /passive /norestart
    vcredist2012_x86.exe /passive /norestart
    vcredist2012_x64.exe /passive /norestart
    vcredist2013_x86.exe /passive /norestart
    vcredist2013_x64.exe /passive /norestart
    vcredist2015_2017_2019_2022_x86.exe /passive /norestart
    vcredist2015_2017_2019_2022_x64.exe /passive /norestart
    pause
    del vcredist2005_x86 & del vcredist2005_x64
    del vcredist2008_x86 & del vcredist2008_x64
    del vcredist2010_x86 & del vcredist2010_x64
    del vcredist2012_x86 & del vcredist2012_x64
    del vcredist2013_x86 & del vcredist2013_x64
    del vcredist2015_2017_2019_2022_x86 & del vcredist2015_2017_2019_2022_x64
    del vcredist-all-in-one.zip
    goto runtime
:java-jdk-v20
    wget.exe --no-check-certificate "https://download.oracle.com/java/20/latest/jdk-20_windows-x64_bin.msi" -O java-jdk-v20.msi
    java-jdk-v20.msi /quiet /norestart
    pause
    del java-jdk-v20.msi
    goto runtime
:net-v8-sdk
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/1b55b379-5ef2-4f21-8fad-aba058913cbc/c26ee3ba55cb40407a79564e28ed6d98/dotnet-sdk-8.0.100-preview.4.23260.5-win-x64.exe" -O net-v8-sdk.exe
    net-v8-sdk.exe /quiet /norestart
    pause
    del net-v8-sdk.exe
    goto runtime
:net-v8-runtime
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/d8cfe5d8-7da8-4163-bd7c-78aeb4fe3ef1/f55c5964da9bf2c8b5117f61c801122d/windowsdesktop-runtime-8.0.0-preview.4.23260.1-win-x64.exe" -O net-v8-runtime.exe
    net-v8-runtime.exe /quiet /norestart
    pause
    goto runtime
:net-v7-sdk
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/89a2923a-18df-4dce-b069-51e687b04a53/9db4348b561703e622de7f03b1f11e93/dotnet-sdk-7.0.203-win-x64.exe" -O net-v7-sdk.exe
    net-v7-sdk.exe /quiet /norestart
    pause
    del net-v7-sdk.exe
    goto runtime
:net-v7-runtime
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/dffb1939-cef1-4db3-a579-5475a3061cdd/578b208733c914c7b7357f6baa4ecfd6/windowsdesktop-runtime-7.0.5-win-x64.exe" -O net-v7-runtime.exe
    net-v7-runtime.exe /quiet /norestart
    pause
    del net-v7-runtime.exe
    goto runtime
:net-v6-sdk
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/df42b901-8ce2-4131-941a-b3fa094ff3d8/556da65f7a2f6164bf3df932e030898a/dotnet-sdk-6.0.408-win-x64.exe" -O net-v6-sdk.exe
    net-v6-sdk.exe
    pause
    del net-v6-sdk.exe
    goto runtime
:net-v6-runtime
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/85473c45-8d91-48cb-ab41-86ec7abc1000/83cd0c82f0cde9a566bae4245ea5a65b/windowsdesktop-runtime-6.0.16-win-x64.exe" -O net-v6-runtime.exe
    net-v6-runtime.exe /quiet /norestart
    pause
    del net-v6-runtime.exe
    goto runtime
:net-core-v3_1-sdk
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b70ad520-0e60-43f5-aee2-d3965094a40d/667c122b3736dcbfa1beff08092dbfc3/dotnet-sdk-3.1.426-win-x64.exe" -O net-core-v3_1-sdk.exe
    net-core-v3.1-sdk.exe /quiet /norestart
    pause
    del net-core-v3.1-sdk.exe
    goto runtime
:net-core-v3_1-runtime
    wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b92958c6-ae36-4efa-aafe-569fced953a5/1654639ef3b20eb576174c1cc200f33a/windowsdesktop-runtime-3.1.32-win-x64.exe" -O net-core-v3_1-runtime.exe
    net-core-v3.1-runtime.exe /quiet /norestart
    pause
    del net-core-v3.1-runtime.exe
    goto runtime

:: ------------------------
::  Virtualization section
:: ------------------------

:vmware
   if %OSID%==1 goto vmwarew7
   if %OSID%==2 goto vmwarew8
   if %OSID%==3 goto vmwarew81
   wget.exe --no-check-certificate https://download3.vmware.com/software/WKST-1700-WIN/VMware-workstation-full-17.0.0-20800274.exe -O vmware-v17.0.0-w10+.exe
   vmware-v17.0.0-w10+.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 
   pause
   del vmware-v17.0.0-w10+.exe
   goto virtualization
:vmware-v17
   wget.exe --no-check-certificate https://download3.vmware.com/software/WKST-1700-WIN/VMware-workstation-full-17.0.0-20800274.exe -O vmware-v17.0.0-w10+.exe
   vmware-v17.0.0-w10+.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 
   pause
   del vmware-v17.0.0-w10+.exe
   goto virtualization
:vmware-v16
   wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-16.2.2-19200509.exe -O vmware-v16.2.2-w8.1.exe
   vmware-v16.2.2-w8.1.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 
   pause
   del vmware-v16.2.2-w8.1.exe
   goto virtualization
:vmware-v15
   wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-15.5.7-17171714.exe -O vmware-v15.5.7-w7.exe
   vmware-v15.5.7-w7.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
   pause
   del vmware-v15.5.7-w7.exe
   goto virtualization
:vmware-v14
   wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe -O vmware-v14.1.8-w8.exe
   vmware-v14.1.8-w8.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
   pause
   del vmware-v14.1.8-w8.exe
   goto virtualization
:vmware-v12
   wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-12.5.9-7535481.exe -O vmware-v12.5.9.exe
   vmware-v12.5.9.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
   pause
   del vmware-v12.5.9.exe
   goto virtualization
:vboxver7
   wget.exe --no-check-certificate https://download.virtualbox.org/virtualbox/7.0.8/VirtualBox-7.0.8-156879-Win.exe -O vbox-v7.0.8.exe
   vbox-v7.0.8.exe -silent
   pause
   del vbox-v7.0.8.exe
   goto virtualization
:vboxver6
   wget.exe --no-check-certificate https://download.virtualbox.org/virtualbox/6.1.44/VirtualBox-6.1.44-156814-Win.exe -O vbox-v6.1.44.exe
   vbox-v6.1.44.exe --silent --ignore-reboot
   pause
   del vbox-v6.1.44.exe
   goto virtualization
:vboxver5
   wget.exe --no-check-certificate https://download.virtualbox.org/virtualbox/5.2.44/VirtualBox-5.2.44-139111-Win.exe -O vbox-v5.2.44.exe
   vbox-v5.2.44.exe --silent --ignore-reboot
   pause
   del vbox-v5.2.44.exe
   goto virtualization
:qemu
   if %OSID% leq 2 goto qemulegacy
   wget.exe --no-check-certificate https://qemu.weilnetz.de/w64/2023/qemu-w64-setup-20230424.exe -O qemu.exe
   qemu.exe /S
   pause
   del qemu.exe
   goto virtualization
:enablehyperv
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value') do set caption=%%a
if not "%caption%" == "" (
    if not "%caption:Home Single Language=%" == "%caption%" (
       goto homepatch
    ) else if not "%caption:Home=%" == "%caption%" (
       goto homepatch
    ) else if not "%caption:Core Single Language=%" == "%caption%" (
        goto homepatch
    ) else if not "%caption:Core Connected=%" == "%caption%" (
        goto homepatch
    ) else if not "%caption:Core=%" == "%caption%" (
        goto homepatch
    )
)
DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
cls
echo Hyper-V has been enabled!
pause
goto virtualization
:homepatch
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do DISM /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
DISM /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
cls
echo Hyper-V has been enabled!
pause
goto virtualization

:: -----------------
::  Config section
:: -----------------

:amewizard
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1104344622106427433/1117409547775115314/AME_Wizard_Beta.exe" -O %Desktop%\amewizard.exe
    echo Done! AME Wizard has been downloaded and saved on your desktop.
    pause
    goto config
:atlasplaybook
    wget.exe --no-check-certificate "https://github.com/Atlas-OS/Atlas/releases/download/0.2.0/Atlas.Playbook.22H2.v0.2.apbx" -O %Desktop%\atlasplaybook.apbx
    echo Done! Atlas Playbook has been downloaded and saved on your desktop.
    echo Now you can insert it into AME Wizard.
    pause
    goto config
:startisback
    wget.exe --no-check-certificate "https://www.startisback.com/StartIsBack_setup.exe" -O startisback.exe
    startisback.exe
    pause
    del startisback.exe
    goto config
:startisbackplus
    wget.exe --no-check-certificate "https://www.startisback.com/StartIsBackPlus_setup.exe" -O startisbackplus.exe
    startisbackplus.exe
    pause
    del startisbackplus.exe
    goto config
:startisbackplusplus
    wget.exe --no-check-certificate "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe" -O startisbackplusplus.exe
    startisbackplusplus.exe
    pause
    del startisbackplusplus.exe
    goto config
:startallback
    wget.exe --no-check-certificate "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartAllBack_3.6.4_setup.exe" -O startallback.exe
    startallback.exe
    pause
    del startallback.exe
    goto config
:secureuxthemepatcher
    wget.exe --no-check-certificate "https://github.com/namazso/SecureUxTheme/releases/download/v2.1.2/ThemeTool.exe"  -O ThemeTool.exe
    ThemeTool.exe
    pause
    del ThemeTool.exe
    goto config
:oldnewexplorer
	wget.exe --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/appearance/OldNewExplorer.zip" -O OldNewExplorer.zip
	7za e OldNewExplorer.zip -aoa > NUL
    xcopy "%GXFolder%\OldNewExplorer" %programfiles%\ /E /H /C /I
    %programfiles%\OldNewExplorer\OldNewExplorerCfg.exe
	pause 
	del OldNewExplorer.zip
	goto config
:betterdiscord
    wget.exe --no-check-certificate "https://github.com/BetterDiscord/Installer/releases/download/v1.3.0/BetterDiscord-Windows.exe" -O "betterdiscord.exe"
    betterdiscord.exe
    pause
    del betterdiscord.exe
    goto config
:openasarcanary
    echo Closing Discord...
    taskkill /f /im DiscordCanary.exe > nul 2> nul
    taskkill /f /im DiscordCanary.exe > nul 2> nul
    taskkill /f /im DiscordCanary.exe > nul 2> nul
    timeout /t 5 /nobreak > nul 2> nul
    echo Installing OpenAsar...
    copy /y "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar" "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\DiscordCanary\app-1.0.69\resources\_app.asar" copy /y "%localappdata%\DiscordCanary\app-1.0.69\resources\_app.asar" "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.orig" copy /y "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.orig" "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.backup" > nul 2> nul
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordCanary\app-1.0.69\resources\app.asar\"" > nul 2> nul 
    if exist "%localappdata%\DiscordCanary\app-1.0.68\resources\app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordCanary\app-1.0.68\resources\app.asar\"" > nul 2> nul
    if exist "%localappdata%\DiscordCanary\app-1.0.69\resources\_app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordCanary\app-1.0.69\resources\_app.asar\"" > nul 2> nul
    if exist "%localappdata%\DiscordCanary\app-1.0.69\resources\app.asar.orig" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordCanary\app-1.0.69\resources\app.asar.orig\"" > nul 2> nul
    cls
    echo OpenAsar has been installed!
    pause
    goto config
:openasarbeta
    echo Closing Discord...
    taskkill /f /im DiscordPtb.exe > nul 2> nul
    taskkill /f /im DiscordPtb.exe > nul 2> nul
    taskkill /f /im DiscordPtb.exe > nul 2> nul
    timeout /t 3 /nobreak > nul 2> nul
    echo Installing OpenAsar... 
    copy /y "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar" "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\DiscordPTB\app-1.0.1027\resources\_app.asar" copy /y "%localappdata%\DiscordPTB\app-1.0.1027\resources\_app.asar" "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.orig" copy /y "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.orig" "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.backup" > nul 2> nul
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordPTB\app-1.0.1027\resources\app.asar\"" > nul 2> nul
    if exist "%localappdata%\DiscordPTB\app-1.0.1026\resources\app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordPTB\app-1.0.1026\resources\app.asar\"" > nul 2> nul
    if exist "%localappdata%\DiscordPTB\app-1.0.1027\resources\_app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordPTB\app-1.0.1027\resources\_app.asar\"" > nul 2> nul
    if exist "%localappdata%\DiscordPTB\app-1.0.1027\resources\app.asar.orig" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\DiscordPTB\app-1.0.1027\resources\app.asar.orig\"" > nul 2> nul
    cls
    echo OpenAsar has been installed!
    pause
    goto config
:openasarstable
    echo Closing Discord...
    taskkill /f /im Discord.exe > nul 2> nul
    taskkill /f /im Discord.exe > nul 2> nul
    taskkill /f /im Discord.exe > nul 2> nul
    timeout /t 3 /nobreak > nul 2> nul
    echo Installing OpenAsar...
    copy /y "%localappdata%\Discord\app-1.0.9013\resources\app.asar" "%localappdata%\Discord\app-1.0.9013\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\Discord\app-1.0.9013\resources\_app.asar" copy /y "%localappdata%\Discord\app-1.0.9013\resources\_app.asar" "%localappdata%\Discord\app-1.0.9013\resources\app.asar.backup" > nul 2> nul
    if exist "%localappdata%\Discord\app-1.0.9013\resources\app.asar.orig" copy /y "%localappdata%\Discord\app-1.0.9013\resources\app.asar.orig" "%localappdata%\Discord\app-1.0.9013\resources\app.asar.backup" > nul 2> nul
    powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\Discord\app-1.0.9013\resources\app.asar\"" > nul 2> nul
    if exist "%localappdata%\Discord\app-1.0.9012\resources\app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\Discord\app-1.0.9012\resources\app.asar\"" > nul 2> nul
    if exist "%localappdata%\Discord\app-1.0.9013\resources\_app.asar" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\Discord\app-1.0.9013\resources\_app.asar\"" > nul 2> nul
    if exist "%localappdata%\Discord\app-1.0.9013\resources\app.asar.orig" powershell -Command "Invoke-WebRequest https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar -OutFile \"$Env:LOCALAPPDATA\Discord\app-1.0.9013\resources\app.asar.orig\"" > nul 2> nul
    cls
    echo OpenAsar has been installed!
    pause
    goto config
:explorerpatcher
    wget.exe --no-check-certificate "https://github.com/valinet/ExplorerPatcher/releases/download/22621.1555.55.1_a95a688/ep_setup.exe" -O explorerpatcher.exe
    explorerpatcher.exe
    pause
    del explorerpatcher
    goto config
:winaerotweaker
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1104344622106427433/1116988942638649435/winaerotweaker.exe" -O winaerotweaker.exe
    winaerotweaker.exe /SP- /VERYSILENT
    pause
    del winaerotweaker.exe
    goto config

:: --------------
::  Game section
:: --------------

:minecraft
    wget.exe --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.exe" -O mclauncher.exe
    mclauncher.exe
    pause
    del mclauncher.exe
    goto game
:minecraftlegacy
    wget.exe --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.msi" -O legacymclauncher.msi
    legacymclauncher.msi /quiet /norestart
    pause
    del legacymclauncher.msi
    goto game
:lunar
    wget.exe --no-check-certificate "https://launcherupdates.lunarclientcdn.com/Lunar Client v2.15.1.exe" -O lunarclient.exe
    lunarclient.exe /S
    pause
    del lunarclient.exe
    goto game
:badlion
    wget.exe --no-check-certificate "https://client-updates.badlion.net/Badlion Client Setup 3.15.1.exe" -O badlionclient.exe
    badlionclient.exe /S
    pause
    del badlionclient.exe
    goto game
:feather
    wget.exe --no-check-certificate "https://launcher.feathercdn.net/dl/Feather Launcher Setup 1.5.5.exe" -O featherclient.exe
    featherclient.exe /S
    pause
    del featherclient.exe
    goto game
:prismlauncher
    if %OSID% LEQ 3 goto prismlauncherlegacy
    wget.exe --no-check-certificate "https://objects.githubusercontent.com/github-production-release-asset-2e65be/553135896/1fa54d9c-cb62-43b5-b4d2-85f6faa7a22a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230622%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230622T163638Z&X-Amz-Expires=300&X-Amz-Signature=ce52e10c6f00f7c240dbb4431f94b0326ef16c52592fc3312046e1c34d886c30&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=553135896&response-content-disposition=attachment%3B%20filename%3DPrismLauncher-Windows-MSVC-Setup-7.1.exe&response-content-type=application%2Foctet-stream" -O "prismlauncher.exe"
    prismlauncher.exe /S
    pause
    del prismlauncher.exe
    goto game
:sklauncher
    wget.exe --no-check-certificate "https://skmedix.pl/data/SKlauncher%203.1.exe" -O "%Desktop%\sklauncher.exe"
    goto game
:osu
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/769802700740362263/1110264771393106011/osuinstall.exe" -O osu.exe
    osu.exe
    pause
    del osu.exe
    goto game
:osulazer
    wget.exe --no-check-certificate "https://github.com/ppy/osu/releases/latest/download/install.exe" -O osulazer.exe
    osulazer.exe
    pause
    del osulazer.exe
    goto game
:roblox
    wget.exe --no-check-certificate "https://setup.rbxcdn.com/version-21bedf9513a74867-Roblox.exe" -O "roblox.exe"
    roblox.exe
    pause
    del roblox.exe
    goto game
:pinball
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/838495643063812146/1110189889200332860/3D-Pinball.exe" -O pinball.exe
    pinball.exe /VERYSILENT /SUPRESSMSGBOXES /ALLUSERS /NORESTART /SP-
    pause
    del pinball.exe
    goto game

:: -------------------------
::  Gaming software section
:: -------------------------

:steam
    wget.exe --no-check-certificate "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe" -O steam.exe
    steam.exe /S
    pause
    del steam.exe
    goto gamingsoftware
:epicgameslauncher
    wget.exe --no-check-certificate "https://epicgames-download1.akamaized.net/Builds/UnrealEngineLauncher/Installers/Win32/EpicInstaller-15.5.0.msi?launcherfilename=EpicInstaller-15.5.0.msi" -O "epicgameslauncher.msi /quiet /norestart"
    epicgameslauncher.msi /quiet /norestart
    pause
    del epicgameslauncher.msi /quiet /norestart
    goto gamingsoftware
:afterburner
    wget.exe --no-check-certificate "https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465.zip" -O msiafterburner.zip
	7za e msiafterburner.zip -aoa > NUL
    MSIAfterburnerSetup465.exe /S
    pause
    del msiafterburner.zip
    rd /S /Q Guru3D.com
    del MSIAfterburnerSetup465.exe
    goto gamingsoftware
:amd
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110577745915805808/amd-software-adrenalin-edition-23.4.3-minimalsetup-230427_web.exe" -O amdsoftware.exe
    amdsoftware.exe /S
    pause
    del amdsoftware.exe
    goto gamingsoftware
:nvidia
    wget.exe --no-check-certificate "https://ru.download.nvidia.com/GFE/GFEClient/3.27.0.112/GeForce_Experience_v3.27.0.112.exe" -O geforceexperience.exe
    geforceexperience.exe -y -gm2 -fm0
    pause
    del geforceexperience.exe
    goto gamingsoftware
:razer
    wget.exe --no-check-certificate "https://dl.razerzone.com/drivers/GameBooster/RazerCortexInstaller.exe" -O razer-cortex.exe
    razer-cortex.exe
    pause
    del razer-cortex.exe
    goto gamingsoftware
:corsair-icue
    wget.exe --no-check-certificate "https://downloads.corsair.com/Files/CUE/iCUESetup_4.33.138_release.msi" -O corsair-icue.msi
    corsair-icue.msi /quiet /norestart
    pause
    del corsair-icue.msi
    goto gamingsoftware
:steelseries-gg
    wget.exe --no-check-certificate "https://engine.steelseries-ggcdn.com/steelseriesGG37.0.0Setup.exe" -O steelseriesgg.exe
    steelseries-gggg.exe /S
    pause
    del steelseries-gg.exe
    goto gamingsoftware
:bloody7
    wget.exe --no-check-certificate "https://www.a4tech.com.tw/download/BloodyMouse/Bloody7_V2022.1129_MUI.exe" -O "bloody7.exe"
    bloody7.exe
    pause
    del bloody7.exe
    goto gamingsoftware
:curseforge
    wget.exe --no-check-certificate "https://download.overwolf.com/installer/prod/972f02914d159e510780ed68f36fc62a/CurseForge%20Windows%20-%20Installer.exe" -O "curseforge.exe"
    curseforge.exe /S
    pause
    del curseforge.exe
    goto gamingsoftware
:modrinth
    wget.exe --no-check-certificate "https://launcher-files.modrinth.com/versions/0.2.1/windows/Modrinth%20App_0.2.1_x64_en-US.msi" -O "modrinth.msi"
    modrinth.msi /quiet /norestart
    pause
    del modrinth.msi
    goto gamingsoftware
:cheatengine
    wget.exe --no-check-certificate "https://d1vdn3r1396bak.cloudfront.net/installer/594303/8192625359131417427" -O "cheatengine.exe"
    cheatengine.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del cheatengine.exe
    goto gamingsoftware

:: -----------------------------
::  Creator application section
:: -----------------------------

:vscode
    if %OSID% LEQ 2 goto :vscodelegacy
    wget.exe --no-check-certificate "https://az764295.vo.msecnd.net/stable/b3e4e68a0bc097f0ae7907b217c1119af9e03435/VSCodeSetup-x64-1.78.2.exe" -O vscode.exe
    vscode.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del vscode.exe
    goto creator
:vscodeinsider
    wget.exe --no-check-certificate "https://az764295.vo.msecnd.net/insider/506cd5056d875ccdbea2e9a41ba7b9f19103d599/VSCodeSetup-x64-1.79.0-insider.exe" -O vscode-insider.exe
    vscode-insider.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del vscode-insider.exe
    goto creator
:vscodium
    if %OSID% LEQ 2 goto :vscodiumlegacy
    wget.exe --no-check-certificate "https://github.com/VSCodium/vscodium/releases/download/1.78.2.23132/VSCodium-x64-1.78.2.23132.msi" -O vscodium.msi
    vscodium.msi /quiet /norestart
    pause
    del vscodium.msi
    goto creator
:sublimetext-v4
    wget.exe --no-check-certificate "https://download.sublimetext.com/sublime_text_build_4143_x64_setup.exe" -O sublimetext-v4.exe
    sublimetext-v4.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del sublimetext-v4.exe
    goto creator
:sublimetext-v3
    wget.exe --no-check-certificate "https://download.sublimetext.com/Sublime%20Text%20Build%203211%20x64%20Setup.exe" -O sublimetext-v3.exe
    sublimetext-v3.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del sublimetext-v3.exe
    goto creator
:notepad++
    wget.exe --no-check-certificate "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.3/npp.8.5.3.Installer.x64.exe" -O notepad++.exe
    notepad++.exe /S
    pause
    del notepad++
    goto creator
:python-v3
    if %OSID% LEQ 2 goto pythonlegacyver3
    wget.exe --no-check-certificate "https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe" -O python-v3.11.3.exe
    python-v3.11.3.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    pause
    del python-v3.11.3.exe
    goto creator
:python-v2
    wget.exe --no-check-certificate "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi" -O python-v2.7.18.msi
    python-v2.7.18.msi /quiet /norestart
    pause
    del python-v2.7.18.exe
    goto creator
:git
    wget.exe --no-check-certificate "https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/Git-2.40.1-64-bit.exe" -O git.exe
    git.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del git.exe
    goto creator
:github
    wget.exe --no-check-certificate "https://central.github.com/deployments/desktop/desktop/latest/win32" -O github.exe
    github.exe
    pause
    del github.exe
    goto creator
:zealdocs
    wget.exe --no-check-certificate "https://github.com/zealdocs/zeal/releases/download/v0.6.1/zeal-0.6.1-windows-x64.msi" -O zealdocs.msi
    zealdocs.msi /quiet /norestart
    pause
    del zealdocs.msi
    goto creator
:audacity
    wget.exe --no-check-certificate "https://github.com/audacity/audacity/releases/download/Audacity-3.3.2/audacity-win-3.3.2-x64.exe" -O audacity.exe
    audacity.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del audacity.exe
    goto creator
:krita
    wget.exe --no-check-certificate "https://download.kde.org/stable/krita/5.1.5/krita-x64-5.1.5-setup.exe" -O krita.exe
    krita.exe /S
    pause
    del krita.exe
    goto creator
:figma  
	wget.exe --no-check-certificate "https://desktop.figma.com/win/FigmaSetup.exe" -O FigmaSetup.exe
	FigmaSetup.exe
	pause
	del FigmaSetup.exe
	goto creator 
:figma-beta  
	wget.exe --no-check-certificate "https://desktop.figma.com/win/beta/FigmaBetaSetup.exe" -O FigmaBetaSetup.exe
	FigmaBetaSetup.exe
	pause
	del FigmaBetaSetup.exe
	goto creator 
:paintdotnet
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1104324621257420871/1120015122820243487/paintdotnet.exe" -O paintdotnet-anycpu-webinstaller.exe
    paintdotnet-anycpu-webinstaller.exe
    del paintdotnet-anycpu-webinstaller.exe
    goto creator
:obs-studio
    if %OSID% LEQ 3 goto obslegacy
    wget.exe --no-check-certificate "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-29.1-Full-Installer-x64.exe" -O obs-studio.exe
    obs-studio.exe /S
    pause
    del obs-studio.exe
    goto creator
:fl-studio
    wget.exe --no-check-certificate "https://support.image-line.com/redirect/fl-studio_win_installer" -O fl-studio.exe
    fl-studio.exe /S
    pause
    del fl-studio.exe
    goto creator
:format-factory
    wget.exe --no-check-certificate "https://sdl.adaware.com/?bundleid=FF001&savename=FF001.exe" -O FF001.exe
    FF001.exe /S
    pause
    del FF001.exe
    goto creator
:winscp
    wget.exe --no-check-certificate "https://deac-riga.dl.sourceforge.net/project/winscp/WinSCP/6.1/WinSCP-6.1.msi" -O winscp.msi
    winscp.msi /quiet /norestart
    pause
    del winscp.msi
    goto creator
:putty
    wget.exe --no-check-certificate "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.78-installer.msi" -O putty.msi
    putty.msi /quiet /norestart
    pause
    del putty.msi
    goto creator

:: -------------------------
::  Web application section
:: -------------------------

:chrome
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727769497611/ChromeStable.exe" -O chrome.exe
    chrome.exe
    pause
    del chrome.exe
    goto webapp
:chrome-beta
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727404601364/ChromeBeta.exe" -O chrome-beta.exe
    chrome-beta.exe
    pause
    del chrome-beta.exe
    goto webapp
:chrome-dev
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728566423773/ChromeDev.exe" -O chrome-dev.exe
    chrome-dev.exe
    pause
    del chrome-dev.exe
    goto webapp
:chrome-canary
   if %OSID% LEQ 3 echo Your OS is not supported and there is no older version available & pause & goto webapp
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728222486598/ChromeCanary.exe" -O chrome-canary.exe
    chrome-canary.exe
    pause
    del chrome-canary.exe
    goto webapp
:edge
    wget.exe --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100" -O edge.exe
    edge.exe
    pause
    del edge.exe
    goto webapp
:edge-beta
    wget.exe --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Beta&language=en" -O edge-beta.exe
    edge-beta.exe
    pause
    del edge-beta.exe
    goto webapp
:edge-dev
    wget.exe --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Dev&language=en" -O edge-dev.exe
    edge-dev.exe
    pause
    del edge-dev.exe
    goto webapp
:edge-canary
    wget.exe --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Canary&language=en&brand=M100" -O edge-canary.exe
    edge-canary.exe
    pause
    del edge-canary.exe
    goto webapp
:firefox
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112105341071360/Firefox_Installer.exe" -O firefox.exe
    firefox.exe
    pause
    del firefox.exe
    goto webapp
:firefox-beta
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112429443338400/Firefox_Setup_114.0b9_2.exe" -O firefox-beta.exe
    firefox-beta.exe
    pause
    del firefox-beta.exe
    goto webapp
:firefox-dev-edition
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104955183125/Firefox_Installer_2.exe" -O firefox-dev-edition.exe
    firefox-dev-edition.exe
    pause
    del firefox-dev-edition.exe
    goto webapp
:firefox-nightly
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104099565789/Firefox_Installer.en-US.exe" -O firefox-nightly.exe
    firefox-nightly.exe
    pause
    del firefox-nightly.exe
    goto webapp
:discordstable
    wget.exe --no-check-certificate "https://dl.discordapp.net/distro/app/stable/win/x86/1.0.9013/DiscordSetup.exe" -O discord.exe
    discord.exe
    pause
    del discord.exe
    goto webapp
:discordbeta
    wget.exe --no-check-certificate "https://dl-ptb.discordapp.net/distro/app/ptb/win/x86/1.0.1027/DiscordPTBSetup.exe" -O discord-beta.exe
    discord-beta.exe
    pause
    del discord-beta.exe
    goto webapp
:discordcanary
    wget.exe --no-check-certificate "https://dl-canary.discordapp.net/distro/app/canary/win/x86/1.0.60/DiscordCanarySetup.exe" -O discord-canary.exe
    discord-canary.exe
    pause
    del discord-canary.exe
    goto webapp
:revolt
    wget.exe --no-check-certificate "https://github.com/revoltchat/desktop/releases/download/v1.0.6/Revolt-Setup-1.0.6.exe" -O revolt.exe
    revolt.exe /S
    pause
    del revolt.exe
    goto webapp
:spotify
    if %OSID% LEQ 3 goto spotifylegacy
    wget.exe --no-check-certificate "https://download.scdn.co/SpotifySetup.exe" -O spotify.exe
    nsudo.exe -U:C -Wait "spotify.exe"
    pause
    del spotify.exe
    goto webapp
:itunes
    wget.exe --no-check-certificate "https://secure-appldnld.apple.com/itunes12/001-80042-20210422-E8A351F2-A3B2-11EB-9A8F-CF1B67FC6302/iTunesSetup.exe" -O itunes.exe
    itunes.exe
    pause
    del itunes.exe
    goto webapp
:telegram
    wget.exe --no-check-certificate "https://updates.tdesktop.com/tx64/tsetup-x64.4.8.1.exe" -O telegram.exe
    telegram.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del telegram.exe
    goto webapp
:youtubemusic
    wget.exe --no-check-certificate "https://github.com/th-ch/youtube-music/releases/download/v1.20.0/YouTube-Music-Setup-1.20.0.exe" -O "youtubemusic.exe"
    youtubemusic.exe 
    pause
    del youtube-music.exe
    goto webapp
:protonvpn
    if %OSID% LEQ 3 goto protonvpnlegacy
    wget.exe --no-check-certificate "https://protonvpn.com/download/ProtonVPN_v3.0.7.exe" -O "protonvpn.exe"
    protonvpn.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del protonvpn.exe
    goto webapp

:: ------------------------
::  Basic software section
:: ------------------------

:7-zip
    wget.exe --no-check-certificate "https://www.7-zip.org/a/7z2201-x64.msi" -O 7-zip.msi
    7-zip.msi /quiet
    pause
    del 7-zip.msi
    goto software
:process-hacker
    wget.exe --no-check-certificate "https://deac-fra.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe" -O process-hacker.exe
    process-hacker.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del process-hacker.exe
    goto software
:vlc
    wget.exe --no-check-certificate "https://mirrors.neterra.net/vlc/vlc/3.0.18/win64/vlc-3.0.18-win64.msi" -O vlc.msi
    vlc.msi /quiet
    pause
    del vlc.msi
    goto software
:mpc-hc
    wget.exe --no-check-certificate "https://github.com/clsid2/mpc-hc/releases/download/2.0.0/MPC-HC.2.0.0.x64.exe" -O mpc-hc.exe
    mpc-hc.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del mpc-hc.exe
    goto software
:qbittorrent
    wget.exe --no-check-certificate "https://deac-ams.dl.sourceforge.net/project/qbittorrent/qbittorrent-win32/qbittorrent-4.5.2/qbittorrent_4.5.2_x64_setup.exe" -O qbittorrent.exe
    qbittorrent.exe /S
    pause
    del qbittorrent.exe
    goto software
:unlocker
    wget.exe --no-check-certificate "https://dl.freesoftru.net/apps/47/466/46534/Unlocker-1.9.2-x64.msi" -O unlocker.msi
    unlocker.msi /quiet /norestart
    pause
    del unlocker.msi
    goto software
:microsoft-pc-manager
    if %OSID% leq 3 echo Your operating system is completely unsupported by this program. & pause & goto software
    wget.exe --no-check-certificate "https://aka.ms/PCManager10000" -O microsoft-pc-manager.exe
    microsoft-pc-manager.exe /S
    pause
    del microsoft-pc-manager.exe
    goto software
:google-picasa
    wget.exe --no-check-certificate "https://web.archive.org/web/20150601071855if_/https://dl.google.com/picasa/picasa39-setup.exe" -O "google-picasa.exe"
    google-picasa.exe /S
    pause
    del google-picasa.exe
    goto software
:hw-info
    wget.exe --no-check-certificate "https://www.sac.sk/download/utildiag/hwi_746.exe" -O "hw-info.exe"
    hw-info.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del hw-info.exe
    goto software
:crystal-disk-info
    wget.exe --no-check-certificate "https://ftp.halifax.rwth-aachen.de/osdn/crystal-disk-info/78192/crystal-disk-info8_17_14.exe" -O "crystal-disk-info.exe"
    crystal-disk-info.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del crystal-disk-info.exe
    goto software
:easybcd
    wget.exe --no-check-certificate "https://files03.tchspt.com/temp/EasyBCD2.4.exe" -O "EasyBCD 2.4.exe"
    "EasyBCD 2.4.exe" /S
    pause
    del "EasyBCD 2.4.exe"
    goto software
:flux
    wget.exe --no-check-certificate "https://justgetflux.com/flux-setup.exe" -O "flux.exe"
    flux.exe /S
    pause
    del flux.exe
    goto software
:minibin
    wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1104344622106427433/1116797366792634438/minibin.exe" -O "minibin.exe"
    minibin.exe /S
    pause
    del minibin.exe
    goto software
:unchecky
    wget.exe --no-check-certificate "https://unchecky.com/files/upload/unchecky_setup.exe" -O "unchecky.exe"
    unchecky.exe -install
    pause
    del unchecky.exe
    goto software
:wiztree
    wget.exe --no-check-certificate "https://antibodysoftware-17031.kxcdn.com/files/20230315/wiztree_4_13_setup.exe" -O wiztree.exe
    wiztree.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del wiztree.exe
    goto software
:wizfile
    wget.exe --no-check-certificate "https://antibodysoftware-17031.kxcdn.com/files/wizfile_3_09_setup.exe" -O wizfile.exe
    wizfile.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del wizfile.exe
    goto software
:ueli
    wget.exe --no-check-certificate "https://github.com/oliverschwendener/ueli/releases/download/v8.24.0/ueli-Setup-8.24.0.exe" -O ueli.exe
    ueli.exe /S
    pause
    del ueli.exe
    goto software
:caesium
    if %OSID% == 3 goto caesiumw8
	if %OSID% leq 2 goto caesiumw7
    wget.exe --no-check-certificate "https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.4.0/caesium-image-compressor-2.4.0-win-setup.exe" -O caesium.exe
    caesium.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del caesium.exe
    goto software
:mz-cpu-accelerator
    wget.exe --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/processor/mzcpu.exe" -O mz-cpu-accelerator.exe
    mz-cpu-accelerator.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del mz-cpu-accelerator.exe
    goto software
:winlaunch
    wget.exe --no-check-certificate "https://nav.dl.sourceforge.net/project/winlaunch/WinLaunchInstaller.exe" -O winlaunch.exe
    winlaunch.exe
    pause
    del winlaunch.exe
    goto software
:fences
    wget.exe --no-check-certificate "https://cdn.stardock.us/downloads/public/software/fences/Fences4-sd-setup.exe" -O fences.exe
    fences.exe /S /NOINIT /W
    pause
    del fences.exe
    goto software
:groupy
    wget.exe --no-check-certificate "https://cdn.stardock.us/downloads/public/software/groupy/Groupy_setup.exe" -O groupy.exe
    groupy.exe /S /NOINIT /W
    pause
    del groupy.exe
    goto software
:mem-reduct
    wget.exe --no-check-certificate "https://github.com/henrypp/memreduct/releases/download/v.3.4/memreduct-3.4-setup.exe" -O mem-reduct.exe
    mem-reduct.exe /S
    pause
    del mem-reduct.exe
    goto software
:optimizer
    wget.exe --no-check-certificate "https://github.com/hellzerg/optimizer/releases/download/15.3/Optimizer-15.3.exe" -O %Desktop%\Optimizer.exe
    pause
    goto software
:bcuninstaller
    wget.exe --no-check-certificate "https://github.com/Klocman/Bulk-Crap-Uninstaller/releases/download/v5.6/BCUninstaller_5.6_setup.exe" -O bcuninstaller.exe
    bcuninstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del bcuninstaller.exe
    goto software
:ultraiso
    wget.exe --no-check-certificate "https://www.ultraiso.com/uiso9_pe.exe" -O ultraiso.exe
    ultraiso.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del ultraiso.exe
    goto software
:sharex
    wget.exe --no-check-certificate "https://github.com/ShareX/ShareX/releases/download/v15.0.0/ShareX-15.0.0-setup.exe" -O sharex.exe
    sharex.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del sharex.exe
    goto software
:everythingsearch
    wget.exe --no-check-certificate "https://www.voidtools.com/Everything-1.4.1.1024.x64-Setup.exe" -O "everythingsearch.exe"
    everythingsearch.exe /S
    pause
    del everythingsearch.exe
    goto software

:: --------------------
:: Legacy installers 
:: --------------------

:prismlauncherlegacy
    wget.exe --no-check-certificate "https://objects.githubusercontent.com/github-production-release-asset-2e65be/553135896/619512ae-925c-40f8-b990-f7beca65f962?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230622%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230622T163637Z&X-Amz-Expires=300&X-Amz-Signature=a6f150e10c2c53a2fdc84c7818214da8c7bf9e134c66ba220a146a77354c98e2&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=553135896&response-content-disposition=attachment%3B%20filename%3DPrismLauncher-Windows-MSVC-Legacy-Setup-7.1.exe&response-content-type=application%2Foctet-stream" -O "prismlauncher-legacy.exe"
    prismlauncher-legacy.exe /S
    pause
    del prismlauncher-legacy.exe
    goto game
:protonvpnlegacy
    wget.exe --no-check-certificate "https://protonvpn.com/download/ProtonVPN_win_v2.4.2.exe" -O "protonvpnlegacy.exe"
    protonvpnlegacy.exe
    pause
    del protonvpnlegacy.exe
    goto webapp
:obslegacy
    wget.exe --no-check-certificate "https://github.com/obsproject/obs-studio/releases/download/27.2.4/OBS-Studio-27.2.4-Full-Installer-x64.exe" -O obs-studio-legacy.exe
    obs-studio-legacy.exe /S
    pause
    del obs-studio-legacy.exe
    goto creator
:caesiumw8
    wget.exe --no-check-certificate "https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.3.0/caesium-image-compressor-2.3.0-win-setup.exe" -O caesium-w8.exe
    caesium-w8.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del caesium-w8.exe
    goto software
:caesiumw7
    wget.exe --no-check-certificate "https://kumisystems.dl.sourceforge.net/project/caesium/1.7.0/caesium-1.7.0-win.exe" -O caesium-w7.exe
    caesium-w7.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del caesium-w7
    goto software
:spotifylegacy
    wget.exe --no-check-certificate "https://download.scdn.co/SpotifyFull7-8-8.1.exe" -O spotify-legacy-w8-w7.exe
    nsudo.exe -U:C -Wait "spotify-legacy-w8-w7.exe"
    pause
    del spotify-legacy-w8-w7.exe
    goto webapp
:vscodelegacy
    wget.exe --no-check-certificate "https://az764295.vo.msecnd.net/stable/e4503b30fc78200f846c62cf8091b76ff5547662/VSCodeSetup-x64-1.70.2.exe" -O vscodelegacy.exe
    vscodelegacy.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    del vscodelegacy.exe
    goto creator
:vscodiumlegacy
    wget.exe --no-check-certificate "https://github.com/VSCodium/vscodium/releases/download/1.70.2.22230/VSCodium-x64-1.70.2.22230.msi" -O vscodium-w7.msi
    vscodium-w7.msi /quiet /norestart
    pause
    del vscodium-w7.msi
    goto creator
:pythonlegacy
    wget.exe --no-check-certificate "https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe" -O python-w7.exe
    python-w7.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    pause
    del python-w7.exe
    goto creator
:qemulegacy
    wget --no-check-certificate https://qemu.weilnetz.de/w64/2022/qemu-w64-setup-20220419.exe -O qemu-w7.exe
    qemu-w7.exe /S
    pause
    del qemu-w7.exe
    goto virtualization
:vmwarew7
    if %ServicePack%==0 (
        wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe -O vmware-v14.1.8-w8.exe
        vmware-v14.1.8-w8.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
        pause
        del vmware-v14.1.8-w8.exe 
        goto virtualization
    )
    wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-15.5.7-17171714.exe -O vmware-v15.5.7-w7.exe
    vmware-v15.5.7-w7.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
    pause
    del vmware-v15.5.7-w7.exe
    goto virtualization
:vmwarew8
    wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe -O vmware-v14.1.8-w8.exe
    vmware-v14.1.8-w8.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 
    pause
    del vmware-v14.1.8-w8.exe
    goto virtualization
:vmwarew81
    wget.exe --no-check-certificate https://download3.vmware.com/software/wkst/file/VMware-workstation-full-16.2.2-19200509.exe -O vmware-v16.2.2-w8.1.exe
    vmware-v16.2.2-w8.1.exe /s /v/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0
    pause
    del vmware-v16.2.2-w8.1.exe
    goto virtualization
