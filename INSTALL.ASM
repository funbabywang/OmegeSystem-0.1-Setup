; INSTALL.ASM - Omege System 0.1 DOS安装程序
; 编译: nasm install.asm -f bin -o INSTALL.COM

ORG 100h                ; COM程序从100h开始

section .text

start:
    jmp main_program    ; 跳过版本信息数据

; ================================================
; 版本信息区
; ================================================
version_info_start:
    db 'OMEGEVERSION',0
    db 'Product: Omege System Installer',13,10,0
    db 'Version: 0.1.0 Alpha',13,10,0
    db 'Build: 2024.01.15',13,10,0
    db 'Copyright (c) 2024 Omege Project',13,10,0
    db 'License: Educational Use Only',13,10,0
    db 'Requirements: DOS 2.0+, 64KB RAM',13,10,0
    db 'Developer: Omege Team',13,10,0
    db 'Contact: For Educational Purposes',13,10,0
    db 'File: INSTALL.COM',13,10,0
    db 'Size: ',0
    size_info db '     bytes',0
    db 0FFh, 0FFh, 0FFh  ; 结束标记
version_info_end:

main_program:
    ; 清屏
    mov ax, 0003h
    int 10h
    
    ; 显示标题
    mov dx, banner
    mov ah, 09h
    int 21h
    
    ; 显示版本
    mov dx, version_display
    mov ah, 09h
    int 21h
    
    jmp main_menu

main_menu:
    ; 显示菜单
    mov dx, menu
    mov ah, 09h
    int 21h
    
    ; 获取用户选择
    mov ah, 01h
    int 21h
    
    ; 处理选择
    cmp al, '1'
    je install_option
    cmp al, '2'
    je about_option
    cmp al, '3'
    je version_option
    cmp al, '4'
    je exit_option
    
    ; 无效选择
    call clear_screen
    mov dx, banner
    mov ah, 09h
    int 21h
    mov dx, version_display
    mov ah, 09h
    int 21h
    jmp main_menu

install_option:
    call install_system
    jmp wait_and_return

about_option:
    call show_about
    jmp wait_and_return

version_option:
    call show_version_details
    jmp wait_and_return

exit_option:
    mov dx, exit_msg
    mov ah, 09h
    int 21h
    int 20h           ; 退出到DOS

wait_and_return:
    ; 等待按键
    mov dx, press_key
    mov ah, 09h
    int 21h
    
    mov ah, 07h
    int 21h
    
    ; 清屏并返回主菜单
    call clear_screen
    mov dx, banner
    mov ah, 09h
    int 21h
    mov dx, version_display
    mov ah, 09h
    int 21h
    jmp main_menu

; ================================================
; 安装系统
; ================================================
install_system:
    call clear_screen
    
    ; 显示安装标题
    mov dx, install_banner
    mov ah, 09h
    int 21h
    
    ; 步骤1：创建目录
    mov dx, install_step1
    mov ah, 09h
    int 21h
    
    call create_dir
    
    ; 步骤2：创建文件
    mov dx, install_step2
    mov ah, 09h
    int 21h
    
    call create_files
    
    ; 步骤3：配置文件
    mov dx, install_step3
    mov ah, 09h
    int 21h
    
    call create_configs
    
    ; 完成
    mov dx, install_complete
    mov ah, 09h
    int 21h
    
    ret

; ================================================
; 创建目录
; ================================================
create_dir:
    ; 尝试创建目录
    mov dx, dir_omege
    mov ah, 39h        ; 创建目录
    int 21h
    
    ; 忽略错误（目录可能已存在）
    ret

; ================================================
; 创建系统文件
; ================================================
create_files:
    ; 创建BOOT.BIN
    mov dx, file_boot
    call create_dummy_file
    ret

; ================================================
; 创建配置文件
; ================================================
create_configs:
    ; 创建CONFIG.SYS
    mov dx, file_config
    call create_config_file
    
    ; 创建AUTOEXEC.BAT
    mov dx, file_autoexec
    call create_autoexec_file
    
    ret

; ================================================
; 创建虚拟文件
; ================================================
create_dummy_file:
    push dx
    
    ; 创建文件
    mov cx, 0          ; 普通文件
    mov ah, 3Ch
    int 21h
    jc .error
    
    mov bx, ax         ; 文件句柄
    
    ; 写入一些数据
    mov cx, 512        ; 512字节
    mov dx, dummy_data
    mov ah, 40h
    int 21h
    
    ; 关闭文件
    mov ah, 3Eh
    int 21h
    
    pop dx
    ret
    
.error:
    pop dx
    ret

; ================================================
; 创建CONFIG.SYS文件
; ================================================
create_config_file:
    push dx
    
    ; 创建文件
    mov cx, 0
    mov ah, 3Ch
    int 21h
    jc .error
    
    mov bx, ax
    
    ; 写入配置内容
    mov cx, config_end - config_text
    mov dx, config_text
    mov ah, 40h
    int 21h
    
    ; 关闭文件
    mov ah, 3Eh
    int 21h
    
    pop dx
    ret
    
.error:
    pop dx
    ret

; ================================================
; 创建AUTOEXEC.BAT文件
; ================================================
create_autoexec_file:
    push dx
    
    ; 创建文件
    mov cx, 0
    mov ah, 3Ch
    int 21h
    jc .error
    
    mov bx, ax
    
    ; 写入内容
    mov cx, autoexec_end - autoexec_text
    mov dx, autoexec_text
    mov ah, 40h
    int 21h
    
    ; 关闭文件
    mov ah, 3Eh
    int 21h
    
    pop dx
    ret
    
.error:
    pop dx
    ret

; ================================================
; 显示关于信息
; ================================================
show_about:
    call clear_screen
    mov dx, about_text
    mov ah, 09h
    int 21h
    ret

; ================================================
; 显示版本详细信息
; ================================================
show_version_details:
    call clear_screen
    
    mov dx, version_header
    mov ah, 09h
    int 21h
    
    ; 显示版本信息
    mov si, version_info_start
    call show_version_info
    
    ; 显示文件大小
    mov dx, file_size_msg
    mov ah, 09h
    int 21h
    
    ; 简单显示文件大小
    mov dx, file_size_value
    mov ah, 09h
    int 21h
    
    mov dx, press_any_key
    mov ah, 09h
    int 21h
    
    mov ah, 07h
    int 21h
    
    ret

; ================================================
; 显示版本信息
; ================================================
show_version_info:
    push si
    
.print_loop:
    ; 检查结束标记
    cmp byte [si], 0FFh
    je .done
    
    ; 检查字符串结束
    cmp byte [si], 0
    je .newline
    
    ; 显示字符
    mov dl, [si]
    mov ah, 02h
    int 21h
    inc si
    jmp .print_loop
    
.newline:
    ; 换行
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    inc si
    jmp .print_loop
    
.done:
    ; 换行
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    pop si
    ret

; ================================================
; 清屏
; ================================================
clear_screen:
    ; 使用滚屏功能清屏
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    
    ; 移动光标到左上角
    mov ah, 02h
    mov bh, 00h
    mov dx, 0000h
    int 10h
    
    ret

; ================================================
; 数据区
; ================================================
section .data

; 标题和版本
banner db '=================================',13,10
       db '    OMEGE SYSTEM 0.1 INSTALLER   ',13,10
       db '=================================',13,10,10,'$'

version_display db 'Version 0.1.0 Alpha - Build 2024.01.15',13,10,10,'$'

menu db '1. Install Omege System 0.1',13,10
     db '2. About Omege System',13,10
     db '3. Show Version Information',13,10
     db '4. Exit to DOS',13,10,10
     db 'Select option (1-4): $'

; 安装相关
install_banner db 'Omege System Installation',13,10
               db '=========================',13,10,10,'$'

install_step1 db 'Step 1: Creating directory C:\OMEGE...',13,10,'$'
install_step2 db 'Step 2: Creating system files...',13,10,'$'
install_step3 db 'Step 3: Creating configuration files...',13,10,'$'

install_complete db 13,10,'Installation complete!',13,10
                 db 'System installed to C:\OMEGE\',13,10
                 db 'Run SHELL.COM to start Omege System.',13,10,'$'

; 关于信息
about_text db 'Omege System 0.1',13,10
           db 'A minimal DOS-like operating system',13,10
           db 'Version: 0.1.0 Alpha',13,10
           db 'Build Date: January 15, 2024',13,10
           db 'Memory: 64KB minimum',13,10
           db 'No mouse support',13,10
           db 'Pure keyboard interface',13,10,10
           db 'This is an educational project.',13,10,'$'

; 版本信息
version_header db 'Omege System - Version Information',13,10
               db '=================================',13,10,10,'$'

file_size_msg db 13,10,'File Size: $'
file_size_value db '~5 KB',13,10,'$'

; 其他字符串
press_key db 13,10,'Press any key to continue... $'
press_any_key db 13,10,'Press any key to continue... $'
exit_msg db 13,10,'Exiting to DOS...',13,10,'$'

; 目录和文件
dir_omege db 'C:\OMEGE',0
file_boot db 'C:\OMEGE\BOOT.BIN',0
file_config db 'C:\OMEGE\CONFIG.SYS',0
file_autoexec db 'C:\OMEGE\AUTOEXEC.BAT',0

; 配置文件内容
config_text:
    db 'DEVICE=C:\OMEGE\BOOT.BIN',13,10
    db 'FILES=20',13,10
    db 'BUFFERS=10',13,10
config_end:

autoexec_text:
    db '@ECHO OFF',13,10
    db 'PROMPT $p$g',13,10
    db 'PATH C:\OMEGE;%PATH%',13,10
    db 'C:\OMEGE\SHELL.COM',13,10
autoexec_end:

; 虚拟文件数据
dummy_data:
    db 'OMEGE SYSTEM 0.1',13,10
    db 'This is a placeholder file.',13,10
    times 480 db 0
