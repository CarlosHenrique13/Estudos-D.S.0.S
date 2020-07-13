[BITS 16]
[ORG 0000h]

jmp OSMain

; ___________________________________________
;Directives and inclusions___________________

%INCLUDE "Hardware/monitor.lib"
%INCLUDE "Hardware/disk.lib"
%INCLUDE "Hardware/wmemory.lib"
%INCLUDE "Hardware/win16.lib"

; ___________________________________________


; ___________________________________________
; Starting the System________________________

OSMain:
	call ConfigSegment
	call CnfigStack
	call VGA.SetVideoMode
	call DrawBackground
	call EffectInit
	call GraficInterface
	jmp END


; ___________________________________________

; ___________________________________________
; Kernel Functions___________________________

GraficInterface:
	__LoadInterface 
	
	__CreateWindow 1,1,1,1,16,28,53,5,10,200,150
	__ShowWindow 1
	__CreateField Text1, 0, 55, 30, 55, 60, 100, 8
	__ShowField 1
	__CreateField Text2, 0, 55, 30, 55, 72, 100, 8
	__ShowField 1
	__CreateField Text3, 0, 55, 30, 55, 84, 100, 8
	__ShowField 1
	__CreateButton Button1, "Entrar", 55, 55, 90, 98, 25, 8
	__ShowButton 1
ret

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
	mov ah, 00h
	int 16h
	mov ax, 0040h
	mov ds, ax
	mov ax, 1234h
	mov [0072h], ax
	jmp 0FFFFh:0000h
; ___________________________________________
