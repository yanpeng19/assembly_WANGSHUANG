assume cs:code

code segment
	
start:
	mov ah,3
	call setscreen

	mov ax,4c00h
	int 21h

setscreen:
		cmp ah,0
		je fun_0

		cmp ah,1
		je fun_1

		cmp ah,2
		je fun_2

		cmp ah,3
		je fun_3

		ret

;清屏
fun_0:
		push bx
		push cx
		push es
		push di

		mov bx,0b800h
		mov es,bx

		mov cx,2000
		mov di,0

fun_0_s:
		jcxz fun_0_end
		mov byte ptr es:[di],' '
		add di,2
		loop fun_0_s

fun_0_end:
		pop di
		pop es
		pop cx
		pop bx
		ret


;设置前景色
fun_1:
		push bx
		push cx
		push es
		push di

		mov bx,0B800h
		mov es,bx

		mov cx,2000
		mov di,1

		mov bl,1

fun_1_s:
		jcxz fun_1_end
		and byte ptr es:[di],11111000b
		or byte ptr es:[di],1
		add di,2
		loop fun_1_s

fun_1_end:
		pop di
		pop es
		pop cx
		pop bx
		ret

;设置背景色
fun_2:
		push bx
		push cx
		push es
		push di

		mov bx,0B800h
		mov es,bx

		mov cx,2000
		mov di,1

fun_2_s:
		jcxz fun_2_end
		and byte ptr es:[di],10001111b
		or byte ptr es:[di],dl

		add di,2
		loop fun_2_s

fun_2_end:
		pop di
		pop es
		pop cx
		pop bx
		ret



;退回一行
fun_3:
		push ax
		push bx
		push es
		push ds
		push di
		push si

		mov ax,0B800h
		mov es,ax

		mov si,160
		mov di,0

		mov cx,2000-160

copy_s:
		jcxz fun_3_s
		mov al,es:[si]
		mov es:[di],al

		add di,2
		add si,2

		loop copy_s

		mov cx,160
		jmp fun_3_s

fun_3_s:
		jcxz fun_3_end
		mov byte ptr ds:[di],' '
		add di,2
		loop fun_3_s

fun_3_end:
		pop si
		pop di
		pop ds
		pop es
		pop bx
		pop ax
		ret
 
code ends
end start
