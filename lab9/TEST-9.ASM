assume cs:codesg

data segment

     db 'welcome to masm!0000'   

data ends

codesg segment

    start:mov ax,0B800h
          add ax,160         ; begin on line 10
                                                    
          mov ds,ax
          mov bx,0
                                                       
          mov ax,data
          mov ss,ax
          mov bp,0

          mov si,0
          mov dh,0

          mov cx,3

          mov dl,2
          loop s

        f:mov cx,2
          mov bx,160
          mov di,0
          mov si,0
          mov dl,00100100b
          loop s

        g:mov cx,1
          mov bx,320
          mov di,0
          mov si,0
          mov dl,01110001B
          loop s
         
       s: mov ax,cx
          mov ss:[16],ax
          mov cx,16

       s0:mov al,[bp+di]
          mov ah,dl
          mov [bx+si],ax

          add si,2
          add di,1

          loop s0

          mov cx,ss:[16]
          
          jcxz e

          sub cx,1
          jcxz g

          sub cx,1
          jcxz f

       e: mov ax,4c00h
          int 21h


codesg ends
end start
