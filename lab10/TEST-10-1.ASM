
assume cs:code

data segment
    db 'Welcome to masm!',0
data ends

code segment

start:  mov dh,8       ; line
        mov dl,3       ; column
        mov cl,2       ; coloer     
        mov ax,data
        mov ds,ax
        mov si,0
        call show_str

        mov ax,4c00h
        int 21h

show_str:
        push ax
        push bx
        push cx
        push si
        push di

        mov ax,160
        mul dh
        add si,ax
        mov ah,0
        mov al,dl
        add al,al
        add si,ax
        mov ch,cl

      s:
        mov ah,ch
        mov cx,[bx]
        mov ch,0
        jcxz e
        mov ch,ah

        mov ax,0B800h
        mov ds,ax
        mov di,bx
        mov bx,0
        mov [bx+si],cx
        mov bx,di
        mov ax,data
        mov ds,ax

        inc bx
        add si,2
        jmp s

    e:
        pop di
        pop si
        pop cx
        pop bx
        pop ax
        ret 

code ends
end start
