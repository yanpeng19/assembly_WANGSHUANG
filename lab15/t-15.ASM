
assume cs:code

stack segment
		db 128 dup (0)
stack ends

data segment
	db 0,0
data ends

code segment
start:

		mov ax,stack
		mov ss,ax
		mov sp,128

		mov ax,0
		mov es,ax

		push word ptr es:[4*9]
		pop word ptr es:[200h]
		push word ptr es:[4*9+2]
		pop word ptr es:[202h]           ; 9号中断已备份

		mov ax,cs
		mov ds,ax
		mov cx,offset i_9_a_e - offset int_9_a
		mov si,offset int_9_a
		mov di,204h
		cld 
		rep movsb
		mov ax,0

		mov ax,0
		mov es,ax

		cli
		mov word ptr es:[4*9],204h       ; 9号中断指向 0：204h
		mov word ptr es:[4*9+2],0        ; 0：204h 内容为 int_9
		sti


		mov ax,0b800h
		mov es,ax
		mov di,160*12+30*2

		mov ah,'a'
		

	  s:mov es:[di],ah
		call delay
		inc ah
		cmp ah,'z'
		jna s

		mov ax,0
		mov es,ax

		push es:[200h]
		pop es:[4*9]
		push es:[202h]
		pop es:[4*9+2]

		mov ax,4c00h
		int 21h

delay:  push ax
		push cx
		mov ax,0
		mov cx,4

	d_s:sub ax,1
		cmp ax,0
		jne d_s

		loop d_s
		
		pop cx
		pop ax
		ret
		
int_9_esc:
		push ax
		push es
		push bx

		in al,60h

		pushf
		call dword ptr cs:[200h]

		cmp al,1
		jne int_9_esc_end

		mov ax,0b800h
		mov es,ax
		inc byte ptr es:[160*12+30*2+1]

int_9_esc_end:
		pop bx
		pop es
		pop ax
		iret  
		
i_9_esc_e:  nop

;松开A则出现全屏的A字母
int_9_a:
		push ax
		push es
		push bx
		push dx
		push di

		mov ax,data
		mov ds,ax

		in al,60h

		pushf
		call dword ptr cs:[200h]

		; if(al='A') ds[0]='A'
		; else return

		mov bx,ds:[0]
		cmp al,1Eh
		je int_9_a_set

		;else if(al-80h == 'A')
		sub al,80h
		cmp al,1Eh
		jne int_9_a_end

		mov ax,0b800h
		mov ds,ax
		mov cx,2000
		mov di,0

	 do:mov byte ptr ds:[di],'A'
	    add di,2
		loop do

		mov ax,4c00h
		int 21h

int_9_a_set:
		mov word ptr ds:[0],1Eh

int_9_a_end:
		pop di
		pop dx
		pop bx
		pop es
		pop ax
		iret  

i_9_a_e:nop
		

code ends
end start
