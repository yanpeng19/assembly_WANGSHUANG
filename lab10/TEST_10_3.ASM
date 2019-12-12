assume cs:code

stack segment

      db 256 dup (0)

stack ends

data segment
    db 10 dup (0)
data ends

code segment

start: mov ax,12666 ; we will cout 12666
       mov bx,data
       mov ds,bx    ; ds is data[]
       mov si,0
       mov bx,stack
       mov sp,256

       call dtoc

       mov ax,4c00h
       int 21h
       
  dtoc:
         ;first take ax every number into data
         ;second call fuc show str
         call get_bx       ; to konw how long is the 'ax'
         call get_data
         call show_ptr
         ret

get_bx:  push si
         push ax
         push cx
         push dx
         mov si,10
         mov bx,0
get_bx_s:
         mov cx,ax
         jcxz get_bx_end
         mov dx,0
         div si
         inc bx
         jmp get_bx_s

get_bx_end:
         pop dx
         pop cx
         pop ax
         pop si
         ret 


get_data:
        ;this fuc will take ax every number in data in action
         push ax
         push cx
         push dx
         push di
         push si

         mov si,10

 get_s:  mov cx,bx
         jcxz get_end                 ; if(ax==0) return
         mov dx,0

         div si                        ; ax = ax/10 dx = remainder

         add dx,30h                     ; dx = dx+30h
         mov byte ptr [bx-1],dl          ; data is inversion about 'ax' 
         sub bx,1
         jmp get_s


get_end: pop si
         pop di
         pop dx
         pop cx
         pop ax
         ret

show_ptr:
         push ax
         push bx
         push cx
         push dx
         push di
         push si

         mov dh,8       ; line
         mov dl,3       ; column
         mov cl,2       ; coloer     
         mov ax,data
         mov ds,ax
         mov si,0
         call show

         pop si
         pop di
         pop dx
         pop cx
         pop bx
         pop ax
         ret


show:
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
