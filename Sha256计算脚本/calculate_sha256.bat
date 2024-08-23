@echo off
setlocal enabledelayedexpansion

:: 定义输出文件
set "HASH_FILE=hash.txt"

:: 清空或创建结果文件
>nul 2>&1 del "%HASH_FILE%"
:: echo Package Name,Date and Time,Hash Value > "%HASH_FILE%"

:: 遍历目录中的所有 .war 和 .jar 文件
for %%F in (*.war *.jar) do (
    :: 格式化结果并追加到文件
    echo Package Name: %%F >> "%HASH_FILE%"
	
    :: 使用 PowerShell 获取当前日期和时间，精确到毫秒
    for /f "tokens=*" %%D in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'"') do set "current_datetime=%%D"
    echo Date and Time: !current_datetime! >> "%HASH_FILE%"
	
    :: 使用 powershell 计算 SHA256 值，并追加到结果文件
    powershell -Command ^
        "Add-Content -Path '%HASH_FILE%' -Value (\"Sha256: \" + (Get-FileHash '%%~fF' -Algorithm SHA256).Hash.ToLower())"
    echo ---------------------------------------------------------------- >> "%HASH_FILE%"   
)

endlocal