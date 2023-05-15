@echo off

:: Admin permission checker (Admin required)
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
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

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:start
@echo off & cls & mode con: cols=120 lines=40
setlocal enableDelayedExpansion
title GX_ Pack - Pre-release (0.9.00)
md %temp%\gx-pack-downloads
set DownloadDirectory=%temp%\gx-pack-downloads
set "GXPackVersion=v0.9.00 (Pre-release)"

REM CPU Architecture checker (x86 isn't supported)
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OSArchitecture=x86 || set OSArchitecture=x64
if "%OSArchitecture%"=="x86" echo    Warning. Your OS architecture is unsupported by most of the software included in this program pack. & pause & exit

REM Windows version checker
FOR /F "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuildNumber"') do set Build=%%b
if /I "%Build%" GEQ "21996" (
    set OperatingSystem=11
    goto start11
) else (
    set OperatingSystem=10
    goto start108
)
if "%v%" == "6.3" (
    set "OperatingSystem=8.1" 
    goto start108
)
if "%v%" == "6.2" (
    set "OperatingSystem=8" 
    goto start108
)
if "%v%" == "6.1" (
    set "OperatingSystem=7" & echo Most of the programs aren't supported by your OS. Also, for the script to work, please, install Windows Management Framework 3 to get Powershell 3. You've been warned. 
    pause 
    goto start7
)

:start7
REM windows 7 icon is back bitches
cls
echo.
echo.
echo.
echo             ,.=:!!t3Z3z.,
echo          :tt:::tt333EE3
echo         Et:::ztt33EEEL${c2} @Ee.,      ..,
echo        ;tt:::tt333EE7${c2} ;EEEEEEttttt33#
echo       :Et:::zt333EEQ.${c2} $EEEEEttttt33QL          GX_ Pack (W%OperatingSystem% %OSArchitecture%)
echo       it::::tt333EEF${c2} @EEEEEEttttt33F           %GXPackVersion%
echo      ;3=*^```"*4EEV${c2} :EEEEEEttttt33@.
echo      ,.=::::!t=., ${c1}`${c2} @EEEEEEtt
echo     ;::::::::zt33)${c2}   "4EEEtttji3P*
echo    :t::::::::tt33.${c4}:Z3z..${c2}  ``
echo    i::::::::zt33F${c4} AEEEtttt::::ztF
echo   ;:::::::::t33V${c4} ;EEEttttt::::t3
echo   E::::::::zt33L${c4} @EEEtttt::::z3F                Choose options
echo   {3=*^```"*4E3)${c4} ;EEEtttt:::::tZ`              below.
echo               `${c4} :EEEEtttt::::z7
echo                    "VEzjt:;;z>*`
echo.
echo.
echo    1. Install basic software.
echo    2. Install web applications
echo    3. Install creator applications.
echo    4. Install gaming software.
echo    5. Install configurations
echo    6. Install runtimes, needed by a bunch of software
echo.
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if '%choice%'=='1' goto softwareinstall
if '%choice%'=='2' goto webappsinstall
if '%choice%'=='3' goto creatorinstall
if '%choice%'=='4' goto gaminginstall
if '%choice%'=='5' goto configinstall
if '%choice%'=='6' goto runtimeinstall
if '%choice%'=='0' goto scriptexit
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto start

:start108
REM ugly icon, blehhhh :face_vomiting:
cls
echo.
echo.
echo.
echo                          ....,,:;+ccllll
echo            ...,,+:;  cllllllllllllllllll
echo      ,cclllllllllll  lllllllllllllllllll            GX_ Pack (W%OperatingSystem% %OSArchitecture%)
echo      llllllllllllll  lllllllllllllllllll            %GXPackVersion%
echo      llllllllllllll  lllllllllllllllllll
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
echo    1. Install basic software.
echo    2. Install web applications
echo    3. Install creator applications.
echo    4. Install gaming software.
echo    5. Install configurations
echo    6. Install runtimes, needed by a bunch of software
echo.
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if '%choice%'=='1' goto softwareinstall
if '%choice%'=='2' goto webappsinstall
if '%choice%'=='3' goto creatorinstall
if '%choice%'=='4' goto gaminginstall
if '%choice%'=='5' goto configinstall
if '%choice%'=='6' goto runtimeinstall
if '%choice%'=='0' goto scriptexit
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto start

:start11
REM this icon is too basic imo, blehhhh milly
cls
echo.
echo.
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll            GX_ Pack (W%OperatingSystem% (%BuildNumber%) %OSArchitecture%)
echo    lllllllllllllll   lllllllllllllll            %GXPackVersion%
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo.                                 
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll            Choose options
echo    lllllllllllllll   lllllllllllllll            below.
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo    lllllllllllllll   lllllllllllllll
echo.
echo.
echo    1. Install basic software.
echo    2. Install web applications
echo    3. Install creator applications.
echo    4. Install gaming software.
echo    5. Install configurations
echo    6. Install runtimes, needed by a bunch of software
echo.
echo    0. Exit.
echo.
set /p choice=...Enter your choice:  
if '%choice%'=='1' goto softwareinstall
if '%choice%'=='2' goto webappsinstall
if '%choice%'=='3' goto creatorinstall
if '%choice%'=='4' goto gaminginstall
if '%choice%'=='5' goto configinstall
if '%choice%'=='6' goto runtimeinstall
if '%choice%'=='0' goto scriptexit
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto start

:scriptexit
rd /S /Q %DownloadDirectory%
exit

:softwareinstall
REM i hate stardock for making paid programs, fuck you stardock
@echo off & cls & mode con: cols=120 lines=40
echo.
echo.
echo    Select the options to install.
echo.
echo    1. 7-zip (archive manager)
echo    2. Process Hacker (advanced task manager)
echo    3. VLC (media player)
echo    4. MPC-HC (light-weight media player)
echo    5. qBitTorrent (bittorrent client)
echo    6. Unlocker
echo    7. Microsoft PC Manager
echo    8. Google Picasa 3 (photo viewer)
echo    9. HWiNFO (hardware information)
echo    10. CrystalDiskInfo (disk info)
echo    11. EasyBCD (bootmanager settings)
echo    12. Lightbulb (eye saver (auto night mode))
echo    13. MiniBin (bin in taskbar)
echo    14. Unchecky (anti-adware/opencandy in installers)
echo    15. WizTree (a better WinDirStat)
echo    16. WizFile (extremely fast file search tool)
echo    17. Ueli (spotlight feature from macos)
echo    18. Caesium (photo compressor)
echo    19. Mz CPU Accelerator (auto high-priority on focused program)
echo    20. Winlaunch
echo    21. Fences (desktop grouping) (paid software)
echo    22. Groupy (window grouping) (paid software)
echo    23. Mem Reduct (RAM optimization)
echo.
echo.
echo    0. Go back
echo.
echo.
set choice=
set /p choice=Enter your choice:  
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7z2201-x64.msi -OutFile %DownloadDirectory%\7zip.msi"
    echo Installing...
    call %DownloadDirectory%\7zip.msi /quiet
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://deac-fra.dl.sourceforge.net/project/processhacker/processhacker2/processhacker-2.39-setup.exe -OutFile %DownloadDirectory%\processhacker.exe"
    echo Installing...
    call %DownloadDirectory%\processhacker.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://mirror.truenetwork.ru/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe -OutFile %DownloadDirectory%\vlc.exe"
    echo Installing...
    call %DownloadDirectory%\vlc.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/clsid2/mpc-hc/releases/download/2.0.0/MPC-HC.2.0.0.x64.exe -OutFile %DownloadDirectory%\mpc-hc.exe"
    echo Installing...
    call %DownloadDirectory%\mpc-hc.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.fosshub.com/qBittorrent.html?dwl=qbittorrent_4.5.2_lt20_qt6_x64_setup.exe -OutFile %DownloadDirectory%\qbit.exe"
    echo Installing...
    call %DownloadDirectory%\qbit.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.freesoftru.net/apps/47/466/46534/Unlocker-1.9.2-x64.msi -OutFile %DownloadDirectory%\unlocker.msi"
    echo Installing...
    call %DownloadDirectory%\unlocker.msi /quiet /norestart
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='7' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://pcmdistributestorage.blob.core.windows.net/mvp/500000/25868/MSPCManagerSetup.exe?sv=2021-10-04&st=2022-12-23T09%3A44%3A31Z&se=2023-06-24T09%3A44%3A00Z&r=b&sp=r&sig=PW0SDnPoP5p68oeRrzahyxnZWzsjASoK9oU3VT%2FSPAk%3D -OutFile %DownloadDirectory%\pcmanager.exe"
    echo Installing...
    call %DownloadDirectory%\pcmanager.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='8' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://doc-0s-4g-docs.googleusercontent.com/docs/securesc/6n12r06o1rq2al5aaaj0u2fb5mq22uf2/hltldi8j6s2il3cp0mn9j1uqedqavubs/1683690675000/10056446428593003974/01720687202643652632/0B1BV0eKo8L91Z01iTXhyWHJzV3c?e=download&ax=ADWCPKC51L3mTbIBB8noLCsLOG-maRojEaWKE2ny4NpTnfWJLU5Kw-0XU3nUmeS1MCocUy9--t1nMQdmzMYPXDM3Jj-9iTsEglicty-qHH3FYm3A0J2NSGzjEFrLZkrWmokhGizzFaeiYtAavQSys6K8IO89_VmdJsrae8PneLcRVOXf8e8oeLtCsdVJ9Dl-5k4SMJIYypJtImtSDj9baKvFigq2zwm3zNRnXljYoScspdwJi_b-KC2cT_O1G_4IQ9Ql4ifgtWaN-DdpjHGrKF3NhTEUVt_gswoId6g0htjv9QX9rsiLHrYeGDEvUvqfGOmEEETwIQwtAa8j__sbsxMf7O1gDj6l39PR9oXLWYasTj2GSc24Kfi7UnJSPKso1BauO48kX19aiWnYQviWcq_fUalrUErcjSAsD6Z4bCtTIq-A63Nkr3DHTbQTck1df5I0ZTPDfk6K9ienCpRzpbmdEzrnaqZ8Okm6y6jJf3E_u01pWQNNyGlRrubveh9wcvuKW-O1qWWVdBDsAwfM5Ql89s6HBtxlkOPaerSSYTp2vRoshEkn_oabOkbnKT5tvO94nKKVIoh4kcp1b5VpOdj1CHCqrcs3QRygsGmPxxdIbhOEjxXCUzsItBr4ikS416qJdIOKGGWwnhzzFTx3Q5t3reb1Qiz_phsk5vtYfIr3U-OpfMq1-bHnSlEDS6NaKV2q2FkOEF9mwrj24JUSWoC7KNNPycWc7TYOYswdbZmbA3Ma_4EWsCQtReyKsgosiP-Cnkmjq-cv9T347XPXt_0-prcTT9qDHsBq620INf7zAUODsi5kKch_ZoV9BRgBUPq7mRyygf2s98-lFEUE_lwJbaOaWsL-qKe5YvCKXWIOx1ueXKa_NxM&uuid=31443cd2-9fcb-486d-b17c-5ac2802b439e&authuser=0&resourcekey=0-Qf-Qb7pTkYytj0YeucwBQA&nonce=plggfbmnonncc&user=01720687202643652632&hash=gcho3f00lq05tp6c7nrvrm5fq83m9atc -OutFile %DownloadDirectory%\googlepicasa.exe"
    echo Installing...
    call %DownloadDirectory%\googlepicasa.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='9' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.fosshub.com/HWiNFO.html?dwl=hwi_744.exe -OutFile %DownloadDirectory%\hwinfo.exe"
    echo Installing...
    call %DownloadDirectory%\hwinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='10' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://ftp.halifax.rwth-aachen.de/osdn/crystaldiskinfo/78192/CrystalDiskInfo8_17_14.exe -OutFile %DownloadDirectory%\crystaldiskinfo.exe"
    echo Installing...
    call %DownloadDirectory%\crystaldiskinfo.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='11' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://cfcdn.neosmart.net/software/EasyBCD/community/EasyBCD%202.4.exe?response-content-disposition=attachment%3B%20filename%3D%22EasyBCD%202.4.exe%22&response-cache-control=max-age%3D1209600&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZmNkbi5uZW9zbWFydC5uZXQvc29mdHdhcmUvRWFzeUJDRC9jb21tdW5pdHkvRWFzeUJDRCUyMDIuNC5leGU~cmVzcG9uc2UtY29udGVudC1kaXNwb3NpdGlvbj1hdHRhY2htZW50JTNCJTIwZmlsZW5hbWUlM0QlMjJFYXN5QkNEJTIwMi40LmV4ZSUyMlx1MDAyNnJlc3BvbnNlLWNhY2hlLWNvbnRyb2w9bWF4LWFnZSUzRDEyMDk2MDAiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2ODM2OTQ3NDR9fX1dfQ__&Signature=k-Afkvtl1y3sHCZ0ChfXTyoXLOWPnleowGZHtlwgoPIfn9a2P2XgB688nLR~ni3-i8ScOJxOzJojF-ReekOPE2FC1X9FCGJrTy9Aojak7UIAeSAOwi3EW5v5mxofRQMHrDd3SOKKur6ChY94~qcm~OArOtA8P0KYoVdy4HH9uaX46WblEgTAuAI2cgKBjmowwHWvVdJ-zmt-YouWyYarXhyCezCUl4Br9z4G24bGlRUeDSk5puaH83Be-MNzraLcDXEYKoOUfN0Y6j-8wNGBBzEJvVwycbO0SRhj9HjPbLJ1Qzg6LpukdA3B8bKO2cBj9vgY9sZ65adD~zIf-P~mRA__&Key-Pair-Id=APKAIPY5GEV5EHVOFFNQ -OutFile %DownloadDirectory%\easybcd.exe"
    echo Installing...
    call %DownloadDirectory%\easybcd.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='12' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/Tyrrrz/LightBulb/releases/download/2.4.5/LightBulb-Installer.exe -OutFile %DownloadDirectory%\lightbulb.exe"
    echo Installing...
    call %DownloadDirectory%\lightbulb.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='13' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/appearance/minibin.zip -OutFile %DownloadDirectory%\minibin.zip"
    echo Extracting...
    powershell -Command "& {Expand-Archive -Path '%DownloadDirectory%\minibin.zip' -DestinationPath '%DownloadDirectory%\'}"
    echo Installing...
    call %DownloadDirectory%\MiniBin-6.6.0.0-Setup.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='14' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://unchecky.com/files/upload/unchecky_setup.exe -OutFile %DownloadDirectory%\unchecky.exe"
    echo Installing...
    call %DownloadDirectory%\unchecky.exe -install
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='15' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://antibodysoftware-17031.kxcdn.com/files/20230315/wiztree_4_13_setup.exe -OutFile %DownloadDirectory%\wiztree.exe"
    echo Installing...
    call %DownloadDirectory%\wiztree.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='16' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://antibodysoftware-17031.kxcdn.com/files/wizfile_3_09_setup.exe -OutFile %DownloadDirectory%\wizfile.exe"
    echo Installing...
    call %DownloadDirectory%\wizfile.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='17' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/oliverschwendener/ueli/releases/download/v8.24.0/ueli-Setup-8.24.0.exe -OutFile %DownloadDirectory%\ueli.exe"
    echo Installing...
    call %DownloadDirectory%\ueli.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='18' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/Lymphatus/caesium-image-compressor/releases/download/v2.4.0/caesium-image-compressor-2.4.0-win-setup.exe -OutFile %DownloadDirectory%\caesium.exe"
    echo Installing...
    call %DownloadDirectory%\caesium.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='19' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/processor/mzcpu.exe -OutFile %DownloadDirectory%\mzcpuaccelerator.exe"
    echo Installing...
    call %DownloadDirectory%\mzcpuaccelerator.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='20' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://nav.dl.sourceforge.net/project/winlaunch/WinLaunchInstaller.exe -OutFile %DownloadDirectory%\winlaunch.exe"
    echo Installing...
    call %DownloadDirectory%\winlaunch.exe
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='21' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://cdn.stardock.us/downloads/public/software/fences/Fences4-sd-setup.exe -OutFile %DownloadDirectory%\fences.exe"
    echo Installing...
    call %DownloadDirectory%\fences.exe /S /NOINIT /W
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='22' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://cdn.stardock.us/downloads/public/software/groupy/Groupy_setup.exe -OutFile %DownloadDirectory%\groupy.exe"
    echo Installing...
    call %DownloadDirectory%\groupy.exe /S /NOINIT /W
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='23' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/henrypp/memreduct/releases/download/v.3.4/memreduct-3.4-setup.exe -OutFile %DownloadDirectory%\memreduct.exe"
    echo Installing...
    call %DownloadDirectory%\memreduct.exe /S
    echo Done.
    cd ..
    goto softwareinstall
)
if '%choice%'=='0' goto start
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto softwareinstall

:webappsinstall
@echo off & cls
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
echo    6. Microsoft Edge (Beta) (updates every 4 weeks)
echo    7. Microsoft Edge (Dev) (weekly updates)
echo    8. Microsoft Edge (Canary) (daily updates)
echo    9. Firefox (Stable)
echo    10. Firefox (Beta)
echo    11. Firefox (Developer Edition)
echo    12. Firefox (Nightly)
echo.
echo    Other:
echo    13. Discord (Stable)
echo    14. Discord (Public beta testing (PTB))
echo    15. Discord (Canary)
echo    16. Spotify
echo    17. Telegram Desktop
echo.
echo.
echo.
echo    0. Go back
echo.
set choice=
set /p choice=...Enter your choice:  
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B9DECE4F3-A2EE-2AB6-1CFB-8AC250C2B02D%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi -OutFile %DownloadDirectory%\chromestable.msi"
    echo Installing...
    call %DownloadDirectory%\chromestable.msi
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.google.com/tag/s/appguid%3D%7B8237E44A-0054-442C-B6B6-EA0509993955%7D%26iid%3D%7B9DECE4F3-A2EE-2AB6-1CFB-8AC250C2B02D%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%2520Beta%26needsadmin%3Dtrue%26ap%3D-arch_x64-statsdef_0%26brand%3DGCEA/dl/chrome/install/beta/googlechromebetastandaloneenterprise64.msi -OutFile %DownloadDirectory%\chromebeta.msi"
    echo Installing...
    call %DownloadDirectory%\chromebeta.msi
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.google.com/tag/s/appguid%3D%7B401C381F-E0DE-4B85-8BD8-3F3F14FBDA57%7D%26iid%3D%7BDCE95566-C8E2-9476-344F-117DE525674E%7D%26lang%3Dru%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Dev%26needsadmin%3Dprefers%26ap%3D-arch_x64-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe -OutFile %DownloadDirectory%\chromedev.exe"
    echo Installing...
    call %DownloadDirectory%\chromedev.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.google.com/tag/s/appguid%3D%7B4EA16AC7-FD5A-47C3-875B-DBF4A2008C20%7D%26iid%3D%7BAEF8A15D-B074-4ED9-973A-F768455A4353%7D%26lang%3Dru%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%2520Canary%26needsadmin%3Dfalse%26ap%3Dx64-canary-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe -OutFile %DownloadDirectory%\chromecanary.exe"
    echo Installing...
    call %DownloadDirectory%\chromecanary.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100 -OutFile %DownloadDirectory%\edgestable.exe"
    echo Installing...
    call %DownloadDirectory%\edgestable.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Beta&language=en -OutFile %DownloadDirectory%\edgebeta.exe"
    echo Installing...
    call %DownloadDirectory%\edgebeta.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='7' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://c2rsetup.edog.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeInsiderPage&Channel=Dev&language=en -OutFile %DownloadDirectory%\edgedev.exe"
    echo Installing...
    call %DownloadDirectory%\edgedev.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='8' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://c2rsetup.officeapps.live.com/c2r/downloadEdge.aspx?platform=Default&source=EdgeStablePage&Channel=Stable&language=en&brand=M100 -OutFile %DownloadDirectory%\edgecanary.exe"
    echo Installing...
    call %DownloadDirectory%\edgecanary.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='9' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-stub&os=win&lang=ru&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmZXhwZXJpbWVudD0obm90IHNldCkmdmFyaWF0aW9uPShub3Qgc2V0KSZ1YT1maXJlZm94JmNsaWVudF9pZD0obm90IHNldCkmc2Vzc2lvbl9pZD0obm90IHNldCkmZGxzb3VyY2U9bW96b3Jn&attribution_sig=b2f5dc1c8fc3f2e0d7f7d42f846bd0100addc8be47dcd49b026416a468f4b487 -OutFile %DownloadDirectory%\firefoxstable.exe"
    echo Installing...
    call %DownloadDirectory%\firefoxstable.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='10' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-beta-latest-ssl&os=win64&lang=ru&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmZXhwZXJpbWVudD0obm90IHNldCkmdmFyaWF0aW9uPShub3Qgc2V0KSZ1YT1maXJlZm94JmNsaWVudF9pZD0obm90IHNldCkmc2Vzc2lvbl9pZD0obm90IHNldCkmZGxzb3VyY2U9bW96b3Jn&attribution_sig=b2f5dc1c8fc3f2e0d7f7d42f846bd0100addc8be47dcd49b026416a468f4b487 -OutFile %DownloadDirectory%\firefoxbeta.exe"
    echo Installing...
    call %DownloadDirectory%\firefoxbeta.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='11' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-devedition-stub&os=win&lang=ru&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmZXhwZXJpbWVudD0obm90IHNldCkmdmFyaWF0aW9uPShub3Qgc2V0KSZ1YT1maXJlZm94JmNsaWVudF9pZD0obm90IHNldCkmc2Vzc2lvbl9pZD0obm90IHNldCkmZGxzb3VyY2U9bW96b3Jn&attribution_sig=b2f5dc1c8fc3f2e0d7f7d42f846bd0100addc8be47dcd49b026416a468f4b487 -OutFile %DownloadDirectory%\firefoxdevedition.exe"
    echo Installing...
    call %DownloadDirectory%\firefoxdevedition.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='12' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.mozilla.org/?product=firefox-nightly-stub&os=win&lang=ru&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmZXhwZXJpbWVudD0obm90IHNldCkmdmFyaWF0aW9uPShub3Qgc2V0KSZ1YT1maXJlZm94JmNsaWVudF9pZD0obm90IHNldCkmc2Vzc2lvbl9pZD0obm90IHNldCkmZGxzb3VyY2U9bW96b3Jn&attribution_sig=b2f5dc1c8fc3f2e0d7f7d42f846bd0100addc8be47dcd49b026416a468f4b487 -OutFile %DownloadDirectory%\firefoxnightly.exe"
    echo Installing...
    call %DownloadDirectory%\firefoxnightly.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='13' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.discordapp.net/distro/app/stable/win/x86/1.0.9013/DiscordSetup.exe -OutFile %DownloadDirectory%\discordstable.exe"
    echo Installing...
    call %DownloadDirectory%\discordstable.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='14' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl-ptb.discordapp.net/distro/app/ptb/win/x86/1.0.1027/DiscordPTBSetup.exe -OutFile %DownloadDirectory%\discordpublicbetatest.exe"
    echo Installing...
    call %DownloadDirectory%\discordpublicbetatest.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='15' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl-canary.discordapp.net/distro/app/canary/win/x86/1.0.60/DiscordCanarySetup.exe -OutFile %DownloadDirectory%\discordcanary.exe"
    echo Installing...
    call %DownloadDirectory%\discordcanary.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='16' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.scdn.co/SpotifySetup.exe -OutFile %DownloadDirectory%\spotify.exe"
    echo Installing...
    call %DownloadDirectory%\spotify.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='17' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://updates.tdesktop.com/tx64/tsetup-x64.4.8.1.exe -OutFile %DownloadDirectory%\telegramdesktop.exe"
    echo Installing...
    call %DownloadDirectory%\telegramdesktop.exe
    echo Done.
    cd ..
    goto webappsinstall
)
if '%choice%'=='0' goto start
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto webappsinstall

:creatorinstall
@echo off
echo.
echo.
echo.
echo    Programming:
echo    1. VSCode (text/code editor)
echo    2. Sublime Text (text/code editor)
echo    3. Notepad++ (enhanced notepad)
echo    4. Python (programming language)
echo    5. Git (distributed version control system)
echo    6. Github Desktop (self-explanatory)
echo    7. Zealdocs (programming textbook)
echo.
echo    Creativity:
echo    8. Audacity (audio recording/editing)
echo    9. Krita (painting)
echo    10. Paint.net (heavy picture editor)
echo    11. OBS Studio (recording)
echo    12. FL Studio (a DAW)
echo.
echo    Other:
echo    13. Format Factory (file converter)
echo.
echo.
echo.
echo    0. Go back
echo.
set choice=
set /p choice=...Enter your choice:  
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://az764295.vo.msecnd.net/stable/252e5463d60e63238250799aef7375787f68b4ee/VSCodeSetup-x64-1.78.0.exe -OutFile %DownloadDirectory%\vscode.exe"
    echo Installing...
    call %DownloadDirectory%\vscode.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.sublimetext.com/sublime_text_build_4143_x64_setup.exe -OutFile %DownloadDirectory%\sublimetext.exe"
    echo Installing...
    call %DownloadDirectory%\sublimetext.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://objects.githubusercontent.com/github-production-release-asset-2e65be/33014811/327bcb75-6b3d-40f0-a5f6-b5a4bb3916db?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230505%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230505T160453Z&X-Amz-Expires=300&X-Amz-Signature=35152c7bc9786236d7dc70777c1f9198a9e2ee65bbf7652caa5620ea76977806&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=33014811&response-content-disposition=attachment%3B%20filename%3Dnpp.8.5.2.Installer.x64.exe&response-content-type=application%2Foctet-stream -OutFile %DownloadDirectory%\notepadplusplus.exe"
    echo Installing...
    call %DownloadDirectory%\notepadplusplus.exe /S
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/3.11.3/python-3.11.3-amd64.exe -OutFile %DownloadDirectory%\python.exe"
    echo Installing...
    call %DownloadDirectory%\python.exe /quiet /norestart InstallAllUsers=1 PrependPath=1 Include_test=1 Include_pip=1 AssociateFiles=1 Shortcuts=0 Include_launcher=1
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://objects.githubusercontent.com/github-production-release-asset-2e65be/23216272/38665515-bd90-4fd3-b7ce-5b4491f7a662?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230505%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230505T160443Z&X-Amz-Expires=300&X-Amz-Signature=e4fe524cfa708471ef18d00505952784b13e2fa1889b5006aedc41cca5e65867&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=23216272&response-content-disposition=attachment%3B%20filename%3DGit-2.40.1-64-bit.exe&response-content-type=application%2Foctet-stream -OutFile %DownloadDirectory%\git.exe"
    echo Installing...
    call %DownloadDirectory%\git.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://objects.githubusercontent.com/github-production-release-asset-2e65be/7711472/2b7be500-cc2b-11e8-9b4d-14cbe92235e4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230505%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230505T160504Z&X-Amz-Expires=300&X-Amz-Signature=dc2eb2e550c52f332f393949fb63bd4600dddf2a7cc2da5bdd5f2066a420c21c&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=7711472&response-content-disposition=attachment%3B%20filename%3Dzeal-0.6.1-windows-x64.msi&response-content-type=application%2Foctet-stream -OutFile %DownloadDirectory%\githubdesktop.exe"
    echo Installing...
    call %DownloadDirectory%\githubdesktop.exe
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='7' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://objects.githubusercontent.com/github-production-release-asset-2e65be/7711472/2b7be500-cc2b-11e8-9b4d-14cbe92235e4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230505%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230505T160504Z&X-Amz-Expires=300&X-Amz-Signature=dc2eb2e550c52f332f393949fb63bd4600dddf2a7cc2da5bdd5f2066a420c21c&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=7711472&response-content-disposition=attachment%3B%20filename%3Dzeal-0.6.1-windows-x64.msi&response-content-type=application%2Foctet-stream -OutFile %DownloadDirectory%\zealdocs.msi"
    echo Installing...
    call %DownloadDirectory%\zealdocs.msi /quiet /norestart
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='8' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://objects.githubusercontent.com/github-production-release-asset-2e65be/32921736/c240245a-7be1-4a1b-887f-44f2a8a47b1d?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20230505%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230505T161950Z&X-Amz-Expires=300&X-Amz-Signature=82259f9286aa8e292c01f0520e41ddadeaae64838c7938f85ae1b22199e427bd&X-Amz-SignedHeaders=host&actor_id=132670526&key_id=0&repo_id=32921736&response-content-disposition=attachment%3B%20filename%3Daudacity-win-3.3.1-x64.exe&response-content-type=application%2Foctet-stream -OutFile %DownloadDirectory%\audacity.exe"
    echo Installing...
    call %DownloadDirectory%\audacity.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='9' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://mirror.truenetwork.ru/kde/stable/krita/5.1.5/krita-x64-5.1.5-setup.exe -OutFile %DownloadDirectory%\krita.exe"
    echo Installing...
    call %DownloadDirectory%\krita.exe /S
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='10' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/paintdotnet/release/releases/download/v5.0.3/paint.net.5.0.3.winmsi.x64.zip -OutFile %DownloadDirectory%\paintdotnet.zip"
    echo Extracting...
    powershell -Command "& {Expand-Archive -Path '%DownloadDirectory%\paintdotnet.zip' -DestinationPath '%DownloadDirectory%\'}"
    echo Installing...
    call %DownloadDirectory%\paint.net.5.0.3.winmsi.x64.msi /quiet /norestart ALLUSERS=1
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='11' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://cdn-fastly.obsproject.com/downloads/OBS-Studio-29.1-Full-Installer-x64.exe -OutFile %DownloadDirectory%\obsstudio.exe"
    echo Installing...
    call %DownloadDirectory%\obsstudio.exe /S
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='12' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://demodownload.image-line.com/flstudio/flstudio_win64_21.0.3.3517.exe -OutFile %DownloadDirectory%\flstudio.exe"
    echo Installing...
    call %DownloadDirectory%\flstudio.exe /S
    echo Done.
    pause
    cd ..
    goto creatorinstall
)  
if '%choice%'=='13' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://sdl.adaware.com/?bundleid=FF001&savename=FF001.exe -OutFile %DownloadDirectory%\formatfactory.exe"
    echo Installing...
    call %DownloadDirectory%\formatfactory.exe /S
    echo Done.
    pause
    cd ..
    goto creatorinstall
)
if '%choice%'=='0' goto start
ECHO "%choice%" is not a valid choice. Please try again. & pause & goto creatorinstall

:gaminginstall
@echo off & cls
mode con: cols=120 lines=40
echo.
echo.
echo.
echo Select the options to install.
echo.
echo 1. Steam (online game distribution service)
echo 2. MSI Afterburner (graphics card utility, bundled with RTSS and DirectX)
echo 3. AMD Adrenalin Software
echo 4. GeForce Experience
echo 5. cFosSpeed (internet speed accelerator)
echo 6. Razer Cortex (game accelerator)
echo 0. Go back
echo.
set choice=
set /p choice=...Enter your choice: 
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe -OutFile %DownloadDirectory%\steam.exe"
    echo Installing...
    call %DownloadDirectory%\steamsetup.exe /S
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://ftp.nluug.nl/pub/games/PC/guru3d/afterburner/[Guru3D.com]-MSIAfterburnerSetup465.zip -OutFile %DownloadDirectory%\msiafterburner.zip"
    echo Extracting...
    powershell -Command "& {Expand-Archive -Path '%DownloadDirectory%\msiafterburner.zip' -DestinationPath '%DownloadDirectory%\'}"
    rd /S /Q Guru3D.com
    echo Installing...
    call %DownloadDirectory%\MSIAfterburnerSetup465.exe /S
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://drivers.amd.com/drivers/installer/22.40/whql/amd-software-adrenalin-edition-23.4.3-minimalsetup-230427_web.exe -OutFile %DownloadDirectory%\amdsoftware.exe"
    echo Installing...
    call %DownloadDirectory%\amdsoftware.exe /S
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://ru.download.nvidia.com/GFE/GFEClient/3.27.0.112/GeForce_Experience_v3.27.0.112.exe -OutFile %DownloadDirectory%\geforceexperience.exe"
    echo Installing...
    call %DownloadDirectory%\geforceexperience.exe -y -gm2 -fm0
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.cfos.de/cfosspeed-v1250.exe -OutFile %DownloadDirectory%\cfosspeed.exe"
    echo Installing...
    call %DownloadDirectory%\cfosspeed.exe
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.razerzone.com/drivers/GameBooster/RazerCortexInstaller.exe -OutFile %DownloadDirectory%\razercortex.exe"
    echo Installing...
    call %DownloadDirectory%\razercortex.exe
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='7' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://downloads.corsair.com/Files/CUE/iCUESetup_4.33.138_release.msi -OutFile %DownloadDirectory%\icue.msi"
    echo Installing...
    call %DownloadDirectory%\icue.msi /quiet /norestart
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='8' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://engine.steelseriescdn.com/SteelSeriesGG37.0.0Setup.exe -OutFile %DownloadDirectory%\steelseriesgg.exe"
    echo Installing...
    call %DownloadDirectory%\steelseriesgg.exe /S
    echo Done.
    pause
    cd ..
    goto gaminginstall
)
if '%choice%'=='0' goto start
if errorlevel 1 echo "%choice%" is not a valid choice. Please try again. & pause & goto gaminginstall




:configinstall
@echo off & cls & title Setting up configs...
echo.
echo.
echo   Select the configurations to install.
echo.
echo   1. Install StartIsBack (W8)
echo   2. Install StartIsBack+ (W8.1)
echo   3. Install StartIsBack++ (W10)
echo   4. Install StartAllBack (W11)
echo   5. Install UltraUXThemePatcher
echo   6. Install ExplorerPatcher
echo.
echo.
echo    0. Go back
echo.
set choice=
set /p choice=...Enter your choice:  
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.startisback.com/StartIsBack_setup.exe -OutFile %DownloadDirectory%\startisback.exe"
    echo Installing...
    call %DownloadDirectory%\startisback.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://www.startisback.com/StartIsBackPlus_setup.exe -OutFile %DownloadDirectory%\startisbackplus.exe"
    echo Installing...
    call %DownloadDirectory%\startisbackplus.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://startisback.sfo3.cdn.digitaloceanspaces.com/StartIsBackPlusPlus_setup.exe -OutFile %DownloadDirectory%\startisbackplusplus.exe"
    echo Installing...
    call %DownloadDirectory%\startisbackplusplus.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://startisback.sfo3.cdn.digitaloceanspaces.com/StartAllBack_3.6.4_setup.exe -OutFile %DownloadDirectory%\startallback.exe"
    echo Installing...
    call %DownloadDirectory%\startallback.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://1acjcg.securedfile.ru/b6/1/3/eda0e117638de0bf22f3daa4c44e62a0/UltraUXThemePatcher_4.3.4.exe  -OutFile %DownloadDirectory%\ultrauxthemepatcher.exe"
    echo Installing...
    call %DownloadDirectory%\ultrauxthemepatcher.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/valinet/ExplorerPatcher/releases/download/22621.1555.55.1_a95a688/ep_setup.exe -OutFile %DownloadDirectory%\explorerpatcher.exe"
    echo Installing...
    call %DownloadDirectory%\explorerpatcher.exe
    echo Done.
    pause
    cd ..
    goto configinstall
)
if '%choice%'=='0' goto start
if errorlevel 1 echo "%choice%" is not a valid choice. Please try again. & pause & goto configinstall

:runtimeinstall
@echo off & cls & title Installing Runtimes...
echo.
echo.
echo    Select the runtime to install.
echo.
echo    1. Java 20 (JRE) (Adoptium Temurin)
echo    2. Java 20 (JDK) (Adoptium Temurin)
echo    3. .NET 7 (SDK)
echo    4. .NET 6 (SDK)
echo    5. Edge WebView2
echo    6. .NET Framework 4.8.1
echo    7. .NET Framework 4.8
echo    8. .NET Framework 4.7.2
echo    9. .NET Framework 4.5.2
echo    10. VCRedist 2005-2022 (All in one)
echo.
echo.
echo    0. Go back
echo.
set choice=
set /p choice=...Enter your choice:  
if '%choice%'=='1' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jre_x64_windows_hotspot_20.0.1_9.msi -OutFile %DownloadDirectory%\jre20.msi"
    echo Installing...
    call %DownloadDirectory%\jre20.msi /quiet /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='2' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.1%2B9/OpenJDK20U-jdk_x64_windows_hotspot_20.0.1_9.msi -OutFile %DownloadDirectory%\jdk20.msi"
    echo Installing...
    call %DownloadDirectory%\jdk20.msi /quiet /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='3' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/89a2923a-18df-4dce-b069-51e687b04a53/9db4348b561703e622de7f03b1f11e93/dotnet-sdk-7.0.203-win-x64.exe -OutFile %DownloadDirectory%\net7sdk.exe"
    echo Installing...
    call %DownloadDirectory%\net7sdk.exe
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='4' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/df42b901-8ce2-4131-941a-b3fa094ff3d8/556da65f7a2f6164bf3df932e030898a/dotnet-sdk-6.0.408-win-x64.exe -OutFile %DownloadDirectory%\net6sdk.exe"
    echo Installing...
    call %DownloadDirectory%\net6sdk.exe
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='5' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/27fe7ec2-abd4-43d3-a8ff-c89209e107e6/MicrosoftEdgeWebView2RuntimeInstallerX64.exe -OutFile %DownloadDirectory%\edgewebview2.exe"
    echo Installing...
    call %DownloadDirectory%\edgewebview2.exe
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='6' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe -OutFile %DownloadDirectory%\netframework4.8.1.exe"
    echo Installing...
    call %DownloadDirectory%\netframework4.8.1.exe /q /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='7' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe -OutFile %DownloadDirectory%\netframework4.8.exe"
    echo Installing...
    call %DownloadDirectory%\netframework4.8.exe /q /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='8' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe -OutFile %DownloadDirectory%\netframework4.7.2.exe"
    echo Installing...
    call %DownloadDirectory%\netframework4.7.2.exe /q /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='9' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe -OutFile %DownloadDirectory%\netframework4.5.2.exe"
    echo Installing...
    call %DownloadDirectory%\netframework4.5.2.exe /q /norestart
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='10' (
    echo Downloading...
    powershell -Command "Invoke-WebRequest https://dl.comss.org/download/Visual-C-Runtimes-All-in-One-Feb-2023.zip -OutFile %DownloadDirectory%\vcredistaio.zip"
    echo Extracting...
    powershell -Command "& {Expand-Archive -Path '%DownloadDirectory%\vcredistaio.zip' -DestinationPath '%DownloadDirectory%\'}"
    echo Installing...
    call %DownloadDirectory%\install_all.bat
    echo Done.
    pause
    cd ..
    goto runtimeinstall
)
if '%choice%'=='0' goto start
if errorlevel 1 echo "%choice%" is not a valid choice. Please try again. & pause & goto runtimeinstall