@echo off  
chcp 65001
setlocal  
  
echo. >> %~dp0log.txt
echo. >> %~dp0log.txt
echo ----------------attack.bat---------------- >> %~dp0log.txt

for /f "tokens=1-4 delims=/ " %%a in ('echo %date%') do (
    set formatted_date=%%c/%%b/%%d
)
for /f "tokens=1-3 delims=:. " %%a in ('echo %time%') do (
    set formatted_time=%%a:%%b:%%c
)

echo scrip started at %formatted_date% %formatted_time% >> %~dp0log.txt

sc query Gost >nul 2>&1  
if %errorlevel% equ 0 (  
    echo %formatted_date% %formatted_time% [*] Detected Gost service already exists, uninstalling... >> %~dp0log.txt
    echo Gost服务已存在，正在卸载...  
    net stop Gost  
    if %errorlevel% neq 0 (  
        echo %formatted_date% %formatted_time% [-] Unable to stop Gost service >> %~dp0log.txt
        echo 无法停止Gost服务。  
    )  
      
    sc delete Gost  
    if %errorlevel% neq 0 (  
        echo %formatted_date% %formatted_time% [-] Cannot delete Gost service >> %~dp0log.txt
        echo 无法删除Gost服务。  
    )  
      
    rmdir "C:\Program Files\Gost\" /S /Q  
    if %errorlevel% neq 0 (  
        echo %formatted_date% %formatted_time% [-] Cannot delete Gost directory >> %~dp0log.txt
        echo 无法删除Gost目录。  
    )  
      
    echo Gost服务已卸载。  

    echo %formatted_date% %formatted_time% >> %~dp0ip.txt
    for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4 Address"') do (  
        echo %%a  已取消录入>> %~dp0ip.txt  
        echo %formatted_date% %formatted_time% [+] %%a  has been cancelled from the IP list >> %~dp0log.txt
    )
    echo.>> %~dp0ip.txt  

) else (  
    echo %formatted_date% %formatted_time% [*] Detected that Gost service does not exist, installing... >> %~dp0log.txt
    echo Gost服务不存在，正在安装...  
    xcopy "%~dp0Gost.exe" "C:\Program Files\Gost\" /E /Y /I  
      
    sc create Gost binPath= "C:\Program Files\Gost\gost.exe -L :10001" start= auto  
      
    net start Gost  
      
    echo Gost服务已安装并启动。  

    echo %formatted_date% %formatted_time% >> %~dp0ip.txt
    for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "IPv4 Address"') do (  
        echo %%a  已录入>> %~dp0ip.txt  
        echo %formatted_date% %formatted_time% [+] %%a  has been entered into the IP list >> %~dp0log.txt
    )
    echo.>> %~dp0ip.txt 
    echo done

)

echo %formatted_date% %formatted_time% [*] Script execution ends >> %~dp0log.txt
endlocal
pause
