%INCLUDE "Hardware\memory.lib"
[BITS SYSTEM]
[ORG FONTSWRITER]

cmp bx, 1
je ProcChars
jmp Return

%INCLUDE "Hardware\win16.lib"
%INCLUDE "Hardware\keyboard.lib"
%INCLUDE "Hardware\fontswriter.lib"
%INCLUDE "Hardware\fonts.lib"

ProcChars:
	cmp al, K_TAB
	je TextPositions
	cmp al, K_ESC
	je ChangeCursor
	cmp byte[CursoFocus], 1
	jne Return
	cmp byte[CursorTab], 1
	jne Return
	xor ah, ah
	xor dx, dx
	push ax
	mov si, Chars
	xor bx, bx
	mov bx, 26 ;bytes da font (5 x 5) + 1 bite de finalização  
	mul bx 
	sub ax, bx
	add si, ax
	xor bx, bx
	xor ax, ax
	mov bl, [si]
	pop ax 
	cmp al, K_BACKSPACE
	je Erase
show:
	call PrintChar
	jmp Return
Erase:
	calll EraseChar
	jmp Return
Return:
	ret
	