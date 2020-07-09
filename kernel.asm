[BITS 16]
[ORG 0000h]

jmp OSMain

; ___________________________________________
;Directives and inclusions___________________

%INCLUDE "Hardware/wmemory.lib"
%INCLUDE "Hardware/monitor.lib"
%INCLUDE "Hardware/disk.lib"

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
	mov byte[Window_Bar], 1
	mov word[Window_PositionX], 5
	mov word[Window_PositionY], 5
	mov word[Window_Width], 100
	mov word[Window_Height], 150
	mov byte[Window_Border_Color], 21
	mov byte[Window_Bar_Color], 16
	mov byte[Window_back_Color], 55
	mov byte[Sector], 3
	mov byte[Drive], 80h
	mov byte[NumSectors], 1
	mov word[SegmentAddr], 0800h
	mov word[OffsetAddr],  0500h
	call ReadDisk
	call WindowAddres
	mov byte[Window_Bar], 0
	mov word[Window_PositionX], 110
	mov word[Window_PositionY], 5
	mov word[Window_Width], 50
	mov word[Window_Height], 50
	mov byte[Window_Border_Color], 30
	mov byte[Window_back_Color], 60
	call WindowAddres
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
