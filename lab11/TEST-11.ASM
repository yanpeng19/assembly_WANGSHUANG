
assume cs:code

data segment
    db "Beginner's All-purpose Symbolic Instruction Code",0
data ends

code segment

start:  mov ax,data
		mov ds,ax
		mov si,0
		mov bx,0
		call letterc

		mov ax,4c00h
		int 21h

letterc:
		mov al,[si]
		mov ah,0
		mov cx,ax
		jcxz l_end

		; al will in a~z

		cmp al,97
		jb next
		
		cmp al,122
		ja next

		and al,11011111b
		mov [si],al

next:   inc si
		jmp letterc

l_end:    ret


code ends
end start
