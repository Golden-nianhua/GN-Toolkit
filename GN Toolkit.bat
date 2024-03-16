::GN Toolkit ԭ�񹤾��� By Golden_nianhua https://space.bilibili.com/307409565
@echo off
cd /d %~dp0
chcp 936 >nul
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS

set "bat_version=1.0.0"
set "parameter_0=%~1"
if not "%~1"=="::" (
    set "parameter_0="
    set "parameters=::"
) else goto :saveParm_2
:saveParm
if not "%~1"=="" (
    set "parameters=!parameters! %~1"
    shift /1
    goto :saveParm
)
:saveParm_2
%parameter_0% mshta vbscript:createobject("shell.application").shellexecute("%~f0","%parameters%","","runas",1)(window.close)& exit

:loadParm
if not "%~2"=="" (
    set "parameter=%~2"
    if "!parameter:~,2!"=="--" (
        set "parameter_option=!parameter:~2!"
        set "parameter_value="
        goto :loadParm_2
    )
    shift /2
    goto :loadParm
)
goto :winv
:loadParm_2
shift /2
if "%~2"=="" goto :loadParm_3
set "parameter=%~2"
if not "%parameter:~,2%"=="--" (
    set "parameter_value=!parameter_value! !parameter!"
    goto :loadParm_2
)
goto :loadParm_3
:loadParm_3
if defined parameter_value set "parameter_value=%parameter_value:~1%"
call :loadParm_%parameter_option% "%parameter_value%"
goto :loadParm
:loadParm_option
set "option=%~1"
goto :eof
:loadParm_goto
goto :%parameter_value%
goto :eof
:loadParm_call
call :%parameter_value%
goto :eof
:loadParm_config
set "config_name=%~1"
goto :eof

:winv
ver |findstr "6\.1\.7601" >nul && set "winv=7 SP1"
ver |findstr "6\.2\.[0-9]*" >nul && set "winv=8"
ver |findstr "6\.3\.[0-9]*" >nul && set "winv=8.1"
ver |findstr "10\.0\.1[0-9]*\.[0-9]*" >nul && set "winv=10"
ver |findstr "10\.0\.2[0-9]*\.[0-9]*" >nul && set "winv=11"
if "%winv%"=="" echo ����֧�ֵ�ϵͳ�汾���밴������ر�& pause >nul & exit


:st
call :setVar
if not defined config_name set "config_name=GN Toolkit.ini"
if not exist "%config_name%" call :createGNTConfig
call :formatConfig "%config_name%"
call :loadConfig "%config_name%"
call :formatPath "bat_cache_path"
call :formatPath "bat_lib_path"
call :formatPath "bat_data_path"

set "title=%bat_name%-ԭ�񹤾���[v%bat_version%] By Golden_nianhua"

cls & call :info & title %title%

if exist "%bat_cache_path%backtrack" (
    call :select10 "backtrack" "��һ�ν����жϣ��Ƿ����"
)
if "%backtrack%"=="1" (    
    for /f "usebackq skip=1 delims=*" %%a in ("%bat_cache_path%backtrack") do set "%%a"
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%backtrack") do %%a
)

call :delCache

title %title% �������������
call :lib

:checkVC
set "vc_runtimes_version="
for /f "tokens=2* skip=2" %%a in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\VisualStudio\14.0\VC\Runtimes\X64" /v "Version"') do set "vc_runtimes_version=%%b"
if "%vc_runtimes_version%"=="" call :installVC & goto :checkVC

if not defined bat_game_install_path goto :modifyGamePath

:menu
cls & call :info & title %title%
call :select "menu" "==���˵�" "������Ϸ" "�������" "С����" "��������-��δ����" "����"
if %menu%==1 goto :menu_1
if %menu%==2 goto :menu_2
if %menu%==3 goto :menu_3
if %menu%==4 goto :menu_4
if %menu%==5 goto :menu_5
goto :eof

:menu_1
cls & call :info & title %title%
call :select "menu_1" "������Ϸ" "�ٷ�" "B��" "���ʷ�" "���⴦��" "������ݷ�ʽ"
if %menu_1%==1 
if %menu_1%==2 
if %menu_1%==3 
if %menu_1%==4 set "srun=1"& goto :menu_1
if %menu_1%==5 set "crun=1"& goto :menu_1
:menu_1_
::�����˺�
cls & call :info & title %title%
call :select "menu_1_" "ѡ���˺�" "����" �б�
goto :eof

:menu_2
call :getGameVersion
call :getDiskInfo
cls & call :info & title %title%
call :select "menu_2" "�������" "��װ" "����" "Ԥ����" "����������"
if %menu_2%==1 (
    set "title=%title% ��װ"
    if not %game_client_version%==null goto :installGame_3
)
if %menu_2%==2 (
    set "title=%title% ����"
    if %game_client_version%==null goto :updateGame_3
    if %game_client_version%==%game_latest_version% goto :updateGame_4
    for /f %%a in ('jq ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.version" "%bat_cache_path%resource.json"') do set "outdated=1"
    if not defined outdated goto :updateGame_5
)
if %menu_2%==3 (
    if %game_pre_version%==null goto :preDownloadGame_4
    set "title=%title% Ԥ����"
)
if %menu_2%==4 set "title=%title% ����������" & goto :createSwitchPkg
cls & call :info & title %title%
call :select "menu_2_" "ѡ������" "�ٷ�" "B��" "���ʷ�"
set "path_name=%path_name_cn%"
if %menu_2_%==1 set "title=%title%-�ٷ�" & set "channel=1" & set "sub_channel=1"
if %menu_2_%==2 set "title=%title%-B��" & set "channel=14" & set "sub_channel=0"
if %menu_2_%==3 set "title=%title%-���ʷ�" & set "path_name=%path_name_global%" & set "channel=1" & set "sub_channel=1"
cls & call :info & title %title%
call :selectLang "menu_2__" "ѡ������"
if not %menu_2___skip%==1 set "title=%title%-"
if %menu_2___zh-cn%==1 set "title=%title%����"
if %menu_2___ja-jp%==1 set "title=%title%����"
if %menu_2___en-us%==1 set "title=%title%Ӣ��"
if %menu_2___ko-kr%==1 set "title=%title%����"
cls & call :info & title %title%
if %menu_2%==1 goto :installGame
if %menu_2%==2 goto :updateGame
if %menu_2%==3 goto :preDownloadGame
goto :eof

:menu_3
cls & call :info & title %title%
call :select "menu_3" "==С����" "һ���޸�" "����У����Դ������" "��ȡ����������ͼ"
goto :eof

:menu_4
goto :menu
cls & call :info & title %title%
call :select "menu_4" "��������" "31-4302�����쳣" "B����¼�����쳣" "��uid:xxx-time:xxx-auid...��xxxException:xxx" "Error at hooking API ^"NtProtectVirtualMemory^"" "������ַ��������"
goto :eof

:menu_5
cls & call :info & title %title%
call :select "menu_5" "==����==" "�޸���Ϸ��װĿ¼" "У������" "�˺����" "��������" "�޸���Ϸ���ڴ�С" 
if %menu_5%==1 goto :modifyGamePath
if %menu_5%==2 goto :correctChannel
if %menu_5%==4 goto :modifySpeedLimit
if %menu_5%==5 goto :modifyResolution
goto :eof


:installGame
::��ȡresource
if not %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_cn%" || goto :installGame )
if %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_1%" ||(
        curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_2%" || goto :installGame )
)
::��ȡ��Ϸ��С
if "%debug_replace_resource%"=="1" echo resource.json�滻�ϵ�& pause
set "game_total_size=0"
set "game_total_package_size=0"
for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.latest|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___zh-cn%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.latest.voice_packs[]|select(.language==\"zh-cn\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___ja-jp%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.latest.voice_packs[]|select(.language==\"ja-jp\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___en-us%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.latest.voice_packs[]|select(.language==\"en-us\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___ko-kr%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.latest.voice_packs[]|select(.language==\"ko-kr\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
for /f %%a in ('jq -n "%game_total_size%"') do set "game_total_size=%%a"
for /f %%a in ('jq -n "%game_total_package_size%"') do set "game_total_package_size=%%a"
for /f %%a in ('jq -n "%game_total_size%/1073741824*100+0.5|floor/100"') do set "game_total_size_display=%%a"
for /f %%a in ('jq -n "%game_total_package_size%/1073741824*100+0.5|floor/100"') do set "game_total_package_size_display=%%a"
::B��sdk���ƻ�ȡ
if %menu_2_%==2 for /f "delims=*" %%a in ('jq -r ".data.sdk.path|split(\"/\")[-1]" "%bat_cache_path%resource.json"') do set "sdk_name=%%a"
cls & call :info & title %title%
call :select "menu_2___" "����ģʽ" "ѹ���� %game_total_size_display% GB" "�ļ� %game_total_package_size_display% GB"
if %menu_2___%==1 set "title=%title%-ѹ����" & goto :installGameZip
if %menu_2___%==2 set "title=%title%-�ļ�" & goto :installGameFile
goto :eof
:installGameZip
cls & call :info & title %title%
::����ѹ�����嵥
set "local_installGameZip_voice=!path_name_voice_pack:{version}=%game_latest_version%!"
(
if %menu_2___zh-cn%==1 jq -c ".data.game.latest.voice_packs[]|select(.language==\"zh-cn\")|{remoteName:\"!local_installGameZip_voice:{lang}=%path_zh-cn%!\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ja-jp%==1 jq -c ".data.game.latest.voice_packs[]|select(.language==\"ja-jp\")|{remoteName:\"!local_installGameZip_voice:{lang}=%path_ja-jp%!\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___en-us%==1 jq -c ".data.game.latest.voice_packs[]|select(.language==\"en-us\")|{remoteName:\"!local_installGameZip_voice:{lang}=%path_en-us%!\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ko-kr%==1 jq -c ".data.game.latest.voice_packs[]|select(.language==\"ko-kr\")|{remoteName:\"!local_installGameZip_voice:{lang}=%path_ko-kr%!\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2_%==2 jq -c ".data.sdk|{remoteName:\"%sdk_name%\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
)>"%bat_cache_path%fileinfo.txt"
::�־�ѹ������
for /f "delims=*" %%a in ('jq ".data.game.latest.segments|length" "%bat_cache_path%resource.json"') do set "installGameZip_segmemts=%%a"
if %installGameZip_segmemts%==0 goto :installGameZip_2
(
for /l %%a in (1,1,%installGameZip_segmemts%) do (
    if %%a LSS 10 (
        jq -c ".data.game.latest.segments[%%a-1]|{remoteName:\"%path_name%_%game_latest_version%.zip.00%%a\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
    ) else if %%a LSS 100 (
        jq -c ".data.game.latest.segments[%%a-1]|{remoteName:\"%path_name%_%game_latest_version%.zip.0%%a\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
    ) else (
        jq -c ".data.game.latest.segments[%%a-1]|{remoteName:\"%path_name%_%game_latest_version%.zip.%%a\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
    )
)
)>>"%bat_cache_path%fileinfo.txt"
goto :installGameZip_3
:installGameZip_2
(
    jq -c ".data.game.latest|{remoteName:\"%path_name%_%game_latest_version%.zip\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
)>>"%bat_cache_path%fileinfo.txt"
:installGameZip_3
::���������嵥
jq -r ".path" "%bat_cache_path%fileinfo.txt" >"%bat_cache_path%filedl.txt"
call :backtrack "1"
:backtrack_1
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
:installGameZip_4
::У��ѹ����
call :backtrack "2"
:backtrack_2
cls & call :info & title %title%
title %title% ѹ����У����
call :verify "%bat_cache_path%fileinfo.txt"
call :backtrack "3"
:backtrack_3
cls & call :info & title %title%
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
::��ѹ������������
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    call :select10 "redownload" "����ѹ����У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :installGameZip_5
) else goto :installGameZip_5
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do jq -r "select(.remoteName==\"%%a\")|.path" "%bat_cache_path%fileinfo.txt"
)>"%bat_cache_path%filedl.txt"
call :backtrack "4"
:backtrack_4
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
goto :installGameZip_4
:installGameZip_5
::��ѹѹ����
call :backtrack "5"
:backtrack_5
cls & call :info & title %title%
title %title% ��ѹ��
cd /d "%bat_game_install_path%"
::filern.txt��verify������,,,
for /f "delims=*" %%a in ('jq -R -r "select(endswith(\"zip\") or endswith(\"001\"))" "%bat_cache_path%\filern.txt"') do (
    7z x "%%a" -aoa
)
if not "%debug_not_del_zip%"=="1" for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%filern.txt"') do del /q "%%a" 2>nul
cd /d %~dp0
:installGameZip_6
::�ļ�У��
call :backtrack "6"
:backtrack_6
cls & call :info & title %title%
title %title% �ļ�У����
copy /y "%bat_game_install_path%pkg_version" "%bat_cache_path%pkg"
if %menu_2___zh-cn%==1 if exist "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ja-jp%==1 if exist "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___en-us%==1 if exist "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ko-kr%==1 if exist "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" "%bat_cache_path%pkg"
call :verify "%bat_cache_path%pkg"
::sdkУ��
set "sdk_corrupted=0"
if %menu_2_%==2 (
    for /f "tokens=1*" %%a in ('jq -r -j ".md5,\" \",.remoteName" "%bat_game_install_path%sdk_pkg_version"') do (
        if not exist "%bat_game_install_path%%%b" (
            set "sdk_corrupted=1"
        ) else for /f "delims=*" %%a in ('md5deep -A %%a "%bat_game_install_path%%%b" 2^>nul') do set "sdk_corrupted=1"
    )
)
call :backtrack "7"
:backtrack_7
cls & call :info & title %title%
set "md5check=0"
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
if %sdk_corrupted%==1 set /a "md5check+=1"
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    if %sdk_corrupted%==1 jq -r ".remoteName" "%bat_game_install_path%sdk_pkg_version"
    call :select10 "redownload" "�����ļ�У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :installGame_2
) else goto :installGame_2
for /f "delims=*" %%a in ('jq -r ".data.game.latest.decompressed_path" "%bat_cache_path%resource.json"') do set "url_decompressed_path=%%a/"
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do (
    echo %url_decompressed_path%%%a
    echo  out=%%a
)
)>"%bat_cache_path%filedl.txt"
if %sdk_corrupted%==1 jq -r ".data.sdk.path" "%bat_cache_path%resource.json" >>"%bat_cache_path%filedl.txt"
call :backtrack "8"
:backtrack_8
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
if %sdk_corrupted%==1 (
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
goto :installGameZip_6
goto :eof
::�ļ�����
:installGameFile
cls & call :info & title %title%
for /f "delims=*" %%a in ('jq -r ".data.game.latest.decompressed_path" "%bat_cache_path%resource.json"') do set "url_decompressed_path=%%a/"
(
echo %url_decompressed_path%pkg_version
del /q "%bat_game_install_path%pkg_version" 2>nul
if %menu_2___zh-cn%==1 (
    echo %url_decompressed_path%Audio_%path_zh-cn%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" 2>nul
)
if %menu_2___ja-jp%==1 (
    echo %url_decompressed_path%Audio_%path_ja-jp%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" 2>nul
)
if %menu_2___en-us%==1 (
    echo %url_decompressed_path%Audio_%path_en-us%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" 2>nul
)
if %menu_2___ko-kr%==1 (
    echo %url_decompressed_path%Audio_%path_ko-kr%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" 2>nul
)
)>"%bat_cache_path%filedl.txt"
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c false -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --remove-control-file true --allow-overwrite true --auto-file-renaming false
copy /y "%bat_game_install_path%pkg_version" "%bat_cache_path%pkg"
if %menu_2___zh-cn%==1 if exist "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ja-jp%==1 if exist "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___en-us%==1 if exist "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ko-kr%==1 if exist "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" "%bat_cache_path%pkg"
jq -r -j "\"%url_decompressed_path%\",.remoteName,\"\n\",\" out=\",.remoteName,\"\n\"" "%bat_cache_path%pkg" >"%bat_cache_path%filedl.txt"
if %menu_2_%==2 jq -r ".data.sdk.path" "%bat_cache_path%resource.json" >>"%bat_cache_path%filedl.txt"
call :backtrack "9"
:backtrack_9
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
if %menu_2_%==2 (   
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
:installGameFile_2
::�ļ�У��
call :backtrack "10"
:backtrack_10
cls & call :info & title %title%
title %title% �ļ�У����
copy /y "%bat_game_install_path%pkg_version" "%bat_cache_path%pkg"
if %menu_2___zh-cn%==1 if exist "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ja-jp%==1 if exist "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___en-us%==1 if exist "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ko-kr%==1 if exist "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" "%bat_cache_path%pkg"
call :verify "%bat_cache_path%pkg"
::sdkУ��
set "sdk_corrupted=0"
if %menu_2_%==2 (
    for /f "tokens=1*" %%a in ('jq -r -j ".md5,\" \",.remoteName" "%bat_game_install_path%sdk_pkg_version"') do (
        if not exist "%bat_game_install_path%%%b" (
            set "sdk_corrupted=1"
        ) else for /f "delims=*" %%a in ('md5deep -A %%a "%bat_game_install_path%%%b" 2^>nul') do set "sdk_corrupted=1"
    )
)
call :backtrack "11"
:backtrack_11
cls & call :info & title %title%
set "md5check=0"
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
if %sdk_corrupted%==1 set /a "md5check+=1"
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    if %sdk_corrupted%==1 jq -r ".remoteName" "%bat_game_install_path%sdk_pkg_version"
    call :select10 "redownload" "�����ļ�У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :installGame_2
) else goto :installGame_2
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do (
    echo %url_decompressed_path%%%a
    echo  out=%%a
)
)>"%bat_cache_path%filedl.txt"
if %sdk_corrupted%==1 jq -r ".data.sdk.path" "%bat_cache_path%resource.json" >>"%bat_cache_path%filedl.txt"
call :backtrack "12"
:backtrack_12
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
if %sdk_corrupted%==1 (
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
goto :installGameFile_2
goto :eof
:installGame_2
::����
(
echo [General]
echo game_version=%game_latest_version%
if %menu_2_%==2 echo plugin_sdk_version=%sdk_latest_version%
echo channel=%channel%
echo sub_channel=%sub_channel%
)>"%bat_game_install_path%config.ini"
call :writeConfig "%config_name%" "bat" "current_channel" "%menu_2_%"
cls & call :info & title %title%
title %title% ��װ���
call :delCache
echo ��Ϸ��װ�ɹ�
if %menu_2_%==1 ( echo �������ٷ�) else if %menu_2_%==2 ( echo ������B��) else echo ���������ʷ�
echo �汾��%game_latest_version%
echo �밴������˳��ű�...
pause >nul
goto :eof
:installGame_3
cls & call :info & title %title%
echo ��Ϸ�����ظ���װ���밴������˳��ű�...
pause >nul
goto :eof


:updateGame
::��ȡresource
if not %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_cn%" || goto :updateGame )
if %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_1%" ||(
        curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_2%" || goto :updateGame )
)
if "%debug_replace_resource%"=="1" echo resource.json�滻�ϵ�& pause
::��ȡ��Ϸ��С
set "game_total_size=0"
set "game_total_package_size=0"
for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___zh-cn%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"zh-cn\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___ja-jp%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ja-jp\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___en-us%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"en-us\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
if %menu_2___ko-kr%==1 for /f "tokens=1,2" %%a in ('jq -r -j ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ko-kr\")|.size,\" \",.package_size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" & set "game_total_package_size=%game_total_package_size%+%%b" )
for /f %%a in ('jq -n "%game_total_size%"') do set "game_total_size=%%a"
for /f %%a in ('jq -n "%game_total_package_size%"') do set "game_total_package_size=%%a"
for /f %%a in ('jq -n "%game_total_size%/1073741824*100+0.5|floor/100"') do set "game_total_size_display=%%a"
for /f %%a in ('jq -n "%game_total_package_size%/1073741824*100+0.5|floor/100"') do set "game_total_package_size_display=%%a"
::B��sdk���ƻ�ȡ
if %menu_2_%==2 (
    call :compareVersion "%game_sdk_version%" "%sdk_latest_version%" "sdk_outdated"
    for /f "delims=*" %%a in ('jq -r ".data.sdk.path|split(\"/\")[-1]" "%bat_cache_path%resource.json"') do set "sdk_name=%%a"
)
cls & call :info & title %title%
call :select "menu_2___" "����ģʽ" "ѹ���� %game_total_size_display% GB" "�ļ� %game_total_package_size_display% GB"
if %menu_2___%==1 set "title=%title%-ѹ����" & goto :updateGameZip
if %menu_2___%==2 set "title=%title%-�ļ�" & goto :updateGameFile
goto :eof
:updateGameZip
cls & call :info & title %title%
::����ѹ�����嵥
(
if %menu_2___zh-cn%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"zh-cn\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ja-jp%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ja-jp\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___en-us%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"en-us\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ko-kr%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ko-kr\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %sdk_outdated%==-1 jq -c ".data.sdk|{remoteName:\"%sdk_name%\",path:.path,md5:.md5}" "%bat_cache_path%resource.json"
jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
)>"%bat_cache_path%fileinfo.txt"
::���������嵥
jq -r ".path" "%bat_cache_path%fileinfo.txt" >"%bat_cache_path%filedl.txt"
call :backtrack "13"
:backtrack_13
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
:updateGameZip_2
::У��ѹ����
call :backtrack "14"
:backtrack_14
cls & call :info & title %title%
title %title% ѹ����У����
call :verify "%bat_cache_path%fileinfo.txt"
call :backtrack "15"
:backtrack_15
cls & call :info & title %title%
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
::��ѹ������������
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    call :select10 "redownload" "����ѹ����У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :updateGameZip_3
) else goto :updateGameZip_3
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do jq -r "select(.remoteName==\"%%a\")|.path" "%bat_cache_path%fileinfo.txt"
)>"%bat_cache_path%filedl.txt"
call :backtrack "16"
:backtrack_16
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
goto :updateGameZip_2
:updateGameZip_3
::��ѹѹ����
call :backtrack "17"
:backtrack_17
cls & call :info & title %title%
title %title% ��ѹ�ϲ���
cd /d "%bat_game_install_path%"
::filern.txt��verify������,,,
for /f "usebackq delims=*" %%a in ("%bat_cache_path%\filern.txt") do (
    7z x "%%a" -aoa
::�ļ�ɾ���ͺϲ�
    if exist "deletefiles.txt" (
        for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "deletefiles.txt"') do del /q "%%a" 2>nul
        del /q "deletefiles.txt" 2>nul
    )
    if exist "hdifffiles.txt" (
        for /f "delims=*" %%a in ('jq -r ".remoteName|split(\"/\")|join(\"\\\\\")" "hdifffiles.txt"') do (
            hpatchz -f "%%a" "%%a.hdiff" "%%a"
            del /q "%%a.hdiff" 2>nul
        )
        del /q "hdifffiles.txt" 2>nul
    )
)

if not "%debug_not_del_zip%"=="1" for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%filern.txt"') do del /q "%%a" 2>nul
cd /d %~dp0
:updateGameZip_4
::�ļ�У��
call :backtrack "18"
:backtrack_18
cls & call :info & title %title%
title %title% �ļ�У����
copy /y "%bat_game_install_path%pkg_version" "%bat_cache_path%pkg"
if %menu_2___zh-cn%==1 if exist "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ja-jp%==1 if exist "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___en-us%==1 if exist "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ko-kr%==1 if exist "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" "%bat_cache_path%pkg"
call :verify "%bat_cache_path%pkg"
::sdkУ��
set "sdk_corrupted=0"
if %menu_2_%==2 (
    for /f "tokens=1*" %%a in ('jq -r -j ".md5,\" \",.remoteName" "%bat_game_install_path%sdk_pkg_version"') do (
        if not exist "%bat_game_install_path%%%b" (
            set "sdk_corrupted=1"
        ) else for /f "delims=*" %%a in ('md5deep -A %%a "%bat_game_install_path%%%b" 2^>nul') do set "sdk_corrupted=1"
    )
)
call :backtrack "19"
:backtrack_19
cls & call :info & title %title%
set "md5check=0"
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
if %sdk_corrupted%==1 set /a "md5check+=1"
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    if %sdk_corrupted%==1 jq -r ".remoteName" "%bat_game_install_path%sdk_pkg_version"
    call :select10 "redownload" "�����ļ�У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :updateGame_2
) else goto :updateGame_2
for /f "delims=*" %%a in ('jq -r ".data.game.latest.decompressed_path" "%bat_cache_path%resource.json"') do set "url_decompressed_path=%%a/"
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do (
    echo %url_decompressed_path%%%a
    echo  out=%%a
)
)>"%bat_cache_path%filedl.txt"
if %sdk_corrupted%==1 jq -r ".data.sdk.path" "%bat_cache_path%resource.json" >>"%bat_cache_path%filedl.txt"
call :backtrack "20"
:backtrack_20
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
if %sdk_corrupted%==1 (
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
goto :updateGameZip_4
goto :eof
::�ļ�����
:updateGameFile
cls & call :info & title %title%
::��ȡdeletefiles.txt & hdifffiles.txt
(
if %menu_2___zh-cn%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"zh-cn\")|{remoteName:.name,path:.path}" "%bat_cache_path%resource.json"
if %menu_2___ja-jp%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ja-jp\")|{remoteName:.name,path:.path}" "%bat_cache_path%resource.json"
if %menu_2___en-us%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"en-us\")|{remoteName:.name,path:.path}" "%bat_cache_path%resource.json"
if %menu_2___ko-kr%==1 jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ko-kr\")|{remoteName:.name,path:.path}" "%bat_cache_path%resource.json"
jq -c ".data.game.diffs[]|select(.version==\"%game_client_version%\")|{remoteName:.name,path:.path}" "%bat_cache_path%resource.json"
)>"%bat_cache_path%fileinfo.txt"
cd /d "%bat_game_install_path%"
for /f "tokens=1,2" %%a in ('jq -r -j ".remoteName,\" \",.path,\"\n\"" "%bat_cache_path%fileinfo.txt"') do curl -# -L -r 0-10485760 -o "%%a" "%%b"
for /f "delims=*" %%a in ('jq -r ".remoteName" "%bat_cache_path%fileinfo.txt"') do (
    7z e "%%a" "deletefiles.txt" -aoa
    7z e "%%a" "hdifffiles.txt" -aoa
    if exist "deletefiles.txt" (
        for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "deletefiles.txt"') do del /q "%%a" 2>nul
        del /q "deletefiles.txt" 2>nul
    )
    if exist "hdifffiles.txt" (
        for /f "delims=*" %%a in ('jq -r ".remoteName|split(\"/\")|join(\"\\\\\")" "hdifffiles.txt"') do del /q "%%a" 2>nul
        del /q "hdifffiles.txt" 2>nul
    )
    del /q "%%a" 2>nul
)
cd /d %~dp0 
for /f "delims=*" %%a in ('jq -r ".data.game.latest.decompressed_path" "%bat_cache_path%resource.json"') do set "url_decompressed_path=%%a/"
(
echo %url_decompressed_path%pkg_version
del /q "%bat_game_install_path%pkg_version" 2>nul
if %menu_2___zh-cn%==1 (
    echo %url_decompressed_path%Audio_%path_zh-cn%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" 2>nul
)
if %menu_2___ja-jp%==1 (
    echo %url_decompressed_path%Audio_%path_ja-jp%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" 2>nul
)
if %menu_2___en-us%==1 (
    echo %url_decompressed_path%Audio_%path_en-us%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" 2>nul
)
if %menu_2___ko-kr%==1 (
    echo %url_decompressed_path%Audio_%path_ko-kr%_pkg_version
    del /q "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" 2>nul
)
if %menu_2_%==2 jq -r ".data.sdk.path" "%bat_cache_path%resource.json"
)>"%bat_cache_path%filedl.txt"
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c false -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --remove-control-file true --allow-overwrite true --auto-file-renaming false
if %menu_2_%==2 (   
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
:updateGameFile_2
::�ļ�У��(��ȫ)
call :backtrack "21"
:backtrack_21
cls & call :info & title %title%
title %title% �ļ�У����
copy /y "%bat_game_install_path%pkg_version" "%bat_cache_path%pkg"
if %menu_2___zh-cn%==1 if exist "%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_zh-cn%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ja-jp%==1 if exist "%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ja-jp%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___en-us%==1 if exist "%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_en-us:^=%_pkg_version" "%bat_cache_path%pkg"
if %menu_2___ko-kr%==1 if exist "%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" copy /b "%bat_cache_path%pkg"+"%bat_game_install_path%Audio_%path_ko-kr%_pkg_version" "%bat_cache_path%pkg"
call :verify "%bat_cache_path%pkg"
::sdkУ��
set "sdk_corrupted=0"
if %menu_2_%==2 (
    for /f "tokens=1*" %%a in ('jq -r -j ".md5,\" \",.remoteName" "%bat_game_install_path%sdk_pkg_version"') do (
        if not exist "%bat_game_install_path%%%b" (
            set "sdk_corrupted=1"
        ) else for /f "delims=*" %%a in ('md5deep -A %%a "%bat_game_install_path%%%b" 2^>nul') do set "sdk_corrupted=1"
    )
)
call :backtrack "22"
:backtrack_22
cls & call :info & title %title%
set "md5check=0"
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
if %sdk_corrupted%==1 set /a "md5check+=1"
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    if %sdk_corrupted%==1 jq -r ".remoteName" "%bat_game_install_path%sdk_pkg_version"
    call :select10 "redownload" "�����ļ�У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :updateGame_2
) else goto :updateGame_2
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do (
    echo %url_decompressed_path%%%a
    echo  out=%%a
)
)>"%bat_cache_path%filedl.txt"
if %sdk_corrupted%==1 jq -r ".data.sdk.path" "%bat_cache_path%resource.json" >>"%bat_cache_path%filedl.txt"
call :backtrack "23"
:backtrack_23
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
if %sdk_corrupted%==1 (
    7z x "%bat_game_install_path%%sdk_name%" -aoa -o"%bat_game_install_path%"
    del /q "%bat_game_install_path%%sdk_name%" 2>nul
)
goto :updateGameFile_2
goto :eof
:updateGame_2
::����
call :writeConfig "%bat_game_install_path%config.ini" "General" "game_version" "%game_latest_version%"
call :writeConfig "%bat_game_install_path%config.ini" "General" "plugin_sdk_version" "%sdk_latest_version%"
call :writeConfig "%bat_game_install_path%config.ini" "General" "channel" "%channel%"
call :writeConfig "%bat_game_install_path%config.ini" "General" "sub_channel" "%sub_channel%"
call :writeConfig "%config_name%" "bat" "current_channel" "%menu_2_%"
cls & call :info & title %title%
title %title% �������
call :delCache
echo ��Ϸ���³ɹ�
if %menu_2_%==1 ( echo �������ٷ�) else if %menu_2_%==2 ( echo ������B��) else echo ���������ʷ�
echo �汾��%game_client_version% -^> %game_latest_version%
echo �밴������˳��ű�...
pause >nul
goto :eof
:updateGame_3
cls & call :info & title %title%
echo ��Ϸδ��װ���밴������˳��ű�...
pause >nul
goto :eof
:updateGame_4
cls & call :info & title %title%
echo ��Ϸ�������°汾���밴������˳��ű�...
pause >nul
goto :eof
:updateGame_5
cls & call :info & title %title%
echo ��Ϸ�汾���ͣ�������ɾ�������°�װ��ע�Ᵽ����Ϸ��ͼ����Ҫ����
echo ��������˳��ű�...
pause >nul
goto :eof

:preDownloadGame
::��ȡresource
if not %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_cn%" || goto :updateGame )
if %menu_2_%==3 ( curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_1%" ||(
        curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_2%" || goto :updateGame )
)
if "%debug_replace_resource%"=="1" echo resource.json�滻�ϵ�& pause
::��ȡ��Ϸ��С
set "game_total_size=0"
set "game_total_package_size=0"
for /f "tokens=1,2" %%a in ('jq -r ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" )
if %menu_2___zh-cn%==1 for /f "tokens=1,2" %%a in ('jq -r ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"zh-cn\")|.size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" )
if %menu_2___ja-jp%==1 for /f "tokens=1,2" %%a in ('jq -r ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ja-jp\")|.size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" )
if %menu_2___en-us%==1 for /f "tokens=1,2" %%a in ('jq -r ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"en-us\")|.size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" )
if %menu_2___ko-kr%==1 for /f "tokens=1,2" %%a in ('jq -r ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ko-kr\")|.size" "%bat_cache_path%resource.json"') do ( set "game_total_size=%game_total_size%+%%a" )
for /f %%a in ('jq -n "%game_total_size%"') do set "game_total_size=%%a"
for /f %%a in ('jq -n "%game_total_size%/1073741824*100+0.5|floor/100"') do set "game_total_size_display=%%a"
cls & call :info & title %title%
::�ĸ���ʾ��С
call :select10 "predownload" "Ԥ���ؽ�֧��ѹ����ģʽ��Ԥ�� %game_total_size_display% GB���Ƿ����"
if %predownload%==0 echo �밴������˳��ű�...& pause >nul & goto :eof
cls & call :info & title %title%
::����ѹ�����嵥
(
if %menu_2___zh-cn%==1 jq -c ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"zh-cn\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ja-jp%==1 jq -c ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ja-jp\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___en-us%==1 jq -c ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"en-us\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
if %menu_2___ko-kr%==1 jq -c ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|.voice_packs[]|select(.language==\"ko-kr\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
jq -c ".data.pre_download_game.diffs[]|select(.version==\"%game_client_version%\")|{remoteName:.name,path:.path,md5:.md5}" "%bat_cache_path%resource.json"
)>"%bat_cache_path%fileinfo.txt"
::���������嵥
jq -r ".path" "%bat_cache_path%fileinfo.txt" >"%bat_cache_path%filedl.txt"
call :backtrack "24"
:backtrack_24
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
:preDownloadGame_2
::У��ѹ����
call :backtrack "25"
:backtrack_25
cls & call :info & title %title%
title %title% ѹ����У����
call :verify "%bat_cache_path%fileinfo.txt"
call :backtrack "26"
:backtrack_26
cls & call :info & title %title%
for /f "tokens=3 delims=:" %%a in ('find /V "" /C "%bat_cache_path%md5check.txt"') do (
    for /f %%a in ("%%a") do set "md5check=%%a"
)
::��ѹ������������
if not %md5check%==0 (
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do echo %%a
    call :select10 "redownload" "����ѹ����У��ʧ�ܣ��Ƿ���������"
    if !redownload!==0 goto :preDownloadGame_3
) else goto :preDownloadGame_3
for /f "delims=*" %%a in ('jq -R -r "split(\"/\")|join(\"\\\\\")" "%bat_cache_path%md5check.txt"') do del /q "%bat_game_install_path%%%a" 2>nul
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%md5check.txt") do jq -r "select(.remoteName==\"%%a\")|.path" "%bat_cache_path%fileinfo.txt"
)>"%bat_cache_path%filedl.txt"
call :backtrack "27"
:backtrack_27
cls & call :info & title %title%
title %title% ������
aria2c -i "%bat_cache_path%filedl.txt" -d "%bat_game_install_path:\=/%" -c true -j 16 -x 16 -s 16 --max-overall-download-limit=%bat_speed_limit%K  --file-allocation=none --auto-file-renaming false
goto :preDownloadGame_2
:preDownloadGame_3
cls & call :info & title %title%
title %title% Ԥ�������
call :delCache
echo Ԥ���سɹ�
if %menu_2_%==1 ( echo �������ٷ�) else if %menu_2_%==2 ( echo ������B��) else echo ���������ʷ�
echo �汾��pre-%game_pre_version%
echo �밴������˳��ű�...
pause >nul
goto :eof
:preDownloadGame_4
cls & call :info & title %title%
echo Ԥ����δ���ţ��밴������˳��ű�...
pause >nul
goto :eof


:modifyGamePath
cls & call :info & title %title%
echo ��ѡ����Ϸ��װĿ¼�����ȡ���Գ�������
set "local_modifyGamePath="
call :getFloderPath "local_modifyGamePath" "ѡ����Ϸ��װĿ¼"
if not defined local_modifyGamePath (
    if not defined bat_game_install_path ( set "local_modifyGamePath=%~dp0Genshin" ) else goto :menu
)
call :writeConfig "%config_name%" "bat" "game_install_path" "%local_modifyGamePath%\"
echo �ѽ���ϷĿ¼�޸�����%bat_game_install_path%��
pause
goto :menu
goto :eof

::���ֵֹ�
:correctChannel
set "local_correctChannel_cn=1"
set "local_correctChannel_global=1"
set "local_correctChannel_sp=1"
set "local_correctChannel_cn_data=1"
set "local_correctChannel_global_data=1"
set "local_correctChannel_sp_data=1"
if exist "%bat_game_install_path%%path_name_cn%.exe" set "local_correctChannel_cn=2"
if exist "%bat_game_install_path%%path_name_global%.exe" set "local_correctChannel_global=3"
if exist "%bat_game_install_path%%path_name_sp%.exe" set "local_correctChannel_sp=5"
if exist "%bat_game_install_path%%path_name_cn%_Data\" set "local_correctChannel_cn_data=7"
if exist "%bat_game_install_path%%path_name_global%_Data\" set "local_correctChannel_global_data=11"
if exist "%bat_game_install_path%%path_name_sp%_Data\" set "local_correctChannel_sp_data=13"
set /a "local_correctChannel=%local_correctChannel_cn%*%local_correctChannel_global%*%local_correctChannel_sp%*%local_correctChannel_cn_data%*%local_correctChannel_global_data%*%local_correctChannel_sp_data%"
if %local_correctChannel%==14 (
    call :writeConfig "%config_name%" "bat" "current_channel" "cn"
    echo ��ǰ����������
)
if %local_correctChannel%==33 (
    call :writeConfig "%config_name%" "bat" "current_channel" "global"
    echo ��ǰ���������ʷ�
)
if %local_correctChannel%==65 (
    call :writeConfig "%config_name%" "bat" "current_channel" "sp"
    echo ��ǰ������sp
)
pause
goto :menu
goto :eof

::--max-overall-download-limit=<SPEED>
:modifySpeedLimit
cls & call :info & title %title%
echo ��ǰ���٣�%bat_speed_limit% KB/s
echo �ÿ��Գ�����������0�ر�����
set "local_modifySpeedLimit="
:modifySpeedLimit_
set /p "local_modifySpeedLimit=���������������(KB/s)��"
if not defined local_modifySpeedLimit goto :menu
if "%local_modifySpeedLimit%"=="0" (
    call :writeConfig "%config_name%" "bat" "speed_limit" "0"
    echo �ѹر���������
    pause
    goto :menu
)
echo %local_modifySpeedLimit%| findstr "^[1-9][0-9]*$" >nul ||( echo �������& goto :modifySpeedLimit_ )
call :writeConfig "%config_name%" "bat" "speed_limit" "%local_modifySpeedLimit%"
echo �ѽ����������޸�Ϊ��%bat_speed_limit% KB/s
pause
goto :menu
goto :eof

:modifyResolution
cls & call :info & title %title%
echo ��ǰ�ֱ��ʣ�%bat_screen_width%x%bat_screen_height%
echo �ÿ��Գ�������
set "local_modifyResolution="
:modifyResolution_
set /p "local_modifyResolution=���÷ֱ���(��x��)��"
if not defined local_modifyResolution goto :menu
echo %local_modifyResolution%| findstr "^[1-9][0-9]*x[1-9][0-9]*$" >nul ||( echo �������& goto :modifyResolution_ )
for /f "tokens=1* delims=x" %%a in ("%local_modifyResolution%") do (
    call :writeConfig "%config_name%" "bat" "screen_width" "%%a"
    call :writeConfig "%config_name%" "bat" "screen_height" "%%b"
)
echo �ѽ��ֱ����޸�Ϊ��%local_modifyResolution%
pause
goto :menu
goto :eof


:setVar
set "url_resource_cn=https://sdk-static.mihoyo.com/hk4e_cn/mdk/launcher/api/resource?launcher_id=17&key=KAtdSsoQ&channel_id=14"
set "url_resource_global_1=https://hk4e-launcher-static.hoyoverse.com/hk4e_global/mdk/launcher/api/resource?key=gcStgarh&launcher_id=10&sub_channel_id=3"
set "url_resource_global_2=https://sdk-os-static.hoyoverse.com/hk4e_global/mdk/launcher/api/resource?key=gcStgarh&launcher_id=10&sub_channel_id=3"
set "url_gntd_nt6=https://vgn.lanzouw.com/i0bZL0ozsl2b?"
set "url_gntd_nt10=https://vgn.lanzouw.com/iywMf0ozsl1a?"
set "url_readme=https://www.bilibili.com/read/cv19441163?"
set "path_name_cn=YuanShen"
set "path_name_global=GenshinImpact"
set "path_name_sp=ys"
set "path_name_voice_pack=Audio_{lang}_{version}.zip"
set "path_zh-cn=Chinese"
set "path_en-us=English^(US^)"
set "path_ja-jp=Japanese"
set "path_ko-kr=Korean"
::set "jq_install={game:{version:.data.game.latest.version,name:.data.game.latest.name,path:.data.game.latest.path,md5:.data.game.latest.md5,size:.data.game.latest.size,package_size:.data.game.latest.package_size,voice_packs:.data.game.latest.voice_packs,segments:.data.game.latest.segments},sdk:{version:.data.sdk.version,name:.data.sdk.name,path:.data.sdk.path,md5:.data.sdk.md5}}"
set "bat_cache_path=.\cache\"
set "bat_lib_path=.\lib\"
set "bat_data_path=.\data\"
set "bat_speed_limit=0"
set "bat_name=default"
::set "bat_if_check_integrity=true"
::set "bat_check_game_update=1"
::set "bat_game_install_path=.\Genshin\"
goto :eof


:info
echo ----------------------------
echo ԭ�񹤾���[v%bat_version%] By Golden_nianhua
echo ʹ��˵�� %url_readme%
echo ----------------------------
if defined bat_game_install_path echo ��Ϸ��װĿ¼��%bat_game_install_path%
if defined disk_Size echo ���̴�С��%disk_Size_display%GB ���ÿռ䣺%disk_FreeSpace_display%GB �ļ�ϵͳ��%disk_FileSystem%
if defined game_latest_version echo ��Ϸ�汾��%game_client_version% ���°汾��%game_latest_version% Ԥ���ذ汾��%game_pre_version%
echo ----------------------------
goto :eof


:delCache
if exist "%bat_cache_path%" ( cd /d "%bat_cache_path%" 
) else md "%bat_cache_path%" & goto :eof
(
    del /q "%bat_cache_path%ini.edit"
    del /q "%bat_cache_path%ini.copy"
    del /q "%bat_cache_path%vbsreturn"
    del /q "%bat_cache_path%backtrack"
    del /q "%bat_cache_path%pkg"
    del /q "%bat_cache_path%fileinfo.txt"
    del /q "%bat_cache_path%filedl.txt"
    del /q "%bat_cache_path%filemd5.txt"
    del /q "%bat_cache_path%filern.txt"
    del /q "%bat_cache_path%md5check.txt"
    del /q "%bat_cache_path%resource.json"
) >nul 2>nul
cd /d %~dp0
goto :eof


:select "var" "title" "options"
set "local_select_count=0"
echo =======%~2========
:select_2
shift /2
if not "%~2"=="" (
    set /a "local_select_count+=1"
    echo ��!local_select_count!��%~2
    goto :select_2
)
echo =======================
if defined option for /f "tokens=1* delims=_" %%a in ("%option%") do (
    set "%~1=%%a"
    set "option=%%b"
    goto :select_4
)
:select_3
set /p "%~1=��������ţ�"
:select_4
echo !%~1!| findstr "^[0-9]*$" >nul ||( echo �������& goto :select_3 )
if not !%~1! GTR 0 echo �������& goto :select_3
if not !%~1! LEQ %local_select_count% echo �������& goto :select_3
set "option_record=%option_record%_!%~1!"
goto :eof

:select10 "var" "title"
set /p "%~1=%~2(Y/N)��"
echo !%~1!| findstr /i "Y" >nul &&( set "%~1=1" & goto :eof )
echo !%~1!| findstr /i "N" >nul &&( set "%~1=0" & goto :eof )
echo �������
goto :select10
goto :eof

:selectLang "var" "title"
echo =======%~2========
echo ��A������
echo ��B������
echo ��C������
echo ��D��Ӣ��
echo ��E������
echo =======================
if defined option for /f "tokens=1* delims=_" %%a in ("%option%") do (
    set "%~1=%%a"
    set "option=%%b"
    goto :selectLang_3
)
:selectLang_2
set /p "%~1=������ѡ��ɶ�ѡ����"
:selectLang_3
echo !%~1!| findstr /i "^[A-E]*$" >nul ||( echo �������& goto :selectLang_2 )
echo !%~1!| findstr /i "A" >nul &&( set "%~1_skip=1" & set "%~1_zh-cn=0" & set "%~1_ja-jp=0" & set "%~1_en-us=0" & set "%~1_ko-kr=0" & goto :eof)|| set "%~1_skip=0"
echo !%~1!| findstr /i "B" >nul &&( set "%~1_zh-cn=1" )|| set "%~1_zh-cn=0"
echo !%~1!| findstr /i "C" >nul &&( set "%~1_ja-jp=1" )|| set "%~1_ja-jp=0"
echo !%~1!| findstr /i "D" >nul &&( set "%~1_en-us=1" )|| set "%~1_en-us=0"
echo !%~1!| findstr /i "E" >nul &&( set "%~1_ko-kr=1" )|| set "%~1_ko-kr=0"
set "option_record=%option_record%_!%~1!"
goto :eof


:createGNTConfig
cls & call :info & title %title%
echo ���Ϊ�״���������ѡ����Ϸ��װĿ¼
call :getFloderPath "bat_game_install_path" "ѡ����Ϸ��װĿ¼"
if not defined bat_game_install_path set "bat_game_install_path=%~dp0Genshin"
set "bat_game_install_path=%bat_game_install_path%\"
(
    echo [bat]
    echo game_install_path=%bat_game_install_path%
)>"%config_name%"
goto :eof


:loadConfig "filepath"
for /f "tokens=1* delims=:" %%a in ('findstr /r /n /c:"^ *\[.*\] *$" "%~1" 2^>nul') do call :loadConfig_2 "%~1" "%%a" "%%b"
goto :eof
:loadConfig_2
for /f "tokens=1* delims=[] " %%a in ("%~3") do set "local_loadConfig_section=%%a"
for /f "skip=%~2 usebackq delims=*" %%a in ("%~1") do (
    echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && goto :eof
    set "%local_loadConfig_section%_%%a"
)
goto :eof

:loadConfigSection "filepath" "section" "prefix"
for /f "tokens=1* delims=:" %%a in ('findstr /r /n /c:"^ *\[ *%~2 *\] *$" "%~1" 2^>nul') do call :loadConfigSection_2 "%~1" "%%a" "%~3"
goto :eof
:loadConfigSection_2
if not "%~3"=="" set "local_loadConfigSection_prefix=%~3_"
for /f "skip=%~2 usebackq delims=*" %%a in ("%~1") do (
    echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && goto :eof
    set "%local_loadConfigSection_prefix%%%a"
)
goto :eof

:formatConfig "filepath"
for /f "tokens=1* delims=:" %%a in ('findstr /r /n /c:"^ *\[.*\] *$" "%~1"') do call :formatConfig_2 "%~1" "%%a" "%%b"
call :moveFile "%bat_cache_path%ini.edit" "%~1"
goto :eof
:formatConfig_2
for /f "tokens=1* delims=[] " %%a in ("%~3") do set "local_formatConfig_section=%%a"
for /f "skip=%~2 usebackq delims=*" %%a in ("%~1") do (
    echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && goto :formatConfig_3
    set "local_formatConfig_%local_formatConfig_section%.%%a"
)
:formatConfig_3
(
    echo [%local_formatConfig_section%]
    for /f "tokens=1* delims=." %%a in ('set "local_formatConfig_%local_formatConfig_section%."') do (
        set "local_formatConfig_db=%%b"
        call :delBlank "local_formatConfig_db" "local_formatConfig_db"
        echo !local_formatConfig_db!
    )
    echo.
)>>"%bat_cache_path%ini.edit"
goto :eof

:writeConfig "filepath" "section" "key" "value"
set "%~2_%~3=%~4"
if not exist "%~1" (
    ( echo [%~2])>"%bat_cache_path%ini.copy"
    call :moveFile "%bat_cache_path%ini.copy" "%~1"
)
( 
    for /f "usebackq delims=*" %%a in ("%~1") do echo %%a
)>"%bat_cache_path%ini.copy"
for /f "tokens=1* delims=:" %%a in ('findstr /r /n /c:"^ *\[ *%~2 *\] *$" "%bat_cache_path%ini.copy"') do (
    set "local_writeConfig_line=%%a"
    goto :writeConfig_2
)
goto :writeConfig_7
:writeConfig_2
for /f "skip=%local_writeConfig_line% usebackq delims=*" %%a in ("%bat_cache_path%ini.copy") do (
    echo "%%a"| findstr /r /c:"\" *%~3 *=.*\"" >nul && goto :writeConfig_3
    echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && goto :writeConfig_5
    set /a "local_writeConfig_line+=1"
)
for /f "delims=*" %%a in ("%~3=%~4") do ( echo %%a)>>"%~1"
goto :eof
:writeConfig_3
set "local_writeConfig_line_2=0"
(
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%ini.copy") do (
        set /a "local_writeConfig_line_2+=1"
        if !local_writeConfig_line_2! GEQ 2 ( echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && echo.)
        echo %%a
        if !local_writeConfig_line_2! GEQ %local_writeConfig_line% goto :writeConfig_4
    )
)>"%bat_cache_path%ini.edit"
goto :eof
:writeConfig_4
for /f "delims=*" %%a in ("%~3=%~4") do ( echo %%a)>>"%bat_cache_path%ini.edit"
set /a "local_writeConfig_line+=1"
(
    for /f "skip=%local_writeConfig_line% usebackq delims=*" %%a in ("%bat_cache_path%ini.copy") do (
        echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && echo.
        echo %%a
    )
)>>"%bat_cache_path%ini.edit"
call :moveFile "%bat_cache_path%ini.edit" "%~1"
goto :eof
:writeConfig_5
set "local_writeConfig_line_2=0"
(
    for /f "usebackq delims=*" %%a in ("%bat_cache_path%ini.copy") do (
        set /a "local_writeConfig_line_2+=1"
        if !local_writeConfig_line_2! GEQ 2 ( echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && echo.)
        echo %%a 
        if !local_writeConfig_line_2! GEQ %local_writeConfig_line% goto :writeConfig_6
    )
)>"%bat_cache_path%ini.edit"
goto :eof
:writeConfig_6
for /f "delims=*" %%a in ("%~3=%~4") do ( echo %%a)>>"%bat_cache_path%ini.edit"
(
    for /f "skip=%local_writeConfig_line% usebackq delims=*" %%a in ("%bat_cache_path%ini.copy") do (
        echo "%%a"| findstr /r /c:"^\" *\[.*\] *\"$" >nul && echo.
        echo %%a
    )
)>>"%bat_cache_path%ini.edit"
call :moveFile "%bat_cache_path%ini.edit" "%~1"
goto :eof
:writeConfig_7
(
    echo.
    echo [%~2]
    for /f "delims=*" %%a in ("%~3=%~4") do ( echo %%a)
)>>"%~1"
goto :eof


:moveFile "source" "destination"
echo F| xcopy /q /h /r /y "%~1" "%~2" >nul 2>nul
del /q "%~1" 2>nul
goto :eof


:getFloderPath
md "%bat_cache_path%" 2>nul
mshta vbscript:"<script language=vbs>set f = CreateObject(""Scripting.FileSystemObject"").OpenTextFile(""%bat_cache_path%vbsreturn"", 2, True, 0):set folder = CreateObject(""Shell.Application"").BrowseForFolder(0, ""%~2"",0):if not folder is nothing Then f.Write folder.self.path:end if:f.close:window.close</script>"
set /p "%~1="<"%bat_cache_path%vbsreturn"
goto :eof

:delBlank "var" "str"
set "local_delBlank=!%~2!"
:delBlank_2
if "%local_delBlank:~-1%"==" " set "local_delBlank=%local_delBlank:~,-1%" & goto :delBlank_2
set "%~1=%local_delBlank%"
goto :eof

:lib
md "%bat_lib_path%" 2>nul
set "path=%bat_lib_path%;%bat_lib_path%curl\bin\;%path%"
:lib_2
ren "GN Toolkit Lib*.exe" "GN Toolkit Lib.exe" 2>nul
if exist "GN Toolkit Lib.exe" (
    "GN Toolkit Lib.exe" -y -o"%bat_lib_path%"
    del /q "GN Toolkit Lib.exe" 2>nul
)
where curl >nul 2>nul || goto :lib_3
where 7z >nul 2>nul || call :lib_5
where jq >nul 2>nul || call :lib_6
where aria2c >nul 2>nul || call :lib_7
where hpatchz >nul 2>nul || call :lib_8
where md5deep >nul 2>nul || call :lib_9
goto :eof
:lib_3
cls & call :info
echo curl�����޷�����ʹ�ã�����3s��򿪱���������ҳ
echo %url_lib_nt6%
echo ������ɺ��뽫[GN Toolkit Lib NT6.exe]��ű��ŵ�ͬһĿ¼��Ȼ�����������
timeout /t 3 /nobreak >nul
start %url_lib_nt6%
pause >nul
ren "GN Toolkit Lib*.exe" "GN Toolkit Lib.exe" 2>nul
if not exist "GN Toolkit Lib.exe" goto :lib_3
goto :lib_2
:lib_4
cls & call :info
echo ���粻�ѣ�����3s��򿪱���������ҳ
echo %url_lib_nt10%
echo ������ɺ��뽫[GN Toolkit Lib NT10.exe]��ű��ŵ�ͬһĿ¼��Ȼ�����������
timeout /t 3 /nobreak >nul
start %url_lib_nt10%
pause >nul
ren "GN Toolkit Lib*.exe" "GN Toolkit Lib.exe" 2>nul
if not exist "GN Toolkit Lib.exe" goto :lib_4
goto :lib_2
:lib_5
echo ����7z.exe...
curl -# -L --connect-timeout 10 -m 30 -o "%bat_cache_path%7zInstaller.exe" "https://www.7-zip.org/a/7z2301-x64.exe"
"%bat_cache_path%7zInstaller" /S /D="%bat_cache_path%7z"
call :moveFile "%bat_cache_path%7z\7z.exe" "%bat_lib_path%" >nul
call :moveFile "%bat_cache_path%7z\7z.dll" "%bat_lib_path%" >nul
rd "%bat_cache_path%7z\" /s /q
del /q "%bat_cache_path%7zInstaller.exe" 2>nul
7z -h >nul 2>nul && goto :eof || goto :lib_4
:lib_6
echo ����jq.exe...
for /f "tokens=2" %%a in ('curl -# -L --connect-timeout 10 "https://api.github.com/repos/stedolan/jq/releases/latest" ^| findstr "jqlang/jq/releases/download/jq.*/jq-win64.exe"') do curl -# -L --connect-timeout 10 -m 30 -o "%bat_lib_path%jq.exe" %%a
jq -h >nul 2>nul && goto :eof || goto :lib_4
:lib_7
echo ����aria2c.exe...
for /f "tokens=2" %%a in ('curl -# -L --connect-timeout 10 "https://api.github.com/repos/aria2/aria2/releases/latest" ^| findstr "aria2/aria2/releases/download/release-.*/aria2-.*-win-64bit-build1.zip"') do curl -# -L --connect-timeout 10 -m 30 -o "%bat_cache_path%aria2c.zip" %%a
7z e "%bat_cache_path%aria2c.zip" "aria2-*-win-64bit-build1\aria2c.exe" -aoa -o"%bat_lib_path%"
del /q "%bat_cache_path%aria2c.zip" 2>nul
aria2c -h >nul 2>nul && goto :eof || goto :lib_4
:lib_8
echo ����hpatchz.exe...
for /f "tokens=2" %%a in ('curl -# -L --connect-timeout 10 "https://api.github.com/repos/sisong/HDiffPatch/releases/latest" ^| findstr "sisong/HDiffPatch/releases/download/.*/hdiffpatch_.*_bin_windows64.zip"') do curl -# -L --connect-timeout 10 -m 30 -o "%bat_cache_path%hdiffpatch.zip" %%a
7z e "%bat_cache_path%hdiffpatch.zip" "windows64\hpatchz.exe" -aoa -o"%bat_lib_path%"
del /q "%bat_cache_path%hdiffpatch.zip" 2>nul
hpatchz -h >nul 2>nul && goto :eof || goto :lib_4
:lib_9
echo ����md5deep.exe...
for /f "tokens=2" %%a in ('curl -# -L --connect-timeout 10 "https://api.github.com/repos/jessek/hashdeep/releases/latest" ^| findstr "jessek/hashdeep/releases/download/.*/md5deep-.*.zip"') do curl -# -L --connect-timeout 10 -m 30 -o "%bat_cache_path%md5deep.zip" %%a
7z e "%bat_cache_path%md5deep.zip" "md5deep-*\md5deep64.exe" -aoa -o"%bat_lib_path%"
ren "%bat_lib_path%md5deep64.exe" "md5deep.exe"
del /q "%bat_cache_path%hdiffpatch.zip" 2>nul
md5deep -h >nul 2>nul && goto :eof || goto :lib_4
goto :eof


:installVC
echo ����Microsoft Visual C++ Redistributable (x64)...
aria2c "https://aka.ms/vs/17/release/vc_redist.x64.exe" -d "%bat_lib_path:\=/%" -o "vc_redist.x64.exe" -x 16 -s 16 -j 16 --file-allocation=none --remove-control-file true --allow-overwrite true --auto-file-renaming false
echo ��װMicrosoft Visual C++ Redistributable (x64)...
vc_redist.x64 /install /quiet /norestart
goto :eof


:getDiskInfo
for /f "delims=*" %%a in ('wmic LogicalDisk where ^"Caption^=^'%~d0^'^" get freespace^,size^,filesystem /value') do set "disk_%%a" >nul 2>nul
for /f %%a in ('jq -n "%disk_freespace%/1073741824*100|floor/100"') do set "disk_freeSpace_display=%%a"
for /f %%a in ('jq -n "%disk_size%/1073741824*100|floor/100"') do set "disk_size_display=%%a"
goto :eof

:getGameVersion
curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_cn%" ||(
    curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_1%" ||(
        curl -# -L --connect-timeout 3 -o "%bat_cache_path%resource.json" --create-dirs "%url_resource_global_2%" || goto :getGameVersion
    )
)
if "%debug_replace_resource%"=="1" echo resource.json�滻�ϵ�& pause
for /f "delims=*" %%a in ('jq -r ".data.game.latest.version" "%bat_cache_path%resource.json"') do set "game_latest_version=%%a"
for /f "delims=*" %%a in ('jq -r ".data.pre_download_game.latest.version" "%bat_cache_path%resource.json"') do set "game_pre_version=%%a"
for /f "delims=*" %%a in ('jq -r ".data.sdk.version" "%bat_cache_path%resource.json"') do set "sdk_latest_version=%%a"
set "game_client_version=null"
set "game_sdk_version=null"
call :loadConfigSection "%bat_game_install_path%config.ini" "General" "gc"
if defined gc_game_version call :formatVersion "%gc_game_version%" "game_client_version"
if defined gc_plugin_sdk_version call :formatVersion "%gc_plugin_sdk_version%" "game_sdk_version"
goto :eof

:backtrack
(
echo goto :backtrack_%~1
set
)>"%bat_cache_path%backtrack"
goto :eof

:verify "file"
cd /d "%bat_game_install_path%"
jq -r ".remoteName" "%~1" >"%bat_cache_path%filern.txt"
jq -r -j ".md5,\"  \",.remoteName,\"\n\"" "%~1" >"%bat_cache_path%filemd5.txt"
(
for /f "usebackq delims=*" %%a in ("%bat_cache_path%filern.txt") do if not exist "%%a" echo %%a
md5deep -x "%bat_cache_path%filemd5.txt" -f "%bat_cache_path%filern.txt" 2>nul
)>"%bat_cache_path%md5check.txt"
cd /d %~dp0
goto :eof

:formatPath "var"
call :formatPath_2 "%~1" "!%~1!"
goto :eof
:formatPath_2
set "%~1=%~f2"
goto :eof

:formatVersion "ver" "var"
for /f "tokens=1-3* delims=. " %%a in ("%~1.0.0.0") do set "%~2=%%a.%%b.%%c"
goto :eof

:compareVersion "ver1" "ver2" "var"
for /f "delims=*" %%a in ('jq -n "\"%~1\"|split(\".\")|join(\"\")|tonumber as $a|\"%~2\"|split(\".\")|join(\"\")|tonumber as $b|if $a<$b then -1 elif $a==$b then 0 else 1 end"') do set %~3=%%a
goto :eof