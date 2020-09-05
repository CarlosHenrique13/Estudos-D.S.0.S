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
		__WritePort KEYBOARD_STATUS, bl 
		inc cx 
	waitResponse:
		__ReadPort KEYBOARD_DATA
		cmp cx, 3
		je WriteNext
		cmp al, RESEND
		je WriteCommand
		cmp al, ACK
		je WriteNext
EndInitialize:
	ret

Keyboard_Handler_Main:

ret



