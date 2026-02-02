# 关于 Omege System 0.1
Omege System 0.1 是一个像 Microsoft Disk Operating System 的操作系统，是 Omege System 内部测试版，没有图形界面，是 Command-Line
内核基于 Microsoft Disk Operating System
应用程序可直接打开.COM和.EXE结尾的，可在裸机打开.BIN（二进制）
# 关于 Setup
此 Setup 为 I386 启动，类似于 Microsoft Windows 1.0.1 安装程序，安装的是一个差不多像 Microsoft Disk Operating System，把版权改成 Copyright (c) 2023-2024 Deep Learning Corp.了，后期版权是 (c) Deep Learning Corporation. All rights reserved.
此 Setup 会将 Omege System 0.1 安装到 C:\OMEGE 目录（默认）
# 硬件要求
此操作系统硬件要求极低，需要配备 1MB RAM，储存空间需要 10MB 左右，CPU 需要 1MHz，显示卡随便一个就行
# 关于此代码
此代码由 2024/11/17 Lucas 编写，2026/02/01 由 Lucas 在 GitHub 公开发布源代码
此代码最后更新：2025/11/14，最后更改 Bug：2025/9/27，最后发布：2025/11/14
# 编译
可使用 Netwide Assembler(NASM) 编译，不可使用 MASM（ml.exe），因为 NASM 与 MASM 语法有差异。
NASM 下载：https://www.nasm.us/pub/nasm/releasebuilds/3.01rc9/win64/nasm-3.01rc9-installer-x64.exe （NASM 3.01RC9），将 NASM 安装到 H:\Netwide Assembler，没有 H 盘的可以把脚本里的NASM Path改一下
# Boot Manager 负责
运行 BUILD.BAT 后会生成编译后的文件，其中安装程序由 INSTALL.COM 负责，Boot Manager 由 BOOT.BIN 负责，内核则由 KERNEL.COM 与 KERNEL.BIN 负责

Copyright (c) 2023-2024 Deep Learning Corp.
