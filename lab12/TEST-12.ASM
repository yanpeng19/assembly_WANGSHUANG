;写入0号中断
;写入位置 0：200h

assume cs:code

code segment

start:
		mov ax,0
		mov es,ax
		mov di,200h

		mov ax,cs
		mov ds,ax
		mov ax,offset do0
		mov si,ax

		mov cx,offset do0_end-offset do0

		cld
		rep	movsb

		mov bx,0
		mov ax,0
		mov ds,ax
		mov [bx+2],bx
		mov ax,0200h
		mov [bx],ax

		mov ax,1000h
		mov bl,1

		div bl   ; g2c

		mov ax,4c00h
		int 21h

do0:
		jmp short begin_0  ; 2 btye   
		db "overflow!"    ; do0+2

begin_0:
		mov ax,cs
		mov ds,ax
		mov si,202h

		mov ax,0B800h
		mov es,ax
		mov di,12*160+36*2

		mov cx,9

begin_s:
		mov al,[si]
		mov es:[di],al

		inc si
		add di,2
		loop begin_s
		
		mov ax,4c00h
		int 21h

do0_end:nop

code ends
end start
