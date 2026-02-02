; SHELL.ASM - Omege System DOS Shell (带版本信息)
; 编译: nasm shell.asm -f bin -o SHELL.COM

ORG 100h                ; COM程序从100h开始

section .text

start:
    jmp main_program    ; 跳过版本信息数据

; ================================================
; 版本信息区
; ================================================
shell_version_info:
    db 'OMEGESHELL',0
    db 'Omege System Shell',0
    db 'Version 0.1.0',0
    db 'Build 2024.01.15',0
    db 0FFh, 0FFh, 0FFh  ; 结束标记

main_program:
    ; 清屏
    mov ax, 0003h
    int 10h
    
    ; 显示标题和版本
    mov dx, banner
    mov ah, 09h
    int 21h
    
    ; 显示版本
    call show_shell_version
    
main_loop:
    ; 显示提示符
    mov dx, prompt
    mov ah, 09h
    int 21h
    
    ; 读取命令行
    mov dx, buffer
    mov ah, 0Ah
    int 21h
    
    ; 处理回车（换行）
    call new_line
    
    ; 获取命令
    mov si, buffer + 2
    cmp byte [si], 0
    je main_loop        ; 空命令
    
    ; 转换为大写
    call to_upper
    
    ; 检查命令
    cmp byte [si], 'H'
    je cmd_help
    cmp byte [si], '?'
    je cmd_help
    cmp byte [si], 'V'
    je cmd_ver
    cmp byte [si], 'I'
    je cmd_info
    cmp byte [si], 'C'
    je cmd_cls
    cmp byte [si], 'D'
    je cmd_dir
    cmp byte [si], 'T'
    je cmd_time
    cmp byte [si], 'E'
    je cmd_exit
    cmp byte [si], 'Q'
    je cmd_exit
    
    ; 未知命令
    mov dx, unknown
    mov ah, 09h
    int 21h
    jmp main_loop

show_shell_version:
    mov dx, version_msg
    mov ah, 09h
    int 21h
    ret

cmd_help:
    mov dx, help_text
    mov ah, 09h
    int 21h
    jmp main_loop

cmd_ver:
    mov dx, version_display
    mov ah, 09h
    int 21h
    jmp main_loop

cmd_info:
    ; 显示详细信息
    call clear_screen
    mov dx, info_header
    mov ah, 09h
    int 21h
    
    ; 显示shell版本信息
    mov si, shell_version_info
    call print_info
    
    ; 显示系统信息
    mov dx, system_info
    mov ah, 09h
    int 21h
    
    mov dx, press_any_key
    mov ah, 09h
    int 21h
    
    mov ah, 07h
    int 21h
    
    call clear_screen
    mov dx, banner
    mov ah, 09h
    int 21h
    call show_shell_version
    jmp main_loop

cmd_cls:
    call clear_screen
    mov dx, banner
    mov ah, 09h
    int 21h
    call show_shell_version
    jmp main_loop

cmd_dir:
    mov dx, dir_text
    mov ah, 09h
    int 21h
    jmp main_loop

cmd_time:
    ; 显示系统时间
    mov dx, time_msg
    mov ah, 09h
    int 21h
    
    ; 获取时间
    mov ah, 2Ch
    int 21h
    
    ; 显示小时
    mov al, ch
    call print_dec
    mov dl, ':'
    mov ah, 02h
    int 21h
    
    ; 显示分钟
    mov al, cl
    call print_dec
    mov dl, ':'
    mov ah, 02h
    int 21h
    
    ; 显示秒
    mov al, dh
    call print_dec
    
    call new_line
    jmp main_loop

cmd_exit:
    mov dx, exit_msg
    mov ah, 09h
    int 21h
    int 20h           ; 退出到DOS

; 实用函数
new_line:
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    ret

print_dec:
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 0
    mov bl, 10
    div bl            ; AL = 商, AH = 余数
    
    push ax
    
    ; 显示十位数
    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h
    
    pop ax
    
    ; 显示个位数
    mov dl, ah
    add dl, '0'
    mov ah, 02h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

to_upper:
    push si
.to_upper_loop:
    mov al, [si]
    cmp al, 0
    je .to_upper_done
    cmp al, 'a'
    jb .next_char
    cmp al, 'z'
    ja .next_char
    sub byte [si], 32  ; 转换为大写
.next_char:
    inc si
    jmp .to_upper_loop
.to_upper_done:
    pop si
    ret

clear_screen:
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
    
    mov ah, 02h
    mov bh, 00h
    mov dx, 0000h
    int 10h
    ret

print_info:
    push si
.print_loop:
    cmp byte [si], 0FFh  ; 检查结束标记
    je .done
    mov al, [si]
    cmp al, 0
    jne .print_char
    call new_line
    inc si
    jmp .print_loop
.print_char:
    mov dl, al
    mov ah, 02h
    int 21h
    inc si
    jmp .print_loop
.done:
    call new_line
    pop si
    ret

section .data

banner db 'Omege System Shell 0.1.0',13,10
       db '=======================',13,10,'$'

version_msg db 'Version 0.1.0 Alpha - Type H for help',13,10,10,'$'
version_display db 'Omege Shell Version 0.1.0',13,10
                db 'Build Date: January 15, 2024',13,10,10,'$'

info_header db 'Omege Shell - System Information',13,10
            db '===============================',13,10,10,'$'

system_info db 13,10,'System Type: Omege DOS-like System',13,10
            db 'Shell Version: 0.1.0',13,10
            db 'Memory: Conventional DOS',13,10
            db 'Display: Text Mode 80x25',13,10
            db 'Input: Keyboard Only',13,10,'$'

prompt db 13,10,'C:\OMEGE> $'

help_text db 'Available commands:',13,10
          db 'H or ? - Show help',13,10
          db 'V      - Show version',13,10
          db 'I      - System information',13,10
          db 'C      - Clear screen',13,10
          db 'D      - List files',13,10
          db 'T      - Show time',13,10
          db 'E or Q - Exit to DOS',13,10,10,'$'

dir_text db 'Directory of C:\OMEGE',13,10
         db 'BOOT    BIN     512',13,10
         db 'KERNEL  BIN    4096',13,10
         db 'SHELL   COM    2048',13,10
         db 'CONFIG  SYS      50',13,10
         db 'AUTOEXEC BAT      45',13,10,10,'$'

time_msg db 'Current time: $'

exit_msg db 'Returning to DOS...',13,10,'$'

unknown db 'Bad command or file name',13,10,'$'

press_any_key db 13,10,'Press any key to continue... $'

section .bss

buffer resb 256       ; 输入缓冲区
