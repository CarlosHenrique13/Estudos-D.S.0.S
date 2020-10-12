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
	cmp al, K_ENTER
	je Return
	cmp al, K_CTRLLEFT
	je Return
	cmp al, K_SHIFTLEFT
	je Return
	cmp al, K_SHIFTRIGHT
	je Return
	cmp al, K_ALT
	je Return
	cmp al, CAPSLOCK
	je Return
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
	
ChangeCursor:
	;call CURSO_HANDLER
	cmp byte[CursoFocus], 1
	je Change
	mov byte[CursoFocus], 1
	jmp Return
Change:
	mov byte[CursoFocus], 0
	jmp Return
	
TextPositions:
	cmp byte[Window_Exist], 1
	jne Return
	cmp byte[Field_Exist], 1
	jne Return
	;call CURSO_HANDLER
	inc byte[QuantTab]
	mov bl, byte[QuantTab]
	mov al, byte[QUANT_FIELD]
	cmp bl, al
	jbe  ProcPositions
	mov word[QuantPos], 0000h
	mov byte[QuantTab], 1
	mov byte[CountField], -1
ProcPositions:
	xor ax, ax
	xor bx, bx
	mov bx, word[QuantPos]
	mov ax, word[POSITIONS + bx] ; array[]
	mov word[POSITION_X], ax
	add word[QuantPos], 2
	mov bx, word[QuantPos]
	mov ax, word[POSITIONS + bx]
	add ax, 2
	mov word[POSITION_Y], ax
	add word[QuantPos], 2
	mov bx, word[QuantPos]
	mov ax, word [POSITIONS + bx]
	mov word[LIMIT_COLW], ax
	add word[QuantPos], 2
	mov bx, word[QuantPos]
	mov ax, word[POSITIONS + bx]
	mov word[LIMIT_COLX], ax
	add word[QuantPos], 2
	mov bx, word[QuantPos]
	mov di, word[POSITIONS + bx]
	mov ax, word[ds:di]
	mov word[QUANT_KEY], ax
	add word[QuantPos], 2
	mov bx, word[QuantPos]
	mov ax, word[POSITIONS + bx]
	mov word[C_ADDR], ax
	add word[QuantPos], 2
	inc byte[CountField]
	xor ax, ax
	xor bx, bx
	mov byte[CursorTab], 1
	jmp Return
	
PrintChar:
	push ax
	call CURSO_HANDLER
	mov cx, word[POSITION_X]
	mov dx, word[POSITION_Y]
	call VerifyLimitColW
	cmp bytr[StatusLimitW], 1
	je RetPrintChar
	
	; próxim código

RetPrintChar:
	ret	

EraseChar:
	;call CURSO_HANDLER
	mov cx, word[POSITION_X]
	mov dx, word[POSITION_Y]
	call VerifyLimitColX
	cmp byte[StatusLimitX], 1
	je RetEraseChar
	
	; próximo cvódigo
	
RetEraseChar:
	ret
		
VerifyLimitColW:
	cmp cx, word[LIMIT_COLW]
	jb RetVerifyW
	mov byte[StatusLimitW], 1
RetVerifyW:
	mov byte[StatusLimitW], 0
ret

VerifyLimitColX:
	cmp cx, word[LIMIT_COLX]
	ja RetVerifyX
	mov byte[StatusLimitX], 1
RetVerifyX:
	mov byte[StatusLimitX], 0
ret

Return:
	ret
	