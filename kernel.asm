[BITS 16]
[ORG 0000h]

jmp OSMain

; ___________________________________________
;Directives and inclusions___________________

%INCLUDE "Hardware/monitor.lib"
%INCLUDE "Hardware/disk.lib"
%INCLUDE "Hardware/wmemory.lib"
%INCLUDE "Hardware/win16.lib"
%INCLUDE "Hardware/win3dmov.lib"

; ___________________________________________


; ___________________________________________
; Starting the System________________________

OSMain:
	call ConfigSegment
	call CnfigStack
	call VGA.SetVideoMode
	call DrawBackground
	call EffectInit
	jmp GraficInterface
	jmp END

; ___________________________________________

; ___________________________________________
; Kernel Functions___________________________

GraficInterface:
	__LoadInterface 
	
	mov word[PositionX], 8
	mov word[PositionY], 8
	mov word[W_Width], 100
	mov word[W_Height], 100
	
	ChangeToWall:
		mov cx, _WALL
		jmp Start
	ChangeToIron:
		mov cx, _IRON
		
Start:
	WallPaper cx, SCREEN_WIDTH, SCREEN_HEIGHT, 40, 20
	Window3D MOVABLE, word[PositionX], word[PositionY], word[W_Width], word[W_Height]
	
	
jmp END

ConfigSegment:
	mov ax, es
	mov ds, ax 
ret

CnfigStack:
	mov ax, 7D00h
	mov ss, ax
	mov sp, 03FEh
ret

END: 
	mov ax, 0040h
	mov ds, ax
	mov ax, 1234h
	mov [0072h], ax
	jmp 0FFFFh:0000h
; ___________________________________________
