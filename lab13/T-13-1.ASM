
assume cs:code

data segment
	db "welecome to masm!",0
data ends

code segment
start:
		call install_7c

		mov dh,10
		mov dl,10
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0

		int 7ch

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
		push ax
		push dx
		push cx
		push di
		push si
		push es

		mov di,0
		mov ax,160
		mul dh
		add di,ax

		mov ax,2
		mul dl
		add di,ax

		mov bx,0
		
		mov ax,0B800H
		mov es,ax

		mov ah,cl

do_7c_s:	
		mov ch,0
		mov cl,[si]
		jcxz do_7c_e

		mov al,[si]
		mov es:[di],ax

		inc si
		add di,2
		jmp do_7c_s
		
do_7c_e:
		pop es
		pop si
	    pop di
	    pop cx
		pop dx
		pop ax
		iret
do_7c_end:
		nop


code ends
end start
