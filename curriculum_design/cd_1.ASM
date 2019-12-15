
assume cs:codesg

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,8035300,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2256,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

cache segment
	db 16 dup (0)
cache ends

codesg segment

start:
	
	mov ax,table
	mov ds,ax         ; ds[] = table

	call get_data

	mov ax,cache      ; 获得数据之后 栈 ss 指向了 chache
	mov ss,ax
	mov sp,32
	mov bp,0

	mov dl,0          ; outtable(line,column)
	mov dh,5
	mov ch,2
	mov bx,0

	call out_table     ; -g 1c
	add sp,2           ; 释放掉参数

	mov ax,4c00h
    int 21h


out_table:
	mov al,dh
	mov ah,0
	mov si,160
	mul si              ; ax = ax*160
	add bx,ax

	mov ah,0
	mov al,dl
	add ax,ax
	add bx,ax           ; 计算输出位置

	mov cx,22           ; 

out_table_start:	    ; 到此bx 位置已经计算完毕
	
    jcxz out_table_end  

	push bx
	call show_line_ptr  ; g 40

	sub cx,1       ;g 43
	pop bx
	add bx,160          
	add bp,1
	jmp out_table_start

out_table_end:
	ret
	  

show_line_ptr: 

		push cx
        
		mov ax,5
        call cout_byte ; 写ax个字符  g 55

		call cout_ddword ; g 58

		mov ax,1
        call cout_byte ;   g 5e

        call cout_dword ;

		mov ax,1
        call cout_byte ; 

		call cout_dword ;
		 
show_line_end:
		pop cx
        ret 


; ax = data low 16 byte
; dx = data high 16 byte                      
; cx = divisor                                                                                                                              
; resault :
; dx = resault high 16 byte
; ax = resault low 16 byte
; cx = remainder

cout_ddword:
	   mov ax,table
	   mov ds,ax
	   mov ax,ds:[bp]
	   add bp,2
	   mov dx,ds:[bp]
	   add bp,2
	   mov si,0

 divdw:                                         
       ;cx 16 byte , so use dx*65536+ax / cx
       ;and resault save in ax,remainder in dx
	   
	   mov cx,ax   ;-g 85
	   jcxz end_1
	   jmp divdw_c

end_1: mov cx,dx
	   jcxz c_dd_write
	   

divdw_c:
       push ax
       mov ax,dx
       mov dx,0
	   mov cx,10
       div cx

	   ;keep dx
       mov di,ax  ;high 16 btye resault save in di
       pop ax
       div cx     ;low 16 byte resault
       mov cx,dx
       mov dx,di
	   push cx
	   inc si

	   jmp divdw



c_dd_write:
	   
	   mov cx,si
	   mov ax,0B800h
	   mov ds,ax
c_dd_s:
       jcxz c_dd_e
	   pop ax      ; g b1
	   mov ah,02h
	   add al,30h

	   mov [bx],ax
	   add bx,2
	   loop c_dd_s
c_dd_e:
	   ret
		
cout_byte:     
		mov cx,ax

cout_byte_s:
		mov ax,table
		mov ds,ax
        mov al,ds:[bp]
		mov ah,02h

		mov si,0b800h
		mov ds,si
		mov [bx],ax

		add bx,2
		inc bp

		loop cout_byte_s
		ret

cout_dword:       ; cout_byte( word *from_where,word n,word into_wehre,word m,word size)   ; 从data向 ds:bx 写入size个数据,宽度默认为10
                 ; 不够使用空格填充
				 ; bx = bx;
				 ; n_size 为字符串长度
				 ; bx += 5*2
				 ; 输出空格 bx--;
				 ; if(bx==n_size*2)
				 ; cx = n_size;
				 ; 倒着输出
dword_begin:
		
		mov ax,table
		mov ds,ax
		mov ax,ds:[bp] ; -g 
		add bp,2       

		mov si,0b800h
		mov ds,si

		mov dx,0
		mov si,0


get_size:
		mov cx,ax           ; 
		jcxz get_size_end   ; 
		mov cx,10
		div cx
		push dx
		mov dx,0
		inc si
		jmp get_size

get_size_end:
		;si 是字符串长度
		; 字符串内容存储在 栈中
		; ds为输出位置

		 
		mov cx,si           ; -g 11b
  write:jcxz write_end  
		pop ax       ; g 11d
		add al,30h
		mov ah,02
		mov [bx],ax  ;
		add bx,2

		loop write
		
write_end:
		
		ret     ;-g 132


get_data:         ;take data into table
	
	push ss
	push ax
	push cx

    mov cx,21

    mov ax,data
    mov ss,ax     ; ss[] = data
    mov bx,0
    mov di,0
    mov bp,0
    mov si,0

  s:

    mov ax,[bp]
    mov [bx],ax
    mov ax,[bp+2]
    mov [bx+2],ax

    mov ax,[bp+84]
    mov [bx+5],ax
    mov ax,[bp+86]
    mov [bx+7],ax                                                                                                                                                                                           

    mov ax,ss:[si+168]
    mov [bx+10],ax

    mov di,ax

    mov ax,[bx+5]
    mov dx,[bx+7]
             
    div di

    mov [bx+13],ax

    add bx,16
    add bp,4
    add si,2

    loop s

	pop cx
	pop ax
	pop ss        ;ss = default
	ret
  

   
codesg ends

end start


