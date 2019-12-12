;this test is about 10_2 'overflow in div'
;fuction divdw

; ax = data low 16 byte
; dx = data high 16 byte                      
; cx = divisor                                                                                                                              
; resault :
; dx = resault high 16 byte
; ax = resault low 16 byte
; cx = remainder

assume cs:code

code segment

start: mov ax,1000h
       mov dx,1000h

       mov cx,2
       call divdw
   
       mov ax,4c00h
       int 21h

 divdw:                                         
       ;cx 16 byte , so use dx*65536+ax / cx
       ;and resault save in ax,remainder in dx
       push ax
       mov ax,dx
       mov dx,0
       div cx

	   ;keep dx
       mov di,ax  ;high 16 btye resault save in di
       pop ax
       div cx     ;low 16 byte resault
       mov cx,dx
       mov dx,di

       ret
code ends
end start
