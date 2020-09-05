echo off
cls

echo Monntando o arquivo "Bootloader"
nasm -f bin bootloader.asm -o Binary/bootloader.bin

echo Montando o arquivo "Kernei"
nasm -f bin kernel.asm -o Binary/kernel.bin

echo Montando o arquivo "Window"
nasm -f bin window.asm -o Binary/window.bin

echo Montando o arquivo "Keyboard"
nasm -f bin keyboard.asm -o Driver/keyboard.sys

pause
