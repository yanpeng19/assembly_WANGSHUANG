
assume cs:code

data segment
	db "welecome to masm!",0
data ends

code segment
start:
		call install_7c

		mov ax,0B800h
		mov es,ax
		mov di,160*12

		mov cx,80
		mov bx,offset s-offset se

s:      mov byte ptr es:[di],'!'
		add di,2
		int 7ch

se:		nop
		mov ax,4c00h
		int 21h


;copy 7c to 0:200h
install_7c:
		
		mov ax,0
		mov es,ax

		mov word ptr es:[7ch*4],200h
		mov word ptr es:[7ch*4+2],0

		mov si,offset do_7c
		mov ax,cs
		mov ds,ax

		mov ax,0
		mov es,ax
		mov ax,0200h
		mov di,ax

		mov cx,offset do_7c_end-offset do_7c

		cld
		rep movsb 

		ret
		
do_7c:
		push bp
		mov bp,sp

		jcxz do_7c_e

do_7c_s:add [bp+2],bx
		dec cx
		
do_7c_e:
		pop bp
		iret

do_7c_end:
		nop


code ends
end start
