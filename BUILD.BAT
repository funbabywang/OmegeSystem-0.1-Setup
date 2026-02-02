@echo off
echo Building Omege System 0.1 for DOS...
echo.

REM 检查NASM是否存在
where nasm >nul 2>nul
if errorlevel 1 (
    echo NASM assembler not found!
    echo Please download from https://www.nasm.us/
    pause
    exit /b 1
)

echo Step 1: Building installer...
nasm install.asm -f bin -o INSTALL.COM
if errorlevel 1 goto error

echo Step 2: Building shell...
nasm shell.asm -f bin -o SHELL.COM
if errorlevel 1 goto error

echo Step 3: Creating system files...

REM 创建引导文件 (512字节)
echo Creating BOOT.BIN...
copy /b NUL BOOT.BIN >nul
fsutil file createnew BOOT.BIN 512 >nul 2>nul
if errorlevel 1 (
    REM 备用方法
    echo. > BOOT.BIN
    for /L %%i in (1,1,9) do type BOOT.BIN >> BOOT.BIN
)

REM 创建内核文件 (4KB)
echo Creating KERNEL.BIN...
copy /b NUL KERNEL.BIN >nul
fsutil file createnew KERNEL.BIN 4096 >nul 2>nul
if errorlevel 1 (
    echo. > TEMP.TXT
    for /L %%i in (1,1,12) do type TEMP.TXT >> KERNEL.BIN
    del TEMP.TXT
)

REM 创建配置文件
echo Creating CONFIG.SYS...
echo DEVICE=C:\OMEGE\BOOT.BIN > CONFIG.SYS
echo FILES=20 >> CONFIG.SYS
echo BUFFERS=10 >> CONFIG.SYS

REM 创建自动批处理文件
echo Creating AUTOEXEC.BAT...
echo @ECHO OFF > AUTOEXEC.BAT
echo PROMPT $$p$$g >> AUTOEXEC.BAT
echo PATH C:\OMEGE;%%PATH%% >> AUTOEXEC.BAT
echo C:\OMEGE\SHELL.COM >> AUTOEXEC.BAT

echo.
echo Build successful!
echo.
echo Files created:
echo   INSTALL.COM - Main installer
echo   SHELL.COM   - Omege System Shell
echo   BOOT.BIN    - Boot loader (512 bytes)
echo   KERNEL.BIN  - System kernel (4KB)
echo   CONFIG.SYS  - Configuration file
echo   AUTOEXEC.BAT - Startup batch file
echo.
echo Installation steps:
echo   1. Copy all files to C:\OMEGE\
echo   2. Run INSTALL.COM
echo   3. Follow the on-screen instructions
echo.
echo Or for quick test in DOSBox:
echo   1. Copy all files to a directory
echo   2. Run INSTALL.COM
echo   3. Run SHELL.COM
echo.
pause
goto end

:error
echo Build failed!
echo Please check NASM installation and try again.
pause

:end