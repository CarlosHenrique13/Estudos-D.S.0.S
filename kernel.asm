%INCLUDE "Hardware/memory.lib"
[BITS SYSTEM]
[ORG KERNEL]

jmp OSMain

; _____________________________________________
; Directives and Inclusions ___________________

%INCLUDE "Hardware/monitor.lib"
%INCLUDE "Hardware/disk.lib"
%INCLUDE "Hardware/win16.lib"
%INCLUDE "Hardware/win3dmov.lib"
;%INCLUDE "Hardware/keyboard.lib"
;%INCLUDE "Hardware/fontswriter.lib"

; _____________________________________________


; _____________________________________________
; Starting the System _________________________

OSMain:
    call ConfigSegment
	call ConfigStack
	call VGA.SetVideoMode
	call DrawBackground
	call EffectInit
	;call DriversInstall ;alt
	;jmp GraficInterface
	jmp WaitPress
	
WaitPress:
	in al, 0x64
	and al, 0x01
	jz WaitPress
	in al, 0x60
	mov ah, 0x0E
	int 0x10
	jmp WaitPress

; _____________________________________________
	
; _____________________________________________
; Kernel Functions ____________________________

;SystemKernel: ;alt
;	call KEYBOARD_HANDLER
;jmp SystemKernel

;DriversInstall:
;	__Keyboard_Driver_Load 0x0800, 0x1400
;	call KEYBOARD_INSTALL
;	__Fonts_Writer_Load 0x0800, 0x1600
;ret

GraficInterface:
	__LoadInterface
	
	mov word[PositionX], 100
	mov word[PositionY], 10
	mov word[W_Width], 120
	mov word[W_Height], 120
	mov cx, _WALL
	
Start:
	WallPaper cx, SCREEN_WIDTH, SCREEN_HEIGHT, 40, 20
	Window3D MOVABLE, word[PositionX], word[PositionY], word[W_Width], word[W_Height]
cmp al, 2
je Start

jmp END

ConfigSegment:
	mov ax, es
	mov ds, ax
ret

ConfigStack:
	mov ax, 7D00h
	mov ss, ax
	mov sp, 3000h
ret

END:
	mov ax, 0040h
	mov ds, ax
	mov ax, 1234h
	mov [0072h], ax
	jmp 0FFFFh:0000h
; _____________________________________________

