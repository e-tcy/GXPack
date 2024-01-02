@echo off

openfiles >nul 2>&1
if errorlevel 1 PowerShell -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c %~dpnx0'" & exit

for /f "tokens=2 delims=[]" %%a in ('ver') do set ver=%%a
for /f "tokens=2,3,4 delims=. " %%a in ("%ver%") do set v=%%a.%%b
for /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuildNumber"') do set buildnumber=%%b
for /f "tokens=2 delims==" %%a in ('wmic os get ServicePackMajorVersion /value') do set ServicePack=%%a
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" >nul && set arch=x86 || set arch=x64

mode con: cols=80 lines=40
set dir=%userprofile%\AppData\Local\Temp\GXTemp\
set desktop=%userprofile%\Desktop
set packversion=v1.3d
set Build=Your build number: %buildnumber%
if exist %dir% cd %dir% & goto check
md %dir%
cd /d %dir%

:check
echo x=msgbox("Couldn't download required dependencies", 16, "GX_ Pack - No internet available") > nointernet.vbs
echo x=msgbox("Your Windows version is unsupported.", 16, "GX_ Pack - Outdated Windows version") > outdatednt.vbs
echo x=msgbox("The x86 architecture isn't supported.", 16, "GX_ Pack - Unsupported architecture") > x86arch.vbs
 
if %v%==6.0 set winver=Vista & cscript //nologo %userprofile%\AppData\Local\Temp\GXTemp\outdatednt.vbs & exit
if %v%==5.1 set winver=XP & cscript //nologo %userprofile%\AppData\Local\Temp\GXTemp\outdatednt.vbs & exit
if %v%==5.0 set winver=2000 & cscript //nologo %userprofile%\AppData\Local\Temp\GXTemp\outdatednt.vbs & exit
if %arch%==x86 cscript //nologo %userprofile%\AppData\Local\Temp\GXTemp\x86arch.vbs & exit
ping -n 1 8.8.8.8 >nul && (cls) || (cscript //nologo %dir%\nointernet.vbs)

title Downloading dependencies..
if not exist wget.exe (
    curl -fSSL -s https://eternallybored.org/misc/wget/1.21.4/32/wget.exe -o %temp%\GXTemp\wget.exe
    if errorlevel 9009 (
        powershell -Command "$AllProtocols = [System.Net.SecurityProtocolType]::Ssl3 -bor [System.Net.SecurityProtocolType]::Tls -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12; [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols; $ProgressPreference = 'SilentlyContinue'; $wc = New-Object net.webclient; $wc.Downloadfile('https://eternallybored.org/misc/wget/1.21.4/64/wget.exe', '%userprofile%\AppData\Local\Temp\GXTemp\wget.exe')"
        if errorlevel 1 (
            bitsadmin /transfer wget /download /priority high http://web.archive.org:80/web/20230511215022/https://eternallybored.org/misc/wget/1.21.4/32/wget.exe %temp%\GXTemp\wget.exe
        )
    )
    wget.exe --no-check-certificate -q -nc https://cdn.discordapp.com/attachments/1122511966167109634/1122513182938902579/7za.exe -O %temp%\GXTemp\7za.exe
    wget.exe --no-check-certificate -q -nc https://cdn.discordapp.com/attachments/1122511966167109634/1122513183316393994/nsudo.exe -O %temp%\GXTemp\nsudo.exe
)





:start
cls
if %v%==6.1 set OSID=1 & set winver=7
if %v%==6.2 set OSID=2 & set winver=8
if %v%==6.3 set OSID=3 & set winver=8.1
if %v%==10.0 set OSID=4 & set winver=10
if /I %buildnumber% GEQ 21996 set OSID=5 & set winver=11
title GX_ Pack %packversion%
echo.
echo.
echo                          ....,,:;+ccllll
echo            ...,,+:;  cllllllllllllllllll            Welcome to 
echo      ,cclllllllllll  lllllllllllllllllll            GX_ Pack %packversion%!
echo      llllllllllllll  lllllllllllllllllll            Your OS: Windows %winver% 
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
if %winver%==7 (
    cls
    echo.
    echo.
    echo              ,.=:!!t3Z3z.,
    echo           :tt:::tt333EE3
    echo          Et:::ztt33EEEL$c2 @Ee.,      ..,
    echo         ;tt:::tt333EE7$c2 ;EEEEEEttttt33#          
    echo        :Et:::zt333EEQ.$c2 $EEEEEttttt33QL          
    echo        it::::tt333EEF$c2 @EEEEEEttttt33F           
    echo       ;3=*^```"*4EEV$c2 :EEEEEEttttt33@.            Welcome to
    echo       ,.=::::!t=., $c1`$c2 @EEEEEEtt             GX_ Pack %packversion%!
    echo      ;::::::::zt33$c2   "4EEEtttji3P*             
    echo     :t::::::::tt33.$c4:Z3z..$c2  ``              Your OS: Windows %winver%
    echo     i::::::::zt33F$c4 AEEEtttt::::ztF
    echo    ;:::::::::t33V$c4 ;EEEttttt::::t3
    echo    E::::::::zt33L$c4 @EEEtttt::::z3F               
    echo    3=*^```"*4E3)$c4 ;EEEtttt:::::tZ`              
    echo                `$c4 :EEEEtttt::::z7
    echo                     "VEzjt:;;z>*`
    echo.
    echo.
)
if %winver%==11 (
    cls
    echo.
    echo.
    echo    lllllllllllllll   lllllllllllllll
    echo    lllllllllllllll   lllllllllllllll                Welcome to 
    echo    lllllllllllllll   lllllllllllllll                GX_ Pack %packversion%!
    echo    lllllllllllllll   lllllllllllllll                You're running: Windows %winver%
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
)

echo                          1. Basic software
echo                          2. Web applications
echo                          3. Creator applications
echo                          4. Games/Gaming software
echo                          5. Configurations
echo                          6. Virtualization software
echo                          7. Runtimes/Development kits
echo                          8. Custom software
echo.
echo                          9. Join our Discord server!
echo                                  0. Exit.

:: if anyone finds a better way of doing this i will be happy
:: different amounts of 'echo.' for the choice to be at the bottom of the command window

if %winver%==11 echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.
if %winver%==10 echo. & echo. & echo. & echo. & echo. & echo. & echo.
if %winver%==8.1 echo. & echo. & echo. & echo. & echo. & echo. & echo.
if %winver%==8 echo. & echo. & echo. & echo. & echo. & echo. & echo.
if %winver%==7 echo. & echo. & echo. & echo. & echo. & echo. & echo. & echo.

set /p choice=Enter your desired selection here: 
if %choice%==1 goto software
if %choice%==2 goto web
if %choice%==3 goto productive
if %choice%==4 goto gaming
if %choice%==5 goto config
if %choice%==6 goto virtualization
if %choice%==7 goto runtime
if %choice%==8 goto custom
if %choice%==9 start "" https://discord.gg/3e46tHdHSu & goto start
if %choice%==0 exit
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto start

:software
cls & title Basic software section - GX_ Pack %packversion%
echo.
echo.
echo    -------------------- Choose a software application! --------------------
echo.
echo    ---------------------------- Compression -------------------------------
echo                1. 7-zip                       3. NanaZip
echo                2. Caesium 
echo    ----------------------------- Utilities ---------------------------------
echo                4. CPU-Z                       8. Foxit Reader
echo                5. GPU-Z                       9. TCPOptimizer
echo                6. LightShot                   10. ShareX
echo                7. CrystalDiskInfo             11. HWInfo
echo    ---------------------------- Media players -----------------------------
echo                12. Kodi                       15. K-Lite Codec Pack
echo                13. VLC                        16. mpv
echo                14. Rise Media Player
echo    ---------------------------- Optimization ------------------------------
echo                17. Microsoft PC Manager       19. Optimizer
echo                18. Mem Reduct                 20. WinMemoryCleaner
echo    ---------------------------- System Tools ------------------------------
echo                21. Process Hacker 2           33. Fences (paid)
echo                22. Winlaunch                  34. Groupy (paid)
echo                23. LibreOffice                35. UltraISO  
echo                24. Mz CPU Accelerator         36. Bull Crap Uninstaller
echo                25. Google Picasa 3            37. Everything Search
echo                26. EasyBCD                    38. AltDrag
echo                27. Flux                       39. VB-Audio vbaudiocable
echo                28. MiniBin                    40. WingetUI 
echo                29. Unchecky                   41. Ueli                
echo                30. WizFile                    42. AnyDesk                     
echo                31. WizTree                    
echo                32. Unlocker
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
echo.
set /p choice=Enter your desired choice: 
if %choice%==1 goto 7z
if %choice%==2 goto caesium
if %choice%==3 goto nanazip
if %choice%==4 goto cpuz
if %choice%==5 goto gpuz
if %choice%==6 goto lightshot
if %choice%==7 goto crystaldiskinfo
if %choice%==8 goto foxitreader
if %choice%==9 goto tcpoptimizer
if %choice%==10 goto sharex
if %choice%==11 goto hwinfo
if %choice%==12 goto kodi
if %choice%==13 goto vlc
if %choice%==14 goto risemediaplayer
if %choice%==15 goto klitecodecpack
if %choice%==16 goto mpv
if %choice%==17 goto pcmanager
if %choice%==18 goto memreduct
if %choice%==19 goto optimizer
if %choice%==20 goto winmemorycleaner
if %choice%==21 goto processhacker
if %choice%==22 goto winlaunch
if %choice%==23 goto libreoffice
if %choice%==24 goto mzcpuaccelerator
if %choice%==25 goto picasa
if %choice%==26 goto easybcd
if %choice%==27 goto flux
if %choice%==28 goto minibin
if %choice%==29 goto unchecky
if %choice%==30 goto wizfile
if %choice%==31 goto wiztree
if %choice%==32 goto unlocker
if %choice%==33 goto fences
if %choice%==34 goto groupy
if %choice%==35 goto ultraiso
if %choice%==36 goto bullcrapuninstaller
if %choice%==37 goto everythingsearch
if %choice%==38 goto altdrag
if %choice%==39 goto vbaudiocable
if %choice%==40 goto wingetui
if %choice%==41 goto ueli
if %choice%==42 goto anydesk
if %choice%==0 goto start
if %errorlevel%==1 echo choice is not a valid choice. Please try again. & pause & goto software





:web
cls & title Web app section - GX_ Pack %packversion%
echo.
echo    ----------------- Choose your web application/version! -------------------
echo.   
echo    ---------------------------- Uncategorized -------------------------------
echo            1. Psiphon VPN        2. Proton VPN        3. iTunes
echo            4. Revolt             5. Spotify           6. Speedtest
echo            7. Telegram           8. Voicemod          9. WhatsApp
echo            10. YT Music          11. LogMeIn Hamachi  12. Thunderbird
echo    ------------------------------ Chrome ------------------------------------
echo            13. Stable            14. Beta             15. Dev
echo            16. Canary            17. Chromium         18. Chromium Ungoogled
echo    ------------------------------ Discord -----------------------------------
echo            19. Stable            20. Beta             21. Canary
echo            22. Vencord           23. BetterDiscord    24. OpenAsar
echo    ------------------------------ Edge --------------------------------------
echo            25. Stable                                 26. Beta
echo            27. Canary                                 28. Dev
echo    ------------------------------ Firefox -----------------------------------
echo            29. Stable                                 30. Beta
echo            31. Dev Edition                            32. Nightly
echo    ----------------------------- TeamViewer ---------------------------------
echo            33. Full                                   34. QuickSupport
echo            35. Host                                   36. Meeting
echo    ------------------------------ Opera -------------------------------------
echo            37. Opera                                  38. Opera GX
echo    ------------------------------ Torrent -----------------------------------
echo            39. qBitTorrent                            40. Deluge
echo    ------------------------------ Vivaldi -----------------------------------
echo            41. Latest                                 42. Legacy
echo    ------------------------------ Waterfox ----------------------------------
echo            43. Latest                                 44. Classic
echo    ------------------------------ Radmin ------------------------------------
echo            45. Radmin VPN                             46. Radmin Viewer
echo    ----------------- Brave ----------------------------- Signal -------------
echo            47. Brave                                  48. Signal        
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
set /p choice=Enter your desired choice:  
if %choice%==1 goto psiphonvpn
if %choice%==2 goto protonvpn
if %choice%==3 goto itunes
if %choice%==4 goto revolt
if %choice%==5 goto spotify
if %choice%==6 goto speedtest
if %choice%==7 goto telegram
if %choice%==9 start "" https://apps.microsoft.com/detail/whatsapp/9NKSQGP7F2NH?hl=ru-ru&gl=RU & goto web
if %choice%==10 goto ytmusic
if %choice%==11 goto hamachi
if %choice%==12 goto thunderbird
if %choice%==13 goto chrome
if %choice%==14 goto chromebeta
if %choice%==15 goto chromedev
if %choice%==16 goto chromecanary
if %choice%==17 goto chromium
if %choice%==18 goto chromiumungoogled
if %choice%==19 goto discord
if %choice%==20 goto discordbeta
if %choice%==21 goto discordcanary
if %choice%==22 goto vencord
if %choice%==23 goto betterdiscord
if %choice%==24 goto openasar
if %choice%==25 goto edge
if %choice%==26 goto edgebeta
if %choice%==27 goto edgecanary
if %choice%==28 goto edgedev
if %choice%==29 goto firefox
if %choice%==30 goto firefoxbeta
if %choice%==31 goto firefoxdevedition
if %choice%==32 goto firefoxnightly
if %choice%==33 set "teamviewer=full" & goto teamviewer
if %choice%==34 set "teamviewer=quicksupport" & goto teamviewer
if %choice%==35 set "teamviewer=host" & goto teamviewer
if %choice%==36 set "teamviewer=meeting" & goto teamviewer
if %choice%==37 goto opera
if %choice%==38 goto operagx
if %choice%==39 goto qbit
if %choice%==40 goto deluge
if %choice%==41 goto vivaldi
if %choice%==42 goto vivaldilegacy
if %choice%==43 goto waterfox
if %choice%==44 goto waterfoxclassic
if %choice%==45 goto radminvpn
if %choice%==46 goto radminviewer
if %choice%==47 goto brave
if %choice%==48 goto signal
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto web





:productive
cls & title Productive section - GX Pack %packversion%
echo.
echo.
echo    ------------------ Choose your productivity software! --------------------
echo.
echo    ------------------ Programming software and languages --------------------
echo                   1. VSCode            10. Github Desktop
echo                   2. VSCode Insider    11. Git
echo                   3. Visual Studio     12. Zealdocs
echo                   4. VSCodium          13. Python 3.12
echo                   5. Sublime Text 4    14. Python 3.8.10
echo                   6. Sublime Text 3    15. Python 2.7.18
echo                   7. Sublime Merge     16. Rust
echo                   8. Notepad++         17. Node.js (LTS 20.10)
echo                   9. Jetbrains Toolbox 18. Node.js (21.5)
echo    ------------------------ Creativity Software -----------------------------
echo                   19. Audacity         24. FL Studio 21 (Trial)
echo                   20. Krita            25. Figma
echo                   21. Paint.net        26. Figma Beta
echo                   22. OBS Studio       27. Capcut
echo                   23. Kdenlive
echo    ------------------------------ Other -------------------------------------
echo                   28. Format Factory   31. Insomnia
echo                   29. WinSCP           32. Postman
echo                   30. PuTTY            33. FileZilla
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
echo.
set /p choice=Enter your desired selection here: 
if %choice%==1 goto vscode
if %choice%==2 goto vscodeinsider
if %choice%==3 goto vs
if %choice%==4 goto vscodium
if %choice%==5 set sublimetext=4 & goto sublime
if %choice%==6 set sublimetext=3 & goto sublime
if %choice%==7 set sublimemerge=True & goto sublime
if %choice%==8 goto npp
if %choice%==9 goto jetbrainstoolbox
if %choice%==10 goto github
if %choice%==11 goto git
if %choice%==12 goto zealdocs
if %choice%==13 set python=latest & goto python
if %choice%==14 set python=older & goto python
if %choice%==15 set python=old & goto python
if %choice%==16 goto rust
if %choice%==17 set nodejs=lts & goto nodejs
if %choice%==18 goto nodejs
if %choice%==19 goto audacity
if %choice%==20 goto krita
if %choice%==21 goto paintnet
if %choice%==22 goto obs
if %choice%==23 goto kdenlive
if %choice%==24 goto flstudio
if %choice%==25 goto figma
if %choice%==26 goto figmabeta
if %choice%==27 goto capcut
if %choice%==28 goto formatfactory
if %choice%==29 goto winscp
if %choice%==30 goto putty
if %choice%==31 goto insomnia
if %choice%==32 goto postman
if %choice%==33 goto filezilla
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause & goto productive





:gaming
cls & title Game section - GX_ Pack %packversion%
echo.
echo    ------------------ Choose your gaming software or game! ------------------
echo.
echo    ----------------------------- Clients ------------------------------------
echo                 1. Steam                 5. Curseforge 
echo                 2. Epic Games            6. Electronic Arts
echo                 3. FACEIT                7. Battle.net
echo                 4. Modrinth              8. Ubisoft
echo    -------------------------- Performance Tools -----------------------------
echo                 9. MSI Afterburner       11. AMD Adrenalin Software
echo                 10. GeForce Experience
echo    ------------------------ Gaming Utilities --------------------------------
echo                 12. Razer Cortex         16. Bloody Mouse Software
echo                 13. Steelseries GG       17. AutoHotKey
echo                 14. Cheat Engine         18. JKPS
echo                 15. Corsair iCue
echo    --------------------------- Emulators ------------------------------------
echo                 19. Nox Player           21. RetroArch (Stable)
echo                 20. Bluestacks           22. RetroArch (Nightly)
echo    --------------------------- Minecraft ------------------------------------
echo                 23. Minecraft Launcher   27. Legacy Minecraft Launcher
echo                 24. Lunar Client         28. Badlion Client
echo                 25. Feather Client       29. Prism Launcher
echo                 26. SKLauncher           30. Technix Client
echo    --------------------------- Other games ----------------------------------
echo                 31. CSS v34 ClientMod    34. Roblox
echo                 32. Osu!                 35. 3D Pinball
echo                 33. Osu! Lazer
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
set /p choice=Enter your desired selection here:
if %choice%==1 goto steam
if %choice%==2 goto epic
if %choice%==3 goto faceit
if %choice%==4 goto modrinth
if %choice%==5 goto curseforge
if %choice%==6 goto ea
if %choice%==7 goto battlenet
if %choice%==8 goto ubisoft
if %choice%==9 goto afterburner
if %choice%==10 goto nvidia
if %choice%==11 goto amd
if %choice%==12 goto razer
if %choice%==13 goto steelseries
if %choice%==14 goto cheatengine
if %choice%==15 goto corsair
if %choice%==16 goto bloody7
if %choice%==17 goto ahk
if %choice%==18 goto jkps
if %choice%==19 goto nox
if %choice%==20 goto bluestacks
if %choice%==21 set retroarch=1 & goto retroarch
if %choice%==22 set retroarch=2 & goto retroarch
if %choice%==23 goto minecraft
if %choice%==24 goto minecraftlegacy
if %choice%==25 goto lunar
if %choice%==26 goto badlion
if %choice%==27 goto feather
if %choice%==28 goto prismlauncher
if %choice%==29 goto sklauncher
if %choice%==30 goto technix
if %choice%==31 goto clientmod
if %choice%==32 goto osu
if %choice%==33 goto osulazer
if %choice%==34 goto roblox
if %choice%==35 goto pinball
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto gaming





:config
cls & title Configuration section - GX_ Pack %packversion%
echo.
echo    ----------------- Select the configurations to install -------------------
echo.
echo    ---------------------------- Customizers ---------------------------------
echo                 1. StartIsBack++ (W10)    3. StartIsBack (W8)
echo                 2. StartIsBack+ (W8.1)    4. StartAllBack (W11)
echo                 5. Rainmeter
echo    ----------------------- Windows system utilities -------------------------
echo                 6. AME Wizard (W10+)      10. Winaero Tweaker
echo                 7. Atlas Playbook (W10)   11. OldNewExplorer (W8+)
echo                 8. ExplorerPatcher (W11)  12. 7+ Taskbar Tweaker
echo                 9. SecureUXThemePatcher   13. BloatyNosy (W11)         
echo    -------------------------- Additional tweaks -----------------------------
echo                 14. Rectify11             18. ContextMenuNormalizer (W10)
echo                 15. AccentColorizer (W8+) 19. DragDropNormalizer
echo                 16. CTT's WinUtil         20. TranslucentTB (W10+)
echo                 17. Windhawk (W10+)       21. PowerToys (W10+)
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
echo.
set /p choice=Enter your desired selection here: 
if %choice%==1 goto startisbackplusplus
if %choice%==2 goto startisbackplus
if %choice%==3 goto startisback
if %choice%==4 goto startallback
if %choice%==5 goto rainmeter
if %choice%==6 goto amewizard
if %choice%==7 goto atlasplaybook
if %choice%==8 goto explorerpatcher
if %choice%==9 goto secureuxthemepatcher
if %choice%==10 goto winaerotweaker
if %choice%==11 goto oldnewexplorer
if %choice%==12 goto 7tt
if %choice%==13 goto bloatynosy
if %choice%==14 goto rectify11
if %choice%==15 goto accentcolorizer
if %choice%==16 goto winutil
if %choice%==17 goto windhawk
if %choice%==18 goto contextmenunormalizer
if %choice%==19 goto dragdropnormalizer
if %choice%==20 goto translucenttb
if %choice%==21 start "" https://apps.microsoft.com/detail/microsoft-powertoys/XP89DCGQ3K6VLD?hl=ru-ru&gl=RU & goto config
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto config





:virtualization
cls
title Virtualization software section - GX_ Pack %packversion%
echo.
echo.
echo    ---------------- Choose your virtualization software! --------------------
echo.
echo    ------------------------- VMware Workstation -----------------------------
echo                 1. Latest for your OS      2. 17 (10+) 
echo                 3. 16 (8.1)                4. 15 (7 SP1/8)
echo                 5. 14 (7)                  6. 12 (Legacy CPUs)                
echo                Pick option 1 if you don't know what to select.
echo    ---------------------------- Virtualbox ----------------------------------
echo                 7. 7.0.8 (Latest)          8. 6.1
echo                 9. 5.2
echo    --------------------------- Uncategorized --------------------------------
echo                 10. Qemu                   11. Hyper-V (W8+)
echo    --------------------------------------------------------------------------
echo.
echo    --------------------------- 0. Go back -----------------------------------
echo.
echo.
set /p choice=Enter your desired selection here:  
if %choice%==1 set "vmware=auto" & goto vmware
if %choice%==2 goto vmware
if %choice%==3 set vmware=1 & goto vmware
if %choice%==4 set vmware=2 & goto vmware
if %choice%==5 set vmware=3 & goto vmware
if %choice%==6 set vmware=4 & goto vmware
if %choice%==7 set vbox=1 & goto vbox
if %choice%==8 set vbox=2 & goto vbox
if %choice%==9 set vbox=3 & goto vbox
if %choice%==10 goto qemu
if %choice%==11 goto enablehyperv
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto virtualization





:runtime
cls 
title Runtime/Development Kit section - GX_ Pack %packversion%
echo.
echo.
echo    ---------------------- Choose your Runtime/SDK! -------------------------
echo.
echo    ---------------------------- Runtimes -----------------------------------
echo.
echo                   1. VCRedist AIO           7. .NET 8
echo                   2. Java 8                 8. .NET 7
echo                   3. .NET Framework 4.8.1   9. .NET 6
echo                   4. .NET Framework 4.8     10. .NET Core 3.1
echo                   5. .NET Framework 4.7.2   11. XNA Framework 4
echo                   6. .NET Framework 4.5.2   12. UpdatePack7R2
echo.
echo    -------------------------- Development Kits ----------------------------
echo.
echo                   13. Java 20               16. .NET 6
echo                   14. .NET 8                17. .NET Core 3.1
echo                   15. .NET 7
echo.
echo    ---------------------------- 0. Go back --------------------------------
echo.
echo.
set /p choice=Enter your desired selection here: 
if %choice%==1 goto vcredist
if %choice%==2 goto java8jre
if %choice%==3 goto netframework481
if %choice%==4 goto netframework48
if %choice%==5 goto netframework472
if %choice%==6 goto netframework452
if %choice%==7 goto net8run
if %choice%==8 goto net7run
if %choice%==9 goto net6run
if %choice%==10 goto net31sdk
if %choice%==11 goto xna
if %choice%==12 goto updatepack7r2
if %choice%==13 goto java20jdk
if %choice%==14 goto net8sdk
if %choice%==15 goto net7sdk
if %choice%==16 goto net6sdk
if %choice%==17 goto net31run
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto runtime










:custom
title Custom Application section - GX_ Pack %packversion%
cls
echo.
echo.
echo    --------------------------- Choose our customs! --------------------------
echo.
echo                           == All devs can be found ==
echo                              == on our Discord. ==
echo.
echo    ---------------------- Tauri apps (by bread.trademark) -------------------
echo.
echo                   1. BreadChat             2. BreadImagine
echo.
echo    ---------------------- Electron apps (by eazyblack) ----------------------
echo.
echo                   3. Bing AI               5. ChatGPT
echo                   4. Bard
echo.
echo    ---------------------------- 0. Go back ----------------------------------
echo.
echo.
set /p choice=Enter your desired selection here: 
if %choice%==1 goto breadchat
if %choice%==2 goto breadimagine
if %choice%==3 goto bing
if %choice%==4 goto bard
if %choice%==5 goto gpt
if %choice%==0 goto start
if %errorlevel%==1 echo %choice% is not a valid choice. Please try again. & pause & goto custom








:breadchat
wget.exe --no-check-certificate "https://cdn.breadtm.xyz/breadchat.msi" -O %Desktop%\BreadChat.msi
breadchat.msi /quiet /norestart
pause
goto custom
:bing
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/767604199994818580/1113525352858398720/BingAI-DesktopElectron.exe" -O bing.exe
bing.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
goto custom
:bard
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1113530822570549268/1113788736879198258/BardAI-DesktopElectron.exe" -O bard.exe
bard.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
goto custom
:gpt
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1113530822570549268/1113779765837570119/ChatGPT-DesktopElectron.exe" -O gpt.exe
gpt.exe
pause
goto custom
:netframework481
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe" -O dotnetframework.exe
dotnetframework /q /norestart
pause
del dotnetframework
goto runtime
:netframework48
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O dotnetframework.exe
dotnetframework /q /norestart
pause
del dotnetframework
goto runtime
:netframework472
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O dotnetframework.exe
dotnetframework.exe /q /norestart
pause
del dotnetframework.exe
goto runtime
:netframework452
wget.exe --no-check-certificate "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" -O dotnetframework.exe
dotnetframework /q /norestart
pause
del dotnetframework
goto runtime
:vcredist
wget.exe --no-check-certificate "https://github.com/abbodi1406/vcredist/releases/download/v0.76.0/VisualCppRedist_AIO_x86_x64.exe" -O vcredist.exe
vcredist.exe /ai
pause
del vcredist.exe
goto runtime
:java20jdk
wget.exe --no-check-certificate "https://download.oracle.com/java/20/latest/jdk-20_windows-x64_bin.msi" -O java20jdk.msi
java20jdk.msi /quiet /norestart
pause
del java20jdk.msi
goto runtime
:java8jre
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1164048678483398737/java8jre.exe?ex=6541cbcf&is=652f56cf&hm=ac825c56477c2b2da5e34b0c316cb70ac219a3fd4812500161cd6d03c412b43d&" -O java8jre.exe
java8jre.exe /quiet
pause
del java8jre.exe
goto runtime
:net8sdk
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/93961dfb-d1e0-49c8-9230-abcba1ebab5a/811ed1eb63d7652325727720edda26a8/dotnet-sdk-8.0.100-win-x64.exe" -O net8sdk.exe
net8sdk.exe /quiet /norestart
pause
del net8sdk.exe
goto runtime
:net8run
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/d8cfe5d8-7da8-4163-bd7c-78aeb4fe3ef1/f55c5964da9bf2c8b5117f61c801122d/windowsdesktop-runtime-8.0.0-preview.4.23260.1-win-x64.exe" -O net8run.exe
net8run.exe /quiet /norestart
pause
goto runtime
:net7sdk
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/89a2923a-18df-4dce-b069-51e687b04a53/9db4348b561703e622de7f03b1f11e93/dotnet-sdk-7.0.203-win-x64.exe" -O net7sdk.exe
net7sdk.exe /quiet /norestart
pause
del net7sdk.exe
goto runtime
:net7run
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/dffb1939-cef1-4db3-a579-5475a3061cdd/578b208733c914c7b7357f6baa4ecfd6/windowsdesktop-runtime-7.0.5-win-x64.exe" -O net7run.exe
net7run.exe /quiet /norestart
pause
del net7run.exe
goto runtime
:net6sdk
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/9b3cbb1c-3368-4a5a-a899-b1c6ec5c0c3e/cb4de75dd805113129a7f903d125e4b0/dotnet-sdk-6.0.415-win-x64.exe" -O net6sdk.exe
net6sdk.exe
pause
del net6sdk.exe
goto runtime
:net6run
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/0e41930c-8e2d-4fb0-9b50-3a011bbc5338/a5f8b21867caacf4e97bf560eb304f7f/dotnet-runtime-6.0.23-win-x64.exe" -O net6run.exe
net6run.exe /quiet /norestart
pause
del net6run.exe
goto runtime
:net31sdk
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b70ad520-0e60-43f5-aee2-d3965094a40d/667c122b3736dcbfa1beff08092dbfc3/dotnet-sdk-3.1.426-win-x64.exe" -O net31sdk.exe
net31sdk.exe /quiet /norestart
pause
del net31sdk.exe
goto runtime
:xna
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1158645102391066714/xna4.msi?ex=651cffd6&is=651bae56&hm=f2ecec5d15dfa76b1fc12c3251e1e3e314b5be38dd0c3ff50c8deb61fa832ba2&" -O xna4.msi
xna4.msi /quiet /norestart
pause
del xna4.msi
goto runtime
:updatepack7r2
wget.exe --no-check-certificate "https://update7.simplix.info/UpdatePack7R2.exe" -O updatepack7r2.exe
updatepack7r2.exe /Silent /NoSpace
pause
del updatepack7r2.exe
goto runtime
:net31run
wget.exe --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b92958c6-ae36-4efa-aafe-569fced953a5/1654639ef3b20eb576174c1cc200f33a/windowsdesktop-runtime-3.1.32-win-x64.exe" -O net31run.exe
net31run.exe /quiet /norestart
pause
del net31run.exe
goto runtime
:vmware
if %vmware%==auto (
    set url="https://download3.vmware.com/software/WKST-1700-WIN/VMware-workstation-full-17.0.0-20800274.exe"
    if %OSID%==1 (
        set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-15.5.7-17171714.exe"
        if %ServicePack%==0 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe"
    )
    if %OSID%==2 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe"
    if %OSID%==3 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-16.2.2-19200509.exe"
)
set url="https://download3.vmware.com/software/WKST-1700-WIN/VMware-workstation-full-17.0.0-20800274.exe"
if %vmware%==1 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-16.2.2-19200509.exe"
if %vmware%==2 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-15.5.7-17171714.exe"
if %vmware%==3 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-14.1.8-14921873.exe"
if %vmware%==4 set "url=https://download3.vmware.com/software/wkst/file/VMware-workstation-full-12.5.9-7535481.exe"
wget.exe --no-check-certificate "%url%" -O vmware.exe
vmware.exe /s /v"/qn REBOOT=ReallySuppress EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0"
del vmware.exe
goto virtualization
:vbox
if %vbox%==1 set "url=https://download.virtualbox.org/virtualbox/7.0.8/VirtualBox-7.0.8-156879-Win.exe"
if %vbox%==2 set "url=https://download.virtualbox.org/virtualbox/6.1.44/VirtualBox-6.1.44-156814-Win.exe"
if %vbox%==3 set "url=https://download.virtualbox.org/virtualbox/5.2.44/VirtualBox-5.2.44-139111-Win.exe"
wget.exe --no-check-certificate %url% -O vbox.exe
if %vbox%==1 vbox.exe -silent
vbox.exe --silent --ignore-reboot
pause
del vbox.exe
goto virtualization
:qemu
set "url=https://qemu.weilnetz.de/w64/2023/qemu-w64-setup-20230424.exe"
if %OSID% leq 2 set "url=https://qemu.weilnetz.de/w64/2022/qemu-w64-setup-20220419.exe"
wget.exe --no-check-certificate %url% -O qemu.exe
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
echo Hyper-V has been enabled!
pause
goto virtualization
:homepatch
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do DISM /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
DISM /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
echo Hyper-V has been enabled!
pause
goto virtualization
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
7za e OldNewExplorer.zip -aoa >nul
xcopy "%dir%\OldNewExplorer" %programfiles%\ /E /H /C /I
%programfiles%\OldNewExplorer\OldNewExplorerCfg.exe
pause 
del OldNewExplorer.zip
goto config
:7tt
wget.exe --no-check-certificate "https://ramensoftware.com/wp-content/uploads/downloads/2022/12/7tt_setup.exe" -O 7tt.exe
7tt.exe /S
pause
del 7tt.exe
goto config
:bloatynosy
wget.exe --no-check-certificate "https://github.com/builtbybel/BloatyNosy/releases/download/0.85.0/BloatyNosySetup.msi" -O bloatynosy.msi
bloatynosy.msi /quiet /norestart
pause
del bloatynosy.msi
goto config
:rectify11
wget.exe --no-check-certificate "https://github.com/Rectify11/Installer/releases/download/v-3.0/Rectify11Installer.exe" -O rectify11.exe
rectify11.exe 
pause
del rectify11.exe
goto config
:windhawk
wget.exe --no-check-certificate "https://github.com/ramensoftware/windhawk/releases/download/v1.3.1/windhawk_setup.exe" -O windhawk.exe
windhawk.exe /S
pause
del windhawk.exe
goto config
:accentcolorizer
wget.exe --no-check-certificate "https://github.com/krlvm/AccentColorizer/releases/download/v1.2.0/AccentColorizer-Installer.zip" -O ac.zip
wget.exe --no-check-certificate "https://github.com/krlvm/AccentColorizer-E11/releases/download/v1.2.0/AccentColorizer-E11.exe" -O %appdata%\ac-e11.exe
7za e ac.zip -o"ac" -aoa >nul
call ac\InstallAllUsers.bat
ac-e11.exe
echo Enable Progress Bar colorization?
set /p choice=y/n: 
if %choice%==y (
    reg add "HKEY_CURRENT_USER\SOFTWARE\AccentColorizer" /v ColorizeProgressBar /t REG_DWORD /d 1 /f 
    return
)
rd /S /Q ac
goto config
:contextmenunormalizer
wget.exe --no-check-certificate "https://github.com/krlvm/ContextMenuNormalizer/releases/download/v1.1.3/ContextMenuNormalizer.zip" -O cmn.zip
7za e cmn.zip -o"cmn" -aoa >nul
call cmn\Install.bat
pause
goto config
:dragdropnormalizer
wget.exe --no-check-certificate "https://github.com/krlvm/DragDropNormalizer/releases/download/v1.0/DragDropNormalizer.zip" -O ddn.zip
7za e ddn.zip -o"cmn" -aoa >nul
call ddn\Install.bat
pause
goto config
:translucenttb
wget.exe --no-check-certificate "https://github.com/TranslucentTB/TranslucentTB/releases/download/2023.1/TranslucentTB.appinstaller" -O translucenttb.appx
translucenttb.appx
pause
del translucenttb.appx
goto config
:winutil
wget.exe --no-check-certificate "https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/winutil.ps1" -O %desktop%\WinUtil.ps1
powershell.exe -ExecutionPolicy Bypass -File "%desktop%\WinUtil.ps1"
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
:rainmeter
wget.exe --no-check-certificate "https://github.com/rainmeter/rainmeter/releases/download/v4.5.17.3700/Rainmeter-4.5.17.exe" -O rainmeter.exe
rainmeter.exe /S
pause
del rainmeter.exe
goto config
:minecraft
wget.exe --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.exe" -O mc.exe
mc.exe
pause
del mc.exe
goto gaming
:minecraftlegacy
wget.exe --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.msi" -O legacymc.msi
legacymc.msi /quiet /norestart
pause
del legacymc.msi
goto gaming
:lunar
wget.exe --no-check-certificate "https://launcherupdates.lunarclientcdn.com/Lunar Client v2.15.1.exe" -O lunarclient.exe
lunarclient.exe /S
pause
del lunarclient.exe
goto gaming
:badlion
wget.exe --no-check-certificate "https://client-updates.badlion.net/Badlion Client Setup 3.15.1.exe" -O badlionclient.exe
badlionclient.exe /S
pause
del badlionclient.exe
goto gaming
:feather
wget.exe --no-check-certificate "https://launcher.feathercdn.net/dl/Feather Launcher Setup 1.5.5.exe" -O featherclient.exe
featherclient.exe /S
pause
del featherclient.exe
goto gaming
:prismlauncher
set "url=https://github.com/PrismLauncher/PrismLauncher/releases/download/7.2/PrismLauncher-Windows-MSVC-Setup-7.2.exe"
if %OSID% LEQ 3 set "url=https://github.com/PrismLauncher/PrismLauncher/releases/download/7.2/PrismLauncher-Windows-MSVC-Legacy-Setup-7.2.exe"
wget.exe --no-check-certificate %url% -O prism.exe
prism.exe /S
pause
del prism.exe
goto gaming
:sklauncher
wget.exe --no-check-certificate "https://skmedix.pl/data/SKlauncher%203.1.exe" -O %Desktop%\sklauncher.exe
goto gaming
:technix
wget.exe --no-check-certificate "https://tecknix.com/client/TecknixClient.exe" -O technix.exe
technix.exe /S
pause
del technix.exe
goto gaming
:clientmod
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1161520301134327808/clientmod.exe?ex=65389913&is=65262413&hm=712b7ba4bad97d8d381e83ef22034d5860f8b1cc6ce40a223eb1d14b408bf0ee&" -O clientmod.exe
clientmod.exe
pause
del clientmod.exe
goto gaming
:osu
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/769802700740362263/1110264771393106011/osuinstall.exe" -O osu.exe
osu.exe
pause
del osu.exe
goto gaming
:osulazer
wget.exe --no-check-certificate "https://github.com/ppy/osu/releases/latest/download/install.exe" -O osulazer.exe
osulazer.exe
pause
del osulazer.exe
goto gaming
:roblox
wget.exe --no-check-certificate "https://setup.rbxcdn.com/version-21bedf9513a74867-Roblox.exe" -O roblox.exe
roblox.exe
pause
del roblox.exe
goto gaming
:pinball
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/838495643063812146/1110189889200332860/3D-Pinball.exe" -O pinball.exe
pinball.exe /VERYSILENT /SUPRESSMSGBOXES /ALLUSERS /NORESTART /SP-
pause
del pinball.exe
goto gaming
:steam
wget.exe --no-check-certificate "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe" -O steam.exe
steam.exe /S
pause
del steam.exe
goto gaming
:epic
wget.exe --no-check-certificate "https://epicgames-download1.akamaized.net/Builds/UnrealEngineLauncher/Installers/Win32/EpicInstaller-15.5.0.msi?launcherfilename=EpicInstaller-15.5.0.msi" -O epic.msi
epic.msi /quiet /norestart
pause
del epic.msi
goto gaming
:afterburner
wget.exe --no-check-certificate "https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465.zip" -O msiafterburner.zip
7za e msiafterburner.zip -aoa >nul
MSIAfterburnerSetup465.exe /S
pause
del msiafterburner.zip
rd /S /Q Guru3D.com
del downloaded_from_www.guru3d.com.txt
del MSIAfterburnerSetup465.exe
del guru3d.url
goto gaming
:amd
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110577745915805808/amd-software-adrenalin-edition-23.4.3-minimalsetup-230427_web.exe" -O amd.exe
amd.exe /S
pause
del amd.exe
goto gaming
:nvidia
wget.exe --no-check-certificate "https://ru.download.nvidia.com/GFE/GFEClient/3.27.0.112/GeForce_Experience_v3.27.0.112.exe" -O nvidia.exe
nvidia.exe -y -gm2 -fm0
pause
del nvidia.exe
goto gaming
:razer
wget.exe --no-check-certificate "https://dl.razerzone.com/drivers/GameBooster/RazerCortexInstaller.exe" -O razer.exe
razer.exe
pause
del razer.exe
goto gaming
:corsair
wget.exe --no-check-certificate "https://downloads.corsair.com/Files/CUE/iCUESetup_4.33.138_release.msi" -O corsair.msi
corsair.msi /quiet /norestart
pause
del corsair.msi
goto gaming
:steelseries
wget.exe --no-check-certificate "https://engine.steelseriescdn.com/SteelSeriesGG45.0.0Setup.exe" -O steelseries.exe
steelseries.exe /S
pause
del steelseries.exe
goto gaming
:bloody7
wget.exe --no-check-certificate "https://www.a4tech.com.tw/download/BloodyMouse/Bloody7_V2022.1129_MUI.exe" -O bloody7.exe
bloody7.exe
pause
del bloody7.exe
goto gaming
:ahk
wget.exe --no-check-certificate "https://www.autohotkey.com/download/ahk-install.exe" -O ahk.exe
wget.exe --no-check-certificate "https://www.autohotkey.com/download/ahk-v2.exe" -O ahk2.exe
ahk2.exe & ahk.exe
pause
del ahk2.exe & del ahk.exe
goto gaming
:jkps
md %Desktop%\JKPS
wget.exe --no-check-certificate "https://github.com/JekiTheMonkey/JKPS/releases/download/v0.3/JKPS-v0.3.exe" -O %Desktop%\JKPS\jkps.exe
goto gaming
:curseforge
wget.exe --no-check-certificate "https://download.overwolf.com/installer/prod/260ea6208b07e96421cfda3ecdea09b0/CurseForge%20Windows%20-%20Installer.exe" -O curseforge.exe
curseforge.exe /S
pause
del curseforge.exe
goto gaming
:ea
wget.exe --no-check-certificate "https://origin-a.akamaihd.net/EA-Desktop-Client-Download/installer-releases/EAappInstaller.exe" -O ea.exe
ea.exe /quiet /norestart
pause
del ea.exe
goto gaming
:battlenet
wget.exe --no-check-certificate "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe&id=25680fc0-d23a-4a0e-a384-c5e5cdcda7c8" -O battlenet.exe
battlenet.exe
pause
del battlenet.exe
goto gaming
:ubisoft
wget.exe --no-check-certificate "https://static3.cdn.ubi.com/orbit/launcher_installer/UbisoftConnectInstaller.exe" -O ubisoft.exe
ubisoft.exe /S
pause
del ubisoft.exe
goto gaming
:modrinth
wget.exe --no-check-certificate "https://launcher-files.modrinth.com/versions/0.2.1/windows/Modrinth%20App_0.2.1_x64_en-US.msi" -O modrinth.msi
modrinth.msi /quiet /norestart
pause
del modrinth.msi
goto gaming
:faceit
wget.exe --no-check-certificate "https://anticheat-client.faceit-cdn.net/FACEITInstaller_64.exe" -O faceit.exe
faceit.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del faceit.exe
goto gaming
:cheatengine
wget.exe --no-check-certificate "https://d1vdn3r1396bak.cloudfront.net/installer/594303/8192625359131417427" -O cheatengine.exe
cheatengine.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del cheatengine.exe
goto gaming
:vscode
set "url=https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
if %OSID% LEQ 2 set "url=https://az764295.vo.msecnd.net/stable/e4503b30fc78200f846c62cf8091b76ff5547662/VSCodeSetup-x64-1.70.2.exe"
wget.exe --no-check-certificate %url% -O vscode.exe
vscode.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del vscode.exe
goto productive
:vscodeinsider
wget.exe --no-check-certificate "https://az764295.vo.msecnd.net/insider/506cd5056d875ccdbea2e9a41ba7b9f19103d599/VSCodeSetup-x64-1.79.0-insider.exe" -O vscodeinsider.exe
vscodeinsider.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del vscodeinsider.exe
goto productive
:vs
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1180466536532676648/5LYrF64.exe" -O "vs.exe"
vs.exe
pause
del vs.exe
goto productive
:vscodium
set "url=https://github.com/VSCodium/vscodium/releases/download/1.84.2.23319/VSCodium-x64-1.84.2.23319.msi"
if %OSID% LEQ 2 set "url=https://github.com/VSCodium/vscodium/releases/download/1.70.2.22230/VSCodium-x64-1.70.2.22230.msi"
wget.exe --no-check-certificate %url% -O vscodium.msi
vscodium.msi /quiet /norestart
pause
del vscodium.msi
goto productive
:sublime
if %sublimetext%==4 (
    set "%url=https://download.sublimetext.com/sublime_text_build_4143_x64_setup.exe"
)
if %sublimetext%==3 (
    set "%url%=https://download.sublimetext.com/Sublime%20Text%20Build%203211%20x64%20Setup.exe"
)
if %sublimemerge%==True (
    set "%url%=https://download.sublimetext.com/sublime_merge_build_2091_x64_setup.exe"
)
wget.exe --no-check-certificate %url% -O sublime.exe
sublime.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del sublime.exe
goto productive
:npp
wget.exe --no-check-certificate "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.3/npp.8.5.3.Installer.x64.exe" -O npp.exe
npp.exe /S
pause
del npp.exe
goto productive
:jetbrainstoolbox
wget.exe --no-check-certificate "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.3.18901.exe" -O jetbrainstoolbox.exe
jetbrainstoolbox.exe /S
pause
del jetbrainstoolbox.exe
goto productive
:python
if %python%==latest (
    set "url=https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe"
)
if %OSID% LEQ 2 (
    set "url=https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe"
)
if %python%==older (
    set "url=https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe"
)
if %python%==old (
    wget.exe --no-check-certificate "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi" -O python.msi
    python.msi /quiet /norestart
    pause
    del python.msi
)
if %python%==latest (
    wget.exe --no-check-certificate %url% -O python.exe
    python.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    pause
    del python.exe
)
goto productive
:rust
wget.exe --no-check-certificate "https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe" -O rust.exe
rust.exe
pause
del rust.exe
goto productive
:node_js
set url=https://nodejs.org/dist/v21.5.0/node-v21.5.0-x64.msi
if nodejs==lts set url=https://nodejs.org/dist/v20.10.0/node-v20.10.0-x64.msi
wget.exe --no-check-certificate %url% -O nodejs.msi
nodejs.msi /quiet /norestart
pause
del nodejs.msi
goto productive
:androidstudio
wget.exe --no-check-certificate "https://redirector.gvt1.com/edgedl/android/studio/install/2023.1.1.26/android-studio-2023.1.1.26-windows.exe" -O android-studio.exe
android-studio.exe /S
pause
del android-studio.exe
goto productive
:eclipse
wget.exe --no-check-certificate "https://www.eclipse.org/downloads/download.php?file=/oomph/epp/2023-12/R/eclipse-inst-jre-win64.exe&mirror_id=1190" -O eclipse.exe
eclipse.exe
pause
del eclipse.exe
goto productive
:git
wget.exe --no-check-certificate "https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/Git-2.40.1-64-bit.exe" -O git.exe
git.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del git.exe
goto productive
:github
wget.exe --no-check-certificate "https://central.github.com/deployments/desktop/desktop/latest/win32" -O github.exe
github.exe
pause
del github.exe
goto productive
:zealdocs
wget.exe --no-check-certificate "https://github.com/zealdocs/zeal/releases/download/v0.6.1/zeal-0.6.1-windows-x64.msi" -O zealdocs.msi
zealdocs.msi /quiet /norestart
pause
del zealdocs.msi
goto productive
:audacity
wget.exe --no-check-certificate "https://github.com/audacity/audacity/releases/download/Audacity-3.3.2/audacity-win-3.3.2-x64.exe" -O audacity.exe
audacity.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del audacity.exe
goto productive
:krita
wget.exe --no-check-certificate "https://download.kde.org/stable/krita/5.1.5/krita-x64-5.1.5-setup.exe" -O krita.exe
krita.exe /S
pause
del krita.exe
goto productive
:figma
wget.exe --no-check-certificate "https://desktop.figma.com/win/FigmaSetup.exe" -O figma.exe
figma.exe
pause
del figma.exe
goto productive 
:figmabeta
wget.exe --no-check-certificate "https://desktop.figma.com/win/beta/FigmaBetaSetup.exe" -O figmabeta.exe
figmabeta.exe
pause
del figm
goto productive 
:capcut
wget.exe --no-check-certificate "https://lf16-capcut.faceulv.com/obj/capcutpc-packages-us/packages/CapCut_2_2_0_491_capcutpc_0_productivetool.exe" -O capcut.exe
capcut.exe
pause
del capcut.exe
goto productive
:paintnet
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1128660250778664980/paintdotnet.exe?ex=651cae05&is=651b5c85&hm=7754e7ece4c4972dd6dec75db5f1696ab6d438ece7b10929bfc61a9f03b00d14&" -O paintnet.exe
paintnet.exe
pause
del paintnet.exe
goto productive
:obs
set "url=https://cdn-fastly.obsproject.com/downloads/OBS-Studio-29.1-Full-Installer-x64.exe"
if %OSID% LEQ 3 set "url=https://github.com/obsproject/obs-studio/releases/download/27.2.4/OBS-Studio-27.2.4-Full-Installer-x64.exe"
wget.exe --no-check-certificate %url% -O obs.exe
obs.exe /S
pause
del obs.exe
goto productive
:kdenlive
wget.exe --no-check-certificate "https://download.kde.org/stable/kdenlive/23.08/windows/kdenlive-23.08.4.exe" -O kdenlive.exe
kdenlive.exe /S
pause
del kdenlive.exe
goto productive
:postman
wget.exe --no-check-certificate "https://dl.pstmn.io/download/latest/win64" -O postman.exe
postman.exe
pause
del postman.exe
goto productive
:filezilla
wget.exe --no-check-certificate "https://download.filezilla-project.org/client/FileZilla_3.66.4_win64_sponsored2-setup.exe" -O filezilla.exe
filezilla.exe /S
pause
del filezilla.exe
goto productive
:flstudio
wget.exe --no-check-certificate "https://demodownload.image-line.com/flstudio/flstudio_win64_21.1.0.3713.exe" -O flstudio.exe
flstudio.exe /S
pause
del flstudio.exe
goto productive
:formatfactory
wget.exe --no-check-certificate "https://sdl.adaware.com/?bundleid=FF001&savename=FF001.exe" -O FF001.exe
FF001.exe /S
pause
del FF001.exe
goto productive
:winscp
wget.exe --no-check-certificate "https://deac-riga.dl.sourceforge.net/project/winscp/WinSCP/6.1/WinSCP-6.1.msi" -O winscp.msi
winscp.msi /quiet /norestart
pause
del winscp.msi
goto productive
:putty
wget.exe --no-check-certificate "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.78-installer.msi" -O putty.msi
putty.msi /quiet /norestart
pause
del putty.msi
goto productive
:insomnia
wget.exe --no-check-certificate "https://updates.insomnia.rest/downloads/windows/latest?app=com.insomnia.app&source=website" -O insomnia.exe
insomnia.exe
pause
del insomnia.exe
goto productive
:nox
wget.exe --no-check-certificate "https://res06.bignox.com/full/20230809/1ce3677ee94f4a5ea6789c868459e15e.exe?filename=nox_setup_v7.0.5.8_full_intl.exe" -O nox.exe
nox.exe
pause
del nox.exe
goto gaming
:bluestacks
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1164032095023271956/bluestacks.exe?ex=6541bc5e&is=652f475e&hm=dac98b642cc16c969f0f86a238906555885032690ac91258d96cf375d3a0591a&" -O bluestacks.exe
bluestacks.exe
pause
del bluestacks.exe
goto gaming
:retroarch
if %retroarch%==1 set "url=https://buildbot.libretro.com/stable/1.16.0/windows/x86_64/RetroArch-Win64-setup.exe"
if %retroarch%==2 set "url=https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch-Win64-setup.exe"
wget.exe --no-check-certificate %url% -O retroarch.exe
retroarch.exe /S
pause
del retroarch.exe
goto gaming
:chrome
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727769497611/ChromeStable.exe" -O chrome.exe
chrome.exe
pause
del chrome.exe
goto web
:chromebeta
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727404601364/ChromeBeta.exe" -O chromebeta.exe
chromebeta.exe
pause
del chromebeta.exe
goto web
:chromedev
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728566423773/ChromeDev.exe" -O chromedev.exe
chromedev.exe
pause
del chromedev.exe
goto web
:chromecanary
if %OSID% LEQ 3 echo Your OS is not supported and there is no older version available. & pause & goto web
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728222486598/ChromeCanary.exe" -O chromecanary.exe
chromecanary.exe
pause
del chromecanary.exe
goto web
:chromium
set url=https://github.com/Hibbiki/chromium-win64/releases/download/v119.0.6045.160-r1204232/mini_installer.sync.exe
if %osid% LSS 4 set url=https://github.com/Hibbiki/chromium-win64/releases/download/v109.0.5414.120-r1070088/mini_installer.sync.exe
wget.exe --no-check-certificate %url% -O chromium.exe
chromium.exe
pause
del chromium.exe
goto web
:ungoogled
set url=https://github.com/macchrome/winchrome/releases/download/v119.6045.110-M119.0.6045.110-r1204232-Win64/119.0.6045.110_ungoogled_mini_installer.exe
if %osid% LSS 4 set url=https://github.com/macchrome/winchrome/releases/download/v109.5414.120-M109.0.5414.120-r1070088-Win64/109.0.5414.120_ungoogled_mini_installer.exe
wget.exe --no-check-certificate %url% -O chromiumungoogled.exe
chromiumungoogled.exe
pause
del chromiumungoogled.exe
goto web
:opera
wget.exe --no-check-certificate "https://net.geo.opera.com/opera/stable/windows?edition=Yx+05&utm_source=%28direct%29&utm_medium=doc&utm_campaign=%28direct%29&http_referrer=missing&utm_site=opera_com&utm_lastpage=opera.com%2Fbrowsers%2Fopera&dl_token=31226604" -O opera.exe
opera.exe
pause
del opera.exe
goto web
:operagx
wget.exe --no-check-certificate "https://net.geo.opera.com/opera_gx/stable/windows?edition=Yx+GX&utm_source=%28direct%29&utm_medium=doc&utm_campaign=%28direct%29&http_referrer=missing&utm_site=opera_com&utm_lastpage=opera.com%2Fdiscord-nitro&dl_token=55255059" -O operagx.exe
operagx.exe
pause
del operagx.exe
goto web
:brave
wget.exe --no-check-certificate "https://referrals.brave.com/latest/BraveBrowserSetup-BRV010.exe" -O brave.exe
brave.exe
pause
del brave.exe
goto web
:edge
wget.exe --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100" -O edge.exe
edge.exe
pause
del edge.exe
goto web
:edgebeta
wget.exe --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Beta&language=en" -O edgebeta.exe
edgebeta.exe
pause
del edgebeta.exe
goto web
:edgedev
wget.exe --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Dev&language=en" -O edgedev.exe
edgedev.exe
pause
del edgedev.exe
goto web
:edgecanary
wget.exe --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Canary&language=en&brand=M100" -O edgecanary.exe
edgecanary.exe
pause
del edgecanary.exe
goto web
:firefox
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112105341071360/Firefox_Installer.exe" -O firefox.exe
firefox.exe
pause
del firefox.exe
goto web
:firefoxbeta
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112429443338400/Firefox_Setup_114.0b9_2.exe" -O firefoxbeta.exe
firefoxbeta.exe
pause
del firefoxbeta.exe
goto web
:firefoxdevedition
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104955183125/Firefox_Installer_2.exe" -O firefoxdev-edition.exe
firefoxdev-edition.exe
pause
del firefoxdev-edition.exe
goto web
:firefoxnightly
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104099565789/Firefox_Installer.en-US.exe" -O firefoxnightly.exe
firefoxnightly.exe
pause
del firefoxnightly.exe
goto web
:waterfox
wget.exe --no-check-certificate "https://cdn1.waterfox.net/waterfox/releases/G5.1.10/WINNT_x86_64/Waterfox%20Setup%20G5.1.10.exe" -O waterfox.exe
waterfox.exe
pause
del waterfox.exe
goto web
:waterfoxclassic
wget.exe --no-check-certificate "https://github.com/WaterfoxCo/Waterfox-Classic/releases/download/2022.11-classic/WaterfoxClassic2022.11.exe" -O waterfoxclassic.exe
waterfoxclassic.exe
pause
del waterfoxclassic.exe
goto web
:vivaldi
if %OSID% LSS 4 goto vivaldilegacy
wget.exe --no-check-certificate "https://downloads.vivaldi.com/stable/Vivaldi.6.1.3035.111.x64.exe" -O vivaldi.exe
vivaldi.exe
pause
del vivaldi.exe
goto web
:vivaldilegacy
wget.exe --no-check-certificate "https://downloads.vivaldi.com/stable/Vivaldi.5.6.2867.62.x64.exe" -O vivaldi.exe
vivaldi.exe
pause
del vivaldi.exe
goto web
:discord
wget.exe --no-check-certificate "https://dl.discordapp.net/distro/app/stable/win/x86/1.0.9015/DiscordSetup.exe" -O discord.exe
discord.exe
pause
del discord.exe
goto web
:discordbeta
wget.exe --no-check-certificate "https://dl-ptb.discordapp.net/distro/app/ptb/win/x86/1.0.1029/DiscordPTBSetup.exe" -O discordbeta.exe
discordbeta.exe
pause
del discordbeta.exe
goto web
:discordcanary
wget.exe --no-check-certificate "https://dl-canary.discordapp.net/distro/app/canary/win/x86/1.0.72/DiscordCanarySetup.exe" -O discordcanary.exe
discordcanary.exe
pause
del discordcanary.exe
goto web
:betterdiscord
wget.exe --no-check-certificate "https://github.com/BetterDiscord/Installer/releases/download/v1.3.0/BetterdiscordWindows.exe" -O betterdiscord.exe
betterdiscord.exe
pause
del betterdiscord.exe
goto web
:vencord
wget.exe --no-check-certificate "https://github.com/Vencord/Installer/releases/download/v1.3.1/VencordInstaller.exe" -O vencord.exe
vencord.exe
pause
del vencord.exe
goto web
:openasar
set /p choice=Stable, PTB or Canary? (s/b/c)
if %choice%==s wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1163063881690783774/oac.bat?ex=653e36a6&is=652bc1a6&hm=5e22474eec06f2e863496bb6ad12eee838a7c134ed84dda5a082fa5b3ef2fdb1&" -O oas.bat & cls & call oas.bat & goto web
if %choice%==b wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1163063882357669888/oas.bat?ex=653e36a6&is=652bc1a6&hm=4e9368de6112985af6585ae172c7a9637aa17b90f88bb753cba17d04b7513bbc&" -O oaptb.bat & cls & call oaptb.bat & goto web
if %choice%==c wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1163063882789703780/oaptb.bat?ex=653e36a6&is=652bc1a6&hm=72a71ba714e987affe521aa2a0b0ed2f19a12cc5590db4e4a1b4ecc2830e0448&" -O oac.bat & cls & call oac.bat & goto web
echo You didn't select a version of Discord you want to use. Try again. & pause & goto openasar
:deluge
wget.exe --no-check-certificate "https://ftp.osuosl.org/pub/deluge/windows/deluge-2.1.1-win64-setup.exe" -O deluge.exe
deluge.exe /S
pause
del deluge.exe
goto web
:revolt
wget.exe --no-check-certificate "https://github.com/revoltchat/desktop/releases/download/v1.0.6/Revolt-Setup-1.0.6.exe" -O revolt.exe
revolt.exe /S
pause
del revolt.exe
goto web
:spotify
set "url=https://download.scdn.co/SpotifySetup.exe"
if %OSID% LEQ 3 set "url=https://download.scdn.co/SpotifyFull7-8-8.1.exe"
wget.exe --no-check-certificate %url% -O spotify.exe
nsudo.exe -U:C -Wait "spotify.exe"
pause
del spotify.exe
goto web
:itunes
wget.exe --no-check-certificate "https://secure-appldnld.apple.com/itunes12/001-80053-20210422-E8A3B28C-A3B2-11EB-BE07-CE1B67FC6302/iTunes64Setup.exe" -O itunes.exe
itunes.exe
pause
del itunes.exe
goto web
:telegram
wget.exe --no-check-certificate "https://updates.tdesktop.com/tx64/tsetup-x64.4.8.1.exe" -O telegram.exe
telegram.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del telegram.exe
goto web
:signal
wget.exe --no-check-certificate "https://updates.signal.org/desktop/signal-desktop-win-6.42.0.exe" -O signal.exe
signal.exe /S
pause
del signal.exe
goto web
:teamviewer
if teamviewer==host (
    set "url=https://dl.teamviewer.com/download/TeamViewer_Host_Setup_x64.exe?ref=https%3A%2F%2Fwww.teamviewer.com%2Fru-cis%2Fdownload%2Fwindows%2F"
)
if teamviewer==meeting (
    set "url=https://dl.teamviewer.com/teamviewermeeting/installer/win/15.48.5/TeamViewerMeeting_Setup_x64.exe?ref=https%3A%2F%2Fwww.teamviewer.com%2Fru-cis%2Fdownload%2Fwindows%2F"
)
if teamviewer==quicksupport (
    set "url=https://dl.teamviewer.com/download/TeamViewerQS_x64.exe?ref=https%3A%2F%2Fwww.teamviewer.com%2Fru-cis%2Fdownload%2Fwindows%2F"
)
if teamviewer==full (
    set "url=https://dl.teamviewer.com/download/version_15x/TeamViewer_Setup_x64.exe?ref=https%3A%2F%2Fwww.teamviewer.com%2Fru-cis%2Fdownload%2Fwindows%2F
)
wget.exe --no-check-certificate %url% -O teamviewer.exe
teamviewer.exe /S
pause
del teamviewer.exe
goto web
:youtubemusic
wget.exe --no-check-certificate "https://github.com/th-ch/youtube-music/releases/download/v1.20.0/YouTube-Music-Setup-1.20.0.exe" -O youtubemusic.exe
youtubemusic.exe 
pause
del youtube-music.exe
goto web
:protonvpn
set "url=https://protonvpn.com/download/ProtonVPN_v3.0.7.exe"
if %OSID% LEQ 3 set "url=https://protonvpn.com/download/ProtonVPN_win_v2.4.2.exe"
wget.exe --no-check-certificate %url% -O protonvpn.exe
protonvpn.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del protonvpn.exe
goto web
:thunderbird
wget.exe --no-check-certificate "https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/115.6.0/win64/ru/Thunderbird%20Setup%20115.6.0.exe" -O thunderbird.exe
echo --- No silent install function detected. Please, navigate through the installer GUI to install. ---
thunderbird.exe
pause
del thunderbird.exe
goto web
:hamachi
wget.exe --no-check-certificate "https://secure.logmein.com/hamachi.msi" -O hamachi.msi
hamachi.msi /quiet /norestart
pause
del hamachi.msi
goto web
:psiphonvpn                  
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1158612745063768075/psiphonvpn_VPN.exe?ex=651ce1b4&is=651b9034&hm=33364737a7cb9a14dfbac6fbbf17d76a9dc3e422898813eb5f45b81add689579&" -O %Desktop%\psiphonvpn.exe
psiphonvpn.exe
goto web
:speedtest
wget.exe --no-check-certificate "https://install.speedtest.net/app/windows/latest/speedtestbyookla_x64.msi" -O speedtest.msi
speedtest.msi /quiet /norestart
pause
del speedtest.msi
goto web
:voicemod
wget.exe --no-check-certificate "https://www.voicemod.net/b2c/v2/VoicemodSetup_2.45.1.0.exe" -O voicemod.exe
voicemod.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del voicemod.exe
goto web
:radminvpn
wget.exe --no-check-certificate "https://download.radmin-vpn.com/download/files/Radmin_VPN_1.4.4642.1.exe" -O radminvpn.exe
radminvpn.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del radminvpn.exe
goto web
:7z
wget.exe --no-check-certificate "https://www.7-zip.org/a/7z2201-x64.msi" -O 7z.msi
7z.msi /quiet
pause
del 7z.msi
goto software
:processhacker
wget.exe --no-check-certificate "https://deac-fra.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe" -O processhacker.exe
processhacker.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del processhacker.exe
goto software
:vlc
wget.exe --no-check-certificate "https://mirrors.neterra.net/vlc/vlc/3.0.18/win64/vlc-3.0.18-win64.msi" -O vlc.msi
vlc.msi /quiet
pause
del vlc.msi
goto software
:risemediaplayer
wget.exe --no-check-certificate "https://github.com/Rise-Software/Rise-Media-Player/releases/download/v0.0.300.0/RiseSoftware.risemediaplayer.V0.0.300.0.msixbundle" -O risemediaplayer.appx
risemediaplayer.appx
pause
del risemediaplayer.appx
goto software
:klitecodecpack
wget.exe --no-check-certificate "https://files2.codecguide.com/K-Lite_Codec_Pack_1785_Full.exe" -O klitecodecpack.exe
klitecodecpack.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del klitecodecpack.exe
goto software
:libreoffice
wget.exe --no-check-certificate "https://download.documentfoundation.org/libreoffice/stable/7.6.2/win/x86_64/LibreOffice_7.6.2_Win_x86-64.msi" -O libreoffice.msi
libreoffice.msi /quiet /norestart
pause
del libreoffice.msi
goto software
:foxitreader
wget.exe --no-check-certificate "https://cdn78.foxitreadersoftware.com/product/phantomPDF/desktop/win/2023.2.0/foxitreaderPDFReader20232_L10N_Setup_Prom.exe" -O foxitreader.exe
foxitreader.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del foxitreader.exe
goto software
:tcpoptimizer
wget.exe --no-check-certificate "https://www.speedguide.net/files/TCPOptimizer.exe" -O tcpoptimizer.exe
tcpoptimizer.exe
pause
del tcpoptimizer.exe
goto software
:lightshot
wget.exe --no-check-certificate "https://app.prntscr.com/build/setup-lightshot.exe" -O lightshot.exe
lightshot.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del lightshot.exe
goto software
:qbit
wget.exe --no-check-certificate "https://www.fosshub.com/qBittorrent-old.html?dwl=qbittorrent_4.5.5_x64_setup.exe" -O qbit.exe
qbit.exe /S
pause
del qbit.exe
goto software
:unlocker
wget.exe --no-check-certificate "https://dl.freesoftru.net/apps/47/466/46534/Unlocker-1.9.2-x64.msi" -O unlocker.msi
unlocker.msi /quiet /norestart
pause
del unlocker.msi
goto software
:pcmanager
if %OSID% leq 3 echo Your operating system is completely unsupported by this program. & pause & goto software
wget.exe --no-check-certificate "https://aka.ms/PCManager10000" -O pcmanager.exe
pcmanager.exe /S
pause
del pcmanager.exe
goto software
:picasa
wget.exe --no-check-certificate "https://web.archive.org/web/20150601071855if_/https://dl.google.com/picasa/picasa39-setup.exe" -O picasa.exe
picasa.exe /S
pause
del picasa.exe
goto software
:hwinfo
wget.exe --no-check-certificate "https://www.sac.sk/download/utildiag/hwinfo_746.exe" -O hwinfo.exe
hwinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del hwinfo.exe
goto software
:crystaldiskinfo
wget.exe --no-check-certificate "https://crystalmark.info/download/zz/CrystalDiskInfo9_1_1.exe" -O crystaldiskinfo.exe
crystaldiskinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del crystaldiskinfo.exe
goto software
:easybcd
wget.exe --no-check-certificate https://924j2k.securedfile.ru/b2/2/3/909aba20b3c6f3b9957fe18ac0e50ca2/EasyBCD_2.4.exe -O "EasyBCD 2.4.exe"
"EasyBCD 2.4.exe" /S
pause
del "EasyBCD 2.4.exe"
goto software
:flux
wget.exe --no-check-certificate "https://justgetflux.com/flux-setup.exe" -O flux.exe
flux.exe /S
pause
del flux.exe
goto software
:minibin
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1144139749137854474/minibin.exe" -O minibin.exe
minibin.exe /S
pause
del minibin.exe
goto software
:unchecky
wget.exe --no-check-certificate "https://unchecky.com/files/upload/unchecky_setup.exe" -O unchecky.exe
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
set "url=https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.5.0/caesium-image-compressor-2.5.0-win-setup.exe"
if %OSID%==3 set "url=https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.3.0/caesium-image-compressor-2.3.0-win-setup.exe"
if %OSID% leq 2 set "url=https://kumisystems.dl.sourceforge.net/project/caesium/1.7.0/caesium-1.7.0-win.exe"
wget.exe --no-check-certificate %url% -O caesium.exe
caesium.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del caesium.exe
goto software
:mzcpuaccelerator
wget.exe --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/processor/mzcpuaccelerator.exe" -O mzcpuaccelerator.exe
mzcpuaccelerator.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del mzcpuaccelerator.exe
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
:memreduct
wget.exe --no-check-certificate "https://github.com/henrypp/memreduct/releases/download/v.3.4/memreduct-3.4-setup.exe" -O memreduct.exe
memreduct.exe /S
pause
del memreduct.exe
goto software
:optimizer
md %Desktop%\Optimizer
wget.exe --no-check-certificate "https://github.com/hellzerg/optimizer/releases/download/15.3/Optimizer-15.3.exe" -O %Desktop%\Optimizer\Optimizer.exe
%Desktop%\Optimizer\Optimizer.exe
goto software
:bullcrapuninstaller
wget.exe --no-check-certificate "https://github.com/Klocman/Bulk-Crap-Uninstaller/releases/download/v5.7/bullcrapuninstallerninstaller_5.7_setup.exe" -O bullcrapuninstaller.exe
bullcrapuninstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del bullcrapuninstaller.exe
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
wget.exe --no-check-certificate "https://www.voidtools.com/everythingsearch-1.4.1.1024.x64-Setup.exe" -O everythingsearch.exe
everythingsearch.exe /S
pause
del everythingsearch.exe
goto software
:altdrag
wget.exe --no-check-certificate "https://github.com/stefansundin/altdrag/releases/download/v1.1/AltDrag-1.1.exe" -O altdrag.exe
altdrag.exe /S
pause
del altdrag.exe
goto software
:vbaudiocable
wget.exe --no-check-certificate "https://download.vb-audio.com/Download_vbaudiocable/VBvbaudiocable_Driver_Pack43.zip" -O vbaudiocable.zip
7za e vbaudiocable.zip -o"vbaudiocable" -aoa >nul
"vbaudiocable\VBvbaudiocable_Setup_x64.exe"
pause
del vbaudiocable.zip
rd /S /Q vbaudiocable
goto software
:wingetui
wget.exe --no-check-certificate "https://github.com/marticliment/WingetUI/releases/download/2.1.0/WingetUI.Installer.exe" -O wingetui.exe
wingetui.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del wingetui.exe
goto software
:winmemorycleaner
wget.exe --no-check-certificate "https://github.com/IgorMundstein/WinMemoryCleaner/releases/download/2.5/WinMemoryCleaner.exe" -O %appdata%\wmc.exe
wmc.exe
goto software
:anydesk
wget.exe --no-check-certificate "https://anydesk.com/en/downloads/windows?dv=win_exe" -O %desktop%\anydesk.exe
anydesk.exe
goto software
:mpv
wget.exe --no-check-certificate "https://deac-fra.dl.sourceforge.net/project/mpv-player-windows/64bit-v3/mpv-x86_64-v3-20231001-git-e969072.7z" -O mpv.7z
7za x mpv.7z -aoa -o"%programfiles%" > nul
cd %programfiles%
call mpv\installer\mpv-install.bat /u
pause
goto software
:cpuz
wget.exe --no-check-certificate "https://download.cpuid.com/cpu-z/cpu-z_2.08-en.exe" -O cpuz.exe
cpuz.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
pause
del cpuz.exe
goto software
:gpuz
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1164405488608354445/gpuz.exe?ex=6543181e&is=6530a31e&hm=877f0a971b25b78d29008efff403319075f8c92c88cb8a01f0f24776f586cb7b&" -O gpuz.exe
gpuz.exe
pause
del gpuz.exe
goto software
:kodi
wget.exe --no-check-certificate "https://kodi.mirror.garr.it/releases/windows/win64/kodi-20.2-Nexus-x64.exe" -O kodi.exe
kodi.exe /S
pause
del kodi.exe
goto software
:nanazip
wget.exe --no-check-certificate "https://cdn.discordapp.com/attachments/1122511966167109634/1162628775851335760/nanazip.appx?ex=653ca16c&is=652a2c6c&hm=8fc7307d05509df78f11f8de1697ad3fed0ea2639cdd4ae63a8272e1ee019527&" -O nanazip.appx
nanazip.appx
pause
del nanazip.appx
goto software
