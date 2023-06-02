REM i seriously didn't update the main branch of this github repo up until stable release
@echo off

REM Windows version checker to disallow unsupported versions
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (set v=%%j.%%k) else (set v=%%i.%%j))
if "%v%" == "6.0" (
    echo The OS you are running is Windows Vista. 
    echo GX_ Pack doesn't support your OS. 
    echo A legacy pack will soon be made to work on your OS. 
    pause 
    exit
)
if "%v%" == "5.1" (
    echo The OS you are running is Windows XP. 
    echo GX_ Pack doesn't support your OS. 
    echo A legacy pack will soon be made to work on your OS. 
    pause 
    exit
)
if "%v%" == "5.0" (
    echo The OS you are running is Windows 2000. 
    echo GX_ Pack doesn't support your OS. 
    echo A legacy pack will soon be made to work on your OS. 
    pause
    exit
)
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OSArchitecture=x86 || set OSArchitecture=x64
if %OSArchitecture%==x86 (
    echo The OS you are running is using the x86 architecture. 
    echo GX_ Pack doesn't support this architecture.
    pause
    exit
)

    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system")
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

mode con: cols=120 lines=40
setlocal enableDelayedExpansion
set DownloadDirectory=%temp%\GXDownloads
if exist %DownloadDirectory% cd /d %DownloadDirectory%
if not exist %DownloadDirectory% md %DownloadDirectory% & cd /d %DownloadDirectory%

:prepare
cls
title Preparing GX_ Pack.
wget.exe -nc --no-check-certificate https://eternallybored.org/misc/wget/1.21.4/64/wget.exe -O wget.exe
goto extract
if errorlevel 9009 goto pwshwget
:pwshwget
cls & powershell -Command "$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12';[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols;Invoke-WebRequest https://eternallybored.org/misc/wget/1.21.4/64/wget.exe -OutFile %DownloadDirectory%\wget.exe"
if errorlevel 1 goto bitsadminwget
goto extract
:bitsadminwget
bitsadmin /create wgetdl & bitsadmin /SetSecurityFlags wgetdl 30 & bitsadmin /transfer wgetdl /download /priority high http://web.archive.org:80/web/20230511215002/https://eternallybored.org/misc/wget/1.21.4/64/wget.exe %DownloadDirectory%\wget.exe    
if errorlevel 9009 (
    cls
    echo Your operating system doesn't support BITSADMIN, which says that you are running Vista Home or any version of XP, which is outdated and unsupported by the script.
    pause
    exit
)
:extract
wget.exe -nc --no-check-certificate https://www.7-zip.org/a/7zr.exe -O 7zr.exe
wget.exe -nc --no-check-certificate https://www.7-zip.org/a/7z2201-extra.7z -O 7z-extra.7z
if exist 7za.exe goto start
7zr.exe -y e "7z-extra.7z" "x64\7za.exe" >nul
:start
set GXPACKVER=Pre-release (v1.0)
title GX_ Pack %GXPACKVER%
REM Windows version checker (redirection to correct windows logo modes)
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (set v=%%j.%%k) else (set v=%%i.%%j))
for /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuildNumber"') do set BuildNumber=%%b
if "%v%" == "6.3" set OperatingSystem=8.1  & set osid=3 & goto start108
if "%v%" == "6.2" set OperatingSystem=8 & set osid=2 & goto start108
if "%v%" == "6.1" set OperatingSystem=7 & set osid=1 & goto start7
if /I "%BuildNumber%" GEQ "21996" set OperatingSystem=11 & set Build=Build %BuildNumber% & set osid=5 & goto start11
set OperatingSystem=10 & set osid=4 & set Build=Build %BuildNumber% & goto start108

:start7
cls
echo.
echo.
echo             ,.=:!!t3Z3z.,
echo          :tt:::tt333EE3
echo         Et:::ztt33EEEL${c2} @Ee.,      ..,
echo        ;tt:::tt333EE7${c2} ;EEEEEEttttt33#
echo       :Et:::zt333EEQ.${c2} $EEEEEttttt33QL          GX_ Pack %GXPACKVER%
echo       it::::tt333EEF${c2} @EEEEEEttttt33F           Windows %OperatingSystem% %OSArchitecture%
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
echo.
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations (W10+)
echo    7. Runtimes
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto softwareinstall
if %choice%==2 goto webappsinstall
if %choice%==3 goto creatorinstall
if %choice%==4 goto gaminginstall
if %choice%==5 goto gameinstall
if %choice%==6 goto configinstall
if %choice%==7 goto runtimeinstall
if %choice%==0 exit
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause & goto start7

:start108
cls
echo.
echo.
echo.
echo                          ....,,:;+ccllll
echo            ...,,+:;  cllllllllllllllllll
echo      ,cclllllllllll  lllllllllllllllllll            GX_ Pack %GXPACKVER%
echo      llllllllllllll  lllllllllllllllllll            Windows %OperatingSystem% %OSArchitecture% 
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
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations (W10+)
echo    7. Runtimes
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto softwareinstall
if %choice%==2 goto webappsinstall
if %choice%==3 goto creatorinstall
if %choice%==4 goto gaminginstall
if %choice%==5 goto gameinstall
if %choice%==6 goto configinstall
if %choice%==7 goto runtimeinstall
if %choice%==0 exit
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause & goto start108

:start11
cls
echo.
echo.
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll                GX_ Pack %GXPACKVER%
echo    lllllllllllllll   lllllllllllllll                Windows %OperatingSystem% %OSArchitecture%
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
echo    1. Basic software.
echo    2. Web applications
echo    3. Creator applications.
echo    4. Gaming software.
echo    5. Games.
echo    6. Configurations (W10+)
echo    7. Runtimes
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto softwareinstall
if %choice%==2 goto webappsinstall
if %choice%==3 goto creatorinstall
if %choice%==4 goto gaminginstall
if %choice%==5 goto gameinstall
if %choice%==6 goto configinstall
if %choice%==7 goto runtimeinstall
if %choice%==0 exit
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause 
goto start11





:softwareinstall
cls 
title Basic software section - GX_ Pack %GXPACKVER%
echo.
echo.
echo    Select the options to install.
echo.
echo    1. 7-zip
echo    2. Process Hacker 2
echo    3. VLC
echo    4. MPC-HC
echo    5. qBitTorrent
echo    6. Unlocker
echo    7. Microsoft PC Manager (W10 1809+)
echo    8. Google Picasa 3
echo    9. HWiNFO
echo    10. CrystalDiskInfo
echo    11. EasyBCD
echo    12. Flux
echo    13. MiniBin
echo    14. Unchecky
echo    15. WizTree
echo    16. WizFile
echo    17. Ueli
echo    18. Caesium
echo    19. Mz CPU Accelerator 
echo    20. Winlaunch
echo    21. Fences (paid)
echo    22. Groupy (paid)
echo    23. Mem Reduct
echo    24. Optimizer
echo    25. BCUninstaller
echo.
echo.
echo    0. Go back
echo.
echo.
set choice=
set /p choice=Enter your choice:  
if %choice%==1 goto 7zip
if %choice%==2 goto processhacker
if %choice%==3 goto vlc
if %choice%==4 goto mpchc
if %choice%==5 goto qbit
if %choice%==6 goto unlocker
if %choice%==7 goto pcmanager
if %choice%==8 goto picasa
if %choice%==9 goto hwinfo
if %choice%==10 goto crystaldiskinfo
if %choice%==11 goto easybcd
if %choice%==12 goto flux
if %choice%==13 goto minibin
if %choice%==14 goto unchecky
if %choice%==15 goto wiztree
if %choice%==16 goto wizfile
if %choice%==17 goto ueli
if %choice%==18 goto caesium
if %choice%==19 goto mzcpuaccelerator
if %choice%==20 goto winlaunch
if %choice%==21 goto fences
if %choice%==22 goto groupy
if %choice%==23 goto memreduct
if %choice%==24 goto optimizer
if %choice%==25 goto bcuninstaller
if %choice%==0 goto start
if errorlevel 1 echo choice is not a valid choice. Please try again. & pause 
goto softwareinstall

:webappsinstall
cls & title Web app section - GX_ Pack %GXPACKVER%
echo.
echo.
echo.
echo    Select the options to install.
echo.
echo    Browsers:
echo    1. Google Chrome (Stable)
echo    2. Google Chrome (Beta)
echo    3. Google Chrome (Dev)
echo    4. Google Chrome (Canary)
echo    5. Microsoft Edge (Stable)
echo    6. Microsoft Edge (Beta)
echo    7. Microsoft Edge (Dev)
echo    8. Microsoft Edge (Canary)
echo    9. Firefox (Stable)
echo    10. Firefox (Beta)
echo    11. Firefox (Developer Edition)
echo    12. Firefox (Nightly)
echo.
echo    Other:
echo    13. Discord (Stable)
echo    14. Discord (PTB)
echo    15. Discord (Canary)
echo    16. Spotify
echo    17. iTunes
echo    18. Telegram Desktop
echo.
echo.
echo.
echo    0. Go back
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto chromestable
if %choice%==2 goto chromebeta
if %choice%==3 goto chromedev
if %choice%==4 goto chromecanary
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
if %choice%==16 goto spotify
if %choice%==17 goto itunes
if %choice%==18 goto telegram
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause 
goto webappsinstall





:creatorinstall
cls & title Creator section - GX_ Pack %GXPACKVER%
echo.
echo.
echo    Programming:
echo    1. VSCode
echo    2. Sublime Text
echo    3. Notepad++
echo    4. Python 3
echo    5. Python 2
echo    6. Git
echo    7. Github Desktop
echo    8. Zealdocs
echo.
echo    Creativity:
echo    9. Audacity
echo    10. Krita
echo    11. Paint.net
echo    12. OBS Studio
echo    13. FL Studio
echo.
echo    Other:
echo    14. Format Factory
echo    15. WinSCP
echo    16. PuTTY
echo.
echo    0. Go back
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto vscode
if %choice%==2 goto sublimetext
if %choice%==3 goto notepadplusplus
if %choice%==4 goto pythonver3
if %choice%==5 goto pythonver2
if %choice%==6 goto git
if %choice%==7 goto github
if %choice%==8 goto zealdocs
if %choice%==9 goto audacity
if %choice%==10 goto krita
if %choice%==11 goto paintdotnet
if %choice%==12 goto obsstudio
if %choice%==13 goto flstudio
if %choice%==14 goto formatfactory
if %choice%==15 goto winscp
if %choice%==16 goto putty
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause
goto creatorinstall





:gaminginstall
cls & title Gaming software section - GX_ Pack %GXPACKVER%
echo.
echo.
echo    Select the software to install.
echo.
echo    1. Steam
echo    2. MSI Afterburner + DirectX, RivaTuner
echo    3. AMD Adrenalin Software
echo    4. GeForce Experience
echo    5. cFosSpeed
echo    6. Razer Cortex
echo    7. Corsair iCue
echo    8. SteelSeries GG
echo.
echo    9. Go to the Game section
echo    0. Go back
echo.
echo.
set /p choice=...Enter your choice: 
if %choice%==1 goto steam
if %choice%==2 goto afterburner
if %choice%==3 goto amd
if %choice%==4 goto nvidia
if %choice%==5 goto cfos
if %choice%==6 goto razer
if %choice%==7 goto corsair
if %choice%==8 goto steelseries
if %choice%==9 goto gameinstall
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause
goto gaminginstall





:gameinstall
cls & title Game section - GX_ Pack %GXPACKVER%
echo.
echo.
echo    Select the games to install.
echo.
echo    Minecraft:
echo    1. Official Minecraft Launcher
echo    2. Official Legacy Minecraft Launcher
echo    3. Lunar Client
echo    4. Badlion Client
echo    5. Feather Client
echo.
echo    Other:
echo    6. Osu
echo    7. Osu (Lazer)
echo    8. 3D Pinball
echo.
echo    0. Go back
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto minecraft
if %choice%==2 goto minecraft_legacy
if %choice%==3 goto lunar
if %choice%==4 goto badlion
if %choice%==5 goto feather
if %choice%==6 goto osu
if %choice%==7 goto osulazer
if %choice%==8 goto pinball
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause
goto gaminginstall





:configinstall
cls & title Configuration section - GX_ Pack %GXPACKVER%
echo.
echo.
echo   Select the configurations to install.
echo.
echo   1. StartIsBack (W8)
echo   2. StartIsBack+ (W8.1)
echo   3. StartIsBack++ (W10)
echo   4. StartAllBack (W11)
echo   5. UltraUXThemePatcher
echo   6. ExplorerPatcher (W11)
echo   7. Winaero Tweaker
echo.
echo.
echo    0. Go back
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto sib
if %choice%==2 goto sibp
if %choice%==3 goto sibpp
if %choice%==4 goto sab
if %choice%==5 goto uxpatcher
if %choice%==6 goto explorerpatcher
if %choice%==7 goto winaerotweaker
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause
goto configinstall





:runtimeinstall
cls 
title Runtime/Development Kit section - GX_ Pack %GXPACKVER%
echo.
echo.
echo    Select the options to install..
echo.
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
echo.
echo.
set /p choice=...Enter your choice:  
if %choice%==1 goto vcredistaio
if %choice%==2 goto java8jre
if %choice%==3 goto framework481
if %choice%==4 goto framework48
if %choice%==5 goto framework472
if %choice%==6 goto framework452
if %choice%==7 goto net8runtimep4
if %choice%==8 goto net7runtime
if %choice%==9 goto net6runtime
if %choice%==10 goto netcore31sdk
if %choice%==11 goto java20jdk
if %choice%==12 goto net8sdkp4
if %choice%==13 goto net7sdk
if %choice%==14 goto net6sdk
if %choice%==15 goto netcore31runtime
if %choice%==0 goto start
if errorlevel 1 echo %choice% is not a valid choice. Please try again. & pause
goto runtimeinstall











:: --------------------
:: Runtime or Development Kit section
:: --------------------

:java8jre
    wget.exe -nc --no-check-certificate "https://download.bell-sw.com/java/8u372+7/bellsoft-jre8u372+7-windows-amd64-full.msi"-O %DownloadDirectory%\jre8.msi
    jre8.msi /quiet /norestart
    pause
    goto runtimeinstall
:framework481
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe" -O %DownloadDirectory%\netframework4.8.1.exe
    netframework4.8.1.exe /q /norestart
    pause
    goto runtimeinstall
:framework48
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O %DownloadDirectory%\netframework4.8.exe
    netframework4.8.exe /q /norestart
    pause
    goto runtimeinstall
:framework472
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe" -O %DownloadDirectory%\netframework4.7.2.exe
    netframework4.7.2.exe /q /norestart
    pause
    goto runtimeinstall
:framework452
    wget.exe -nc --no-check-certificate "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe" -O %DownloadDirectory%\netframework4.5.2.exe
    netframework4.5.2.exe /q /norestart
    pause
    goto runtimeinstall
:vcredistaio
    wget.exe -nc --no-check-certificate "https://dl.comss.org/download/Visual-C-Runtimes-All-in-One-Feb-2023.zip" -O %DownloadDirectory%\vcredistaio.zip
    7za e vcredistaio.zip -aoa > NUL
    start /wait %DownloadDirectory%\vcredist2005_x86.exe /q
    start /wait %DownloadDirectory%\vcredist2005_x64.exe /q
    start /wait %DownloadDirectory%\vcredist2008_x86.exe /qb
    start /wait %DownloadDirectory%\vcredist2008_x64.exe /qb
    start /wait %DownloadDirectory%\vcredist2010_x86.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2010_x64.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2012_x86.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2012_x64.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2013_x86.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2013_x64.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2015_2017_2019_2022_x86.exe /passive /norestart
    start /wait %DownloadDirectory%\vcredist2015_2017_2019_2022_x64.exe /passive /norestart
    pause
    goto runtimeinstall
:java20jdk
    wget.exe -nc --no-check-certificate "https://download.oracle.com/java/20/latest/jdk-20_windows-x64_bin.msi" -O %DownloadDirectory%\jdk20.msi
    jdk20.msi /quiet /norestart
    pause
    goto runtimeinstall
:net8sdk
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/1b55b379-5ef2-4f21-8fad-aba058913cbc/c26ee3ba55cb40407a79564e28ed6d98/dotnet-sdk-8.0.100-preview.4.23260.5-win-x64.exe" -O %DownloadDirectory%\net8sdk.exe
    net8sdk.exe /quiet /norestart
    pause
    goto runtimeinstall
:net8runtime
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/d8cfe5d8-7da8-4163-bd7c-78aeb4fe3ef1/f55c5964da9bf2c8b5117f61c801122d/windowsdesktop-runtime-8.0.0-preview.4.23260.1-win-x64.exe" -O %DownloadDirectory%\net8runtime.exe
    net8runtime.exe /quiet /norestart
    pause
    goto runtimeinstall
:net7sdk
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/89a2923a-18df-4dce-b069-51e687b04a53/9db4348b561703e622de7f03b1f11e93/dotnet-sdk-7.0.203-win-x64.exe" -O %DownloadDirectory%\net7sdk.exe
    net7sdk.exe /quiet /norestart
    pause
    goto runtimeinstall
:net7runtime
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/dffb1939-cef1-4db3-a579-5475a3061cdd/578b208733c914c7b7357f6baa4ecfd6/windowsdesktop-runtime-7.0.5-win-x64.exe" -O %DownloadDirectory%\net7runtime.exe
    net7runtime.exe /quiet /norestart
    pause
    goto runtimeinstall
:net6sdk
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/df42b901-8ce2-4131-941a-b3fa094ff3d8/556da65f7a2f6164bf3df932e030898a/dotnet-sdk-6.0.408-win-x64.exe" -O %DownloadDirectory%\net6sdk.exe
    net6sdk.exe
    pause
    goto runtimeinstall
:net6runtime
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/85473c45-8d91-48cb-ab41-86ec7abc1000/83cd0c82f0cde9a566bae4245ea5a65b/windowsdesktop-runtime-6.0.16-win-x64.exe" -O %DownloadDirectory%\net6runtime.exe
    net6runtime.exe /quiet /norestart
    pause
    goto runtimeinstall
:netcore31sdk
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b70ad520-0e60-43f5-aee2-d3965094a40d/667c122b3736dcbfa1beff08092dbfc3/dotnet-sdk-3.1.426-win-x64.exe" -O %DownloadDirectory%\netcore31sdk.exe
    netcore31sdk.exe /quiet /norestart
    pause
    goto runtimeinstall
:netcore31runtime
    wget.exe -nc --no-check-certificate "https://download.visualstudio.microsoft.com/download/pr/b92958c6-ae36-4efa-aafe-569fced953a5/1654639ef3b20eb576174c1cc200f33a/windowsdesktop-runtime-3.1.32-win-x64.exe" -O %DownloadDirectory%\netcore31runtime.exe
    netcore31runtime.exe /quiet /norestart
    pause
    goto runtimeinstall

:: --------------------
:: Config section
:: --------------------

:sib
    wget.exe -nc --no-check-certificate "https://www.startisback.com/StartIsBack_setup.exe" -O %DownloadDirectory%\startisback.exe
    startisback.exe
    pause
    goto configinstall
:sibpp
    wget.exe -nc --no-check-certificate "https://www.startisback.com/StartIsBackPlus_setup.exe" -O %DownloadDirectory%\startisbackplus.exe
    startisbackplus.exe
    pause
    goto configinstall
:sibpp
    wget.exe -nc --no-check-certificate "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe" -O %DownloadDirectory%\startisbackplusplus.exe
    startisbackplusplus.exe
    pause
    goto configinstall
:sab
    wget.exe -nc --no-check-certificate "https://startisback.sfo3.cdn.digitaloceanspaces.com/StartAllBack_3.6.4_setup.exe" -O %DownloadDirectory%\startallback.exe
    startallback.exe
    pause
    goto configinstall
:uxpatcher
    wget.exe -nc --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/appearance/UltraUXThemePatcher_4.4.0.exe"  -O %DownloadDirectory%\ultrauxthemepatcher.exe
    ultrauxthemepatcher.exe /S
    pause
    goto configinstall
:explorerpatcher
    wget.exe -nc --no-check-certificate "https://github.com/valinet/ExplorerPatcher/releases/download/22621.1555.55.1_a95a688/ep_setup.exe" -O %DownloadDirectory%\explorerpatcher.exe
    explorerpatcher.exe
    pause
    goto configinstall
:winaerotweaker
    wget.exe -nc --no-check-certificate "https://winaerotweaker.com/download/winaerotweaker.zip" -O %DownloadDirectory%\winaerotweaker.zip
    7za e winaerotweaker.zip -aoa > NUL
    WinaeroTweaker-1.52.0.0-setup.exe /SP- /VERYSILENT
    pause
    goto configinstall

:: --------------------
:: Game section
:: --------------------

:minecraft
    wget.exe -nc --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.exe" -O %DownloadDirectory%\mclauncher.exe
    mclauncher.exe
    pause
    goto gameinstall
:minecraft_legacy
    wget.exe -nc --no-check-certificate "https://launcher.mojang.com/download/MinecraftInstaller.msi" -O %DownloadDirectory%\legacymclauncher.msi
    legacymclauncher.msi /quiet /norestart
    pause
    goto gameinstall
:lunar
    wget.exe -nc --no-check-certificate "https://launcherupdates.lunarclientcdn.com/Lunar Client v2.15.1.exe" -O %DownloadDirectory%\lunarclient.exe
    lunarclient.exe /S
    pause
    goto gameinstall
:badlion
    wget.exe -nc --no-check-certificate "https://client-updates.badlion.net/Badlion Client Setup 3.15.1.exe" -O %DownloadDirectory%\badlionclient.exe
    badlionclient.exe /S
    pause
    goto gameinstall
:feather
    wget.exe -nc --no-check-certificate "https://launcher.feathercdn.net/dl/Feather Launcher Setup 1.5.5.exe" -O %DownloadDirectory%\featherclient.exe
    featherclient.exe /S
    pause
    goto gameinstall
:osu
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/769802700740362263/1110264771393106011/osuinstall.exe" -O %DownloadDirectory%\osu.exe
    osu.exe
    pause
    goto gameinstall
:osulazer
    wget.exe -nc --no-check-certificate "https://github.com/ppy/osu/releases/latest/download/install.exe" -O %DownloadDirectory%\osulazer.exe
    osulazer.exe
    pause
    goto gameinstall
:pinball
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/838495643063812146/1110189889200332860/3D-Pinball.exe" -O %DownloadDirectory%\pinball.exe
    pinball.exe /VERYSILENT /SUPRESSMSGBOXES /ALLUSERS /NORESTART /SP-
    pause
    goto gameinstall

:: --------------------
:: Gaming software section
:: --------------------

:steam
    wget.exe -nc --no-check-certificate "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe" -O %DownloadDirectory%\steam.exe
    steam.exe /S
    pause
    goto gaminginstall
:afterburner
    wget.exe -nc --no-check-certificate "https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465.zip" -O %DownloadDirectory%\msiafterburner.zip
	7za e msiafterburner.zip -aoa > NUL
    rd /S /Q Guru3D.com
    MSIAfterburnerSetup465.exe /S
    pause
    goto gaminginstall
:amd
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110577745915805808/amd-software-adrenalin-edition-23.4.3-minimalsetup-230427_web.exe" -O %DownloadDirectory%\amdsoftware.exe
    amdsoftware.exe /S
    pause
    goto gaminginstall
:nvidia
    wget.exe -nc --no-check-certificate "https://ru.download.nvidia.com/GFE/GFEClient/3.27.0.112/GeForce_Experience_v3.27.0.112.exe" -O %DownloadDirectory%\geforceexperience.exe
    geforceexperience.exe -y -gm2 -fm0
    pause
    goto gaminginstall
:cfos
    wget.exe -nc --no-check-certificate "https://www.cfos.de/cfosspeed-v1250.exe" -O %DownloadDirectory%\cfosspeed.exe
    cfosspeed.exe
    pause
    goto gaminginstall
:razer
    wget.exe -nc --no-check-certificate "https://dl.razerzone.com/drivers/GameBooster/RazerCortexInstaller.exe" -O %DownloadDirectory%\razercortex.exe
    razercortex.exe
    pause
    goto gaminginstall
:corsair
    wget.exe -nc --no-check-certificate "https://downloads.corsair.com/Files/CUE/iCUESetup_4.33.138_release.msi" -O %DownloadDirectory%\icue.msi
    icue.msi /quiet /norestart
    pause
    goto gaminginstall
:steelseries
    wget.exe -nc --no-check-certificate "https://engine.steelseriescdn.com/SteelSeriesGG37.0.0Setup.exe" -O %DownloadDirectory%\steelseriesgg.exe
    steelseriesgg.exe /S
    pause
    goto gaminginstall

:: --------------------
:: Creator application section
:: --------------------

:vscode
    if %osid% LEQ 2 goto vscode7
    wget.exe -nc --no-check-certificate "https://az764295.vo.msecnd.net/stable/252e5463d60e63238250799aef7375787f68b4ee/VSCodeSetup-x64-1.78.0.exe" -O %DownloadDirectory%\vscode.exe
    vscode.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto creatorinstall
:sublimetext
    wget.exe -nc --no-check-certificate "https://download.sublimetext.com/sublime_text_build_4143_x64_setup.exe" -O %DownloadDirectory%\sublimetext.exe
    sublimetext.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto creatorinstall
:notepadplusplus
    wget.exe -nc --no-check-certificate "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.3/npp.8.5.3.Installer.x64.exe" -O %DownloadDirectory%\notepadplusplus.exe
    notepadplusplus.exe /S
    pause
    goto creatorinstall
:pythonver3
    if %osid% LEQ 2 goto python7ver3
    wget.exe -nc --no-check-certificate "https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe" -O %DownloadDirectory%\pythonver3.exe
    pythonver3.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    pause
    goto creatorinstall
:pythonver2
    wget.exe -nc --no-check-certificate "https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi" -O %DownloadDirectory%\pythonver2.msi
    pythonver2.msi /quiet /norestart
    pause
    goto creatorinstall
:git
    wget.exe -nc --no-check-certificate "https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/Git-2.40.1-64-bit.exe" -O %DownloadDirectory%\git.exe
    git.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto creatorinstall
:github
    wget.exe -nc --no-check-certificate "https://central.github.com/deployments/desktop/desktop/latest/win32" -O %DownloadDirectory%\github.exe
    github.exe
    pause
    goto creatorinstall
:zealdocs
    wget.exe -nc --no-check-certificate "https://github.com/zealdocs/zeal/releases/download/v0.6.1/zeal-0.6.1-windows-x64.msi" -O %DownloadDirectory%\zealdocs.msi
    zealdocs.msi /quiet /norestart
    pause
    goto creatorinstall
:audacity
    wget.exe -nc --no-check-certificate "https://github.com/audacity/audacity/releases/download/Audacity-3.3.2/audacity-win-3.3.2-x64.exe" -O %DownloadDirectory%\audacity.exe
    audacity.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto creatorinstall
:krita
    wget.exe -nc --no-check-certificate "https://download.kde.org/stable/krita/5.1.5/krita-x64-5.1.5-setup.exe" -O %DownloadDirectory%\krita.exe
    krita.exe /S
    pause
    goto creatorinstall
:paintdotnet
    wget.exe -nc --no-check-certificate "https://github.com/paintdotnet/release/releases/download/v5.0.5/paint.net.5.0.5.winmsi.x64.zip" -O %DownloadDirectory%\paintdotnet.zip
	7za e paintdotnet.zip -aoa > NUL
    paint.net.5.0.5.winmsi.x64.msi /quiet /norestart ALLUSERS=1
    pause
    goto creatorinstall
:obsstudio
    if %osid% LEQ 3 goto obs78
    wget.exe -nc --no-check-certificate "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-29.1-Full-Installer-x64.exe" -O %DownloadDirectory%\obsstudio.exe
    obsstudio.exe /S
    pause
    goto creatorinstall
:flstudio
    wget.exe -nc --no-check-certificate "https://support.image-line.com/redirect/flstudio_win_installer" -O %DownloadDirectory%\flstudio.exe
    flstudio.exe /S
    pause
    goto creatorinstall
:formatfactory
    wget.exe -nc --no-check-certificate "https://sdl.adaware.com/?bundleid=FF001&savename=FF001.exe" -O %DownloadDirectory%\FF001.exe
    FF001.exe /S
    pause
    goto creatorinstall
:winscp
    wget.exe -nc --no-check-certificate "https://deac-riga.dl.sourceforge.net/project/winscp/WinSCP/6.1/WinSCP-6.1.msi" -O %DownloadDirectory%\winscp.msi
    winscp.msi /quiet /norestart
    pause
    goto creatorinstall
:putty
    wget.exe -nc --no-check-certificate "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-0.78-installer.msi" -O %DownloadDirectory%\putty.msi
    putty.msi /quiet /norestart
    pause
    goto creatorinstall

:: --------------------
:: Web application section
:: --------------------

:chromestable
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727769497611/ChromeStable.exe" -O %DownloadDirectory%\chromestable.exe
    chromestable.exe
    pause
    goto webappsinstall
:chromebeta
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222727404601364/ChromeBeta.exe" -O %DownloadDirectory%\chromebeta.exe
    chromebeta.exe
    pause
    goto webappsinstall
:chromedev
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728566423773/ChromeDev.exe" -O %DownloadDirectory%\chromedev.exe
    chromedev.exe
    pause
    goto webappsinstall
:chromecanary
   if %osid% LEQ 3 echo Your OS is not supported and there is no older version available & pause & goto webappsinstall
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1110222728222486598/ChromeCanary.exe" -O %DownloadDirectory%\chromecanary.exe
    chromecanary.exe
    pause
    goto webappsinstall
:edgestable
    wget.exe -nc --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100" -O %DownloadDirectory%\edgestable.exe
    edgestable.exe
    pause
    goto webappsinstall
:edgebeta
    wget.exe -nc --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Beta&language=en" -O %DownloadDirectory%\edgebeta.exe
    edgebeta.exe
    pause
    goto webappsinstall
:edgedev
    wget.exe -nc --no-check-certificate "https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Dev&language=en" -O %DownloadDirectory%\edgedev.exe
    edgedev.exe
    pause
    goto webappsinstall
:edgecanary
    wget.exe -nc --no-check-certificate "https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Canary&language=en&brand=M100" -O %DownloadDirectory%\edgecanary.exe
    edgecanary.exe
    pause
    goto webappsinstall
:firefoxstable
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112105341071360/Firefox_Installer.exe" -O %DownloadDirectory%\firefoxstable.exe
    firefoxstable.exe
    pause
    goto webappsinstall
:firefoxbeta
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112429443338400/Firefox_Setup_114.0b9_2.exe" -O %DownloadDirectory%\firefoxbeta.exe
    firefoxbeta.exe
    pause
    goto webappsinstall
:firefoxdevedition
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104955183125/Firefox_Installer_2.exe" -O %DownloadDirectory%\firefoxdevedition.exe
    firefoxdevedition.exe
    pause
    goto webappsinstall
:firefoxnightly
    wget.exe -nc --no-check-certificate "https://cdn.discordapp.com/attachments/1088474021923917944/1112112104099565789/Firefox_Installer.en-US.exe" -O %DownloadDirectory%\firefoxnightly.exe
    firefoxnightly.exe
    pause
    goto webappsinstall
:discordstable
    wget.exe -nc --no-check-certificate "https://dl.discordapp.net/distro/app/stable/win/x86/1.0.9013/DiscordSetup.exe" -O %DownloadDirectory%\discordstable.exe
    discordstable.exe
    pause
    goto webappsinstall
:discordbeta
    wget.exe -nc --no-check-certificate "https://dl-ptb.discordapp.net/distro/app/ptb/win/x86/1.0.1027/DiscordPTBSetup.exe" -O %DownloadDirectory%\discordbeta.exe
    discordbeta.exe
    pause
    goto webappsinstall
:discordcanary
    wget.exe -nc --no-check-certificate "https://dl-canary.discordapp.net/distro/app/canary/win/x86/1.0.60/DiscordCanarySetup.exe" -O %DownloadDirectory%\discordcanary.exe
    discordcanary.exe
    pause
    goto webappsinstall
:spotify
    if %osid% LEQ 3 goto spotify78
    wget.exe -nc --no-check-certificate "https://download.scdn.co/SpotifySetup.exe" -O %DownloadDirectory%\spotify.exe
    wget.exe "https://cdn.discordapp.com/attachments/769802700740362263/1110235115675729930/NSudoLC.exe" -O %DownloadDirectory%\nsudo.exe
    nsudo.exe -U:C -Wait "spotify.exe"
    pause
    goto webappsinstall
:itunes
    wget.exe -nc --no-check-certificate "https://secure-appldnld.apple.com/itunes12/001-80042-20210422-E8A351F2-A3B2-11EB-9A8F-CF1B67FC6302/iTunesSetup.exe" -O %DownloadDirectory%\itunes.exe
    itunes.exe
    pause
    goto webappsinstall
:telegram
    wget.exe -nc --no-check-certificate "https://updates.tdesktop.com/tx64/tsetup-x64.4.8.1.exe" -O %DownloadDirectory%\telegram.exe
    telegram.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto webappsinstall

:: --------------------
:: Basic software section
:: --------------------

:7zip
    wget.exe -nc --no-check-certificate "https://www.7-zip.org/a/7z2201-x64.msi" -O %DownloadDirectory%\7zip.msi
    7zip.msi /quiet
    pause
    goto softwareinstall
:processhacker
    wget.exe -nc --no-check-certificate "https://deac-fra.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe" -O %DownloadDirectory%\processhacker.exe
    processhacker.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:vlc
    wget.exe -nc --no-check-certificate "https://mirrors.neterra.net/vlc/vlc/3.0.18/win64/vlc-3.0.18-win64.msi" -O %DownloadDirectory%\vlc.msi
    vlc.msi /quiet
    pause
    goto softwareinstall
:mpchc
    wget.exe -nc --no-check-certificate "https://github.com/clsid2/mpc-hc/releases/download/2.0.0/MPC-HC.2.0.0.x64.exe" -O %DownloadDirectory%\mpc-hc.exe
    mpc-hc.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:qbit
    wget.exe -nc --no-check-certificate "https://deac-ams.dl.sourceforge.net/project/qbittorrent/qbittorrent-win32/qbittorrent-4.5.2/qbittorrent_4.5.2_x64_setup.exe" -O %DownloadDirectory%\qbit.exe
    qbit.exe /S
    pause
    goto softwareinstall
:unlocker
    wget.exe -nc --no-check-certificate "https://dl.freesoftru.net/apps/47/466/46534/Unlocker-1.9.2-x64.msi" -O %DownloadDirectory%\unlocker.msi
    unlocker.msi /quiet /norestart
    pause
    goto softwareinstall
:pcmanager
    if %osid% LEQ 3 echo Your operating system is completely unsupported by this program. & pause & goto softwareinstall
    wget.exe -nc --no-check-certificate "https://aka.ms/PCManager10000" -O %DownloadDirectory%\pcmanager.exe
    pcmanager.exe /S
    pause
    goto softwareinstall
:picasa
    wget.exe -nc --no-check-certificate "https://web.archive.org/web/20150601071855if_/https://dl.google.com/picasa/picasa39-setup.exe" -O %DownloadDirectory%\googlepicasa.exe
    googlepicasa.exe /S
    pause
    goto softwareinstall
:hwinfo
    wget.exe -nc --no-check-certificate "https://www.sac.sk/download/utildiag/hwi_746.exe" -O %DownloadDirectory%\hwinfo.exe
    hwinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:crystaldiskinfo
    wget.exe -nc --no-check-certificate "https://ftp.halifax.rwth-aachen.de/osdn/crystaldiskinfo/78192/CrystalDiskInfo8_17_14.exe" -O %DownloadDirectory%\crystaldiskinfo.exe
    crystaldiskinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:easybcd
    wget.exe -nc --no-check-certificate "https://files03.tchspt.com/temp/EasyBCD2.4.exe" -O %DownloadDirectory%\EasyBCD 2.4.exe
    "EasyBCD 2.4.exe" /S
    pause
    goto softwareinstall
:flux
    wget.exe -nc --no-check-certificate "https://justgetflux.com/flux-setup.exe" -O %DownloadDirectory%\flux.exe
    flux.exe /S
    pause
    goto softwareinstall
:minibin
    wget.exe -nc --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/appearance/minibin.zip" -O %DownloadDirectory%\minibin.zip
	7za e minibin.zip -aoa > NUL
    MiniBin-6.6.0.0-Setup.exe /S
    pause
    goto softwareinstall
:unchecky
    wget.exe -nc --no-check-certificate "https://unchecky.com/files/upload/unchecky_setup.exe" -O %DownloadDirectory%\unchecky.exe
    unchecky.exe -install
    pause
    goto softwareinstall
:wiztree
    wget.exe -nc --no-check-certificate "https://antibodysoftware-17031.kxcdn.com/files/20230315/wiztree_4_13_setup.exe" -O %DownloadDirectory%\wiztree.exe
    wiztree.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:wizfile
    wget.exe -nc --no-check-certificate "https://antibodysoftware-17031.kxcdn.com/files/wizfile_3_09_setup.exe" -O %DownloadDirectory%\wizfile.exe
    wizfile.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:ueli
    wget.exe -nc --no-check-certificate "https://github.com/oliverschwendener/ueli/releases/download/v8.24.0/ueli-Setup-8.24.0.exe" -O %DownloadDirectory%\ueli.exe
    ueli.exe /S
    pause
    goto softwareinstall
:caesium
    if %osid% EQU 3 goto caesium8
	if %osid% LEQ 2 goto caesium7
    wget.exe -nc --no-check-certificate "https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.4.0/caesium-image-compressor-2.4.0-win-setup.exe" -O %DownloadDirectory%\caesium.exe
    caesium.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:mzcpuaccelerator
    wget.exe -nc --no-check-certificate "https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/processor/mzcpu.exe" -O %DownloadDirectory%\mzcpuaccelerator.exe
    mzcpuaccelerator.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:winlaunch
    wget.exe -nc --no-check-certificate "https://nav.dl.sourceforge.net/project/winlaunch/WinLaunchInstaller.exe" -O %DownloadDirectory%\winlaunch.exe
    winlaunch.exe
    pause
    goto softwareinstall
:fences
    wget.exe -nc --no-check-certificate "https://cdn.stardock.us/downloads/public/software/fences/Fences4-sd-setup.exe" -O %DownloadDirectory%\fences.exe
    fences.exe /S /NOINIT /W
    pause
    goto softwareinstall
:groupy
    wget.exe -nc --no-check-certificate "https://cdn.stardock.us/downloads/public/software/groupy/Groupy_setup.exe" -O %DownloadDirectory%\groupy.exe
    groupy.exe /S /NOINIT /W
    pause
    goto softwareinstall
:memreduct
    wget.exe -nc --no-check-certificate "https://github.com/henrypp/memreduct/releases/download/v.3.4/memreduct-3.4-setup.exe" -O %DownloadDirectory%\memreduct.exe
    memreduct.exe /S
    pause
    goto softwareinstall
:bcuninstaller
    wget.exe -nc --no-check-certificate "https://github.com/Klocman/Bulk-Crap-Uninstaller/releases/download/v5.6/BCUninstaller_5.6_setup.exe" -O %DownloadDirectory%\bcuninstaller.exe
    bcuninstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto softwareinstall
:optimizer
    wget.exe -nc --no-check-certificate "https://github.com/hellzerg/optimizer/releases/download/15.3/Optimizer-15.3.exe" -O %userprofile%\Desktop\Optimizer.exe
    pause
    goto softwareinstall

:: --------------------
:: Legacy installers 
:: --------------------

:obs78
    wget.exe -nc --no-check-certificate "https://github.com/obsproject/obs-studio/releases/download/27.2.4/OBS-Studio-27.2.4-Full-Installer-x64.exe" -O %DownloadDirectory%\obsstudio_legacy.exe
    obsstudio_legacy.exe /S
    pause
    goto creatorinstall
:caesium8
    wget.exe -nc --no-check-certificate "https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.3.0/caesium-image-compressor-2.3.0-win-setup.exe" -O %DownloadDirectory%\caesium-legacy.exe
    caesium-legacy.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    goto softwareinstall
:caesium7
    wget.exe -nc --no-check-certificate "https://kumisystems.dl.sourceforge.net/project/caesium/1.7.0/caesium-1.7.0-win.exe" -O %DownloadDirectory%\caesium-legacy7.exe
    caesium-legacy7.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    goto softwareinstall
:spotify78
    wget.exe -nc --no-check-certificate "https://download.scdn.co/SpotifyFull7-8-8.1.exe" -O %DownloadDirectory%\spotify.exe
    wget.exe "https://cdn.discordapp.com/attachments/769802700740362263/1110235115675729930/NSudoLC.exe" -O %DownloadDirectory%\nsudo.exe
    nsudo.exe -U:C -Wait "spotify.exe"
    goto webappsinstall
:vscode7
    wget.exe -nc --no-check-certificate "https://az764295.vo.msecnd.net/stable/e4503b30fc78200f846c62cf8091b76ff5547662/VSCodeSetup-x64-1.70.2.exe" -O %DownloadDirectory%\vscode-legacy.exe
    vscode-legacy.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    pause
    goto creatorinstall
:python7ver3
    wget.exe -nc --no-check-certificate "https://www.python.org/ftp/python/3.8.10/python-3.8.10-amd64.exe" -O %DownloadDirectory%\python_legacy.exe
    python_legacy.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    pause
    goto creatorinstall
