;print y/m/d t/m 

assume cs:code
code segment
		mov di,160*12
		mov ax,0b800h
		mov es,ax

		mov al,9

		out 70h,al
		in al,71h
		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

		mov bl,'/'
		mov byte ptr es:[di],bl
		add di,2

		;month
		mov al,8
		out 70h,al
		in al,71h

		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

		mov bl,'/'
		mov byte ptr es:[di],bl
		add di,2

		;day 
		mov al,7
		out 70h,al
		in al,71h

		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

		mov bl,' '
		mov byte ptr es:[di],bl
		add di,2

		;hour
		mov al,4
		out 70h,al
		in al,71h

		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

		mov bl,':'
		mov byte ptr es:[di],bl
		add di,2

		;minuut
		mov al,2
		out 70h,al
		in al,71h

		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

		mov bl,':'
		mov byte ptr es:[di],bl
		add di,2

		;second
		mov al,0
		out 70h,al
		in al,71h

		mov ah,al
		mov cl,4
		and al,00001111b
		shr ah,cl

		add ah,30h
		add al,30h

		mov byte ptr es:[di],ah
		add di,2
		mov byte ptr es:[di],al
		add di,2

	
		mov ax,4c00h
		int 21h


code ends
end
