[BITS 16]
[ORG 0500h]



pusha
	call DefineWindow
popa
	jmp ReturnKernel
	
; =====================================
; Inclusion Files

%INCLUDE "Hardware/wmemory.lib"

; =====================================	
	
DefineWindow:
	mov ah, 0Ch
	mov al, byte[Window_Border_Color] 
	mov cx, word[Window_PositionX]
	mov dx, word[Window_PositionY]
	cmp byte[Window_Bar], 0
	je WindowNoBar
	jmp WindowsWithBar

WindowNoBar:
	mov bx, word[Window_Width]
	add bx, cx
	LineUp:
		int 10h
		inc cx
		cmp cx, bx
		jne LineUp
		call BordeRightDown
		mov bx, word[Window_PositionY]
	LineLeft:
		int 10h
		dec dx
		cmp dx, bx
		jne LineLeft
		call BackColor
		jmp Rets
		
WindowsWithBar:
	mov al, byte[Window_Bar_Color]
	mov bx, word[Window_Width]
	add bx, cx 
	push ax
	mov ax, dx
	add ax, 9
	mov [StateWindowBar], ax
	pop ax
	PrintBar:
		int 10h
		inc cx
		cmp cx, bx
		jne PrintBar
		int 10h
		inc dx
		inc al
		cmp dx, word[StateWindowBar]
		jne BackColumn
		mov al, byte[Window_Border_Color]
		call BordeRightDown
		mov bx, word[Window_PositionY]
		add bx, 8
		LineLeftBar:
			int 10h
			dec dx
			cmp dx, bx
			jne LineLeftBar
			call BackColor
			;call ButtonsBar
			jmp Rets
	BackColumn:
		mov cx, word[Window_PositionX]
		mov bx, word[Window_Width]
		add bx, cx
		push bx
		mov bx, word[StateWindowBar]
		sub bx, 6
		cmp dx, bx
		ja IncColorAgain
		pop bx
		jmp PrintBar
	IncColorAgain:
		pop bx
		inc al
		jmp PrintBar
	
BordeRightDown:
	mov bx, word[Window_Height]
	add bx, dx
	LineRight:
		int 10h
		inc dx
		cmp dx, bx
		jne LineRight
		mov bx, word [Window_PositionX]
	LineDown:
		int 10h
		dec cx
		cmp cx, bx
		jne LineDown
ret	

BackColor:
	mov al, byte[Window_back_Color]
	mov cx, word[Window_PositionX]
	mov dx, word[Window_PositionY]
	cmp byte[Window_Bar], 1
	je WithBar
	jmp NoBar
WithBar:
	add dx, 9
	mov word[BackInitialPositionY], dx
	add word[BackInitialPositionY], 1
	jmp Salt
NoBar:
	inc dx
	mov word[BackInitialPositionY], dx
Salt:
	inc cx 
	mov word[BackInitialPositionX], cx
Initial:
	mov cx, word[BackInitialPositionX]
	mov bx, word[Window_Width]
	add bx, cx
	sub bx, 1
Columns:
	int 10h
	inc cx
	cmp cx, bx
	jne Columns
	mov bx, word[Window_Height]
	add bx, word[BackInitialPositionY]
	sub bx, 1
Rows:
	inc dx
	cmp dx, bx
	jne Initial
ret
	
Rets:
	ret	

ReturnKernel:
	ret
