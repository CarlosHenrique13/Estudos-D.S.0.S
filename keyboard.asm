%INCLUDE "Hardware/memory.lib"
[BITS SYSTEM]
[ORG KEYBOARD]

jmp Keyboard_Initialize
jmp Keyboard_Handler_Main

%INCLUDE "Hardware/keyboard.lib"
%INCLUDE "Hardware/iodevice.lib"


Keyboard_Initialize:
	mov si, DriverCommands
	dec si
	WriteNext:
		xor cx, cx
		inc si 
		mov bl, [si]
		cmp bl, '$'
		je EndInitialize
	WriteCommand:
		_WritePort KEYBOARD_STATUS, bl 
		inc cx 
	waitResponse:
		_ReadPort KEYBOARD_DATA
		cmp cx, 3
		je WriteNext
		cmp al, RESEND
		je WriteCommand
		cmp al, ACK
		je Success
		
Success:
	mov ah, 0eh
	mov al, 'd'
	int 10h
	jmp WriteNext
EndInitialize:
	ret

Keyboard_Handler_Main:

ret



