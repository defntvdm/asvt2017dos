	.model 	tiny
	.code
	org 	100h
M:
	mov 	ah, 09h
	mov 	dx, offset msg
	int 	21h
	xor 	cx, cx
	xor 	ax, ax
	mov 	es, ax
	push 	es:[9h*4]
	push 	es:[9h*4+2]
	mov 	es:[9h*4], offset lala
	mov 	es:[9h*4+2], ds
	pop 	es
	pop 	bx
	mov 	word ptr old_vect, bx
	mov 	word ptr old_vect + 2, es
	jmp 	start
	msg 	db 	'Выход по ESC (напечает его ASCII-код и выйдет)', 13, 10, 24h
lala proc
	pushf
	call 	dword ptr old_vect
	in  	al, 60h
	test 	al, 10000000b
	jnz  	unpressed
	mov 	cl, byte ptr was_pressed
	cmp 	cl, 0
	mov 	cl, 1
	mov 	byte ptr was_pressed, cl
	je  	shprnt
	mov 	cl, 0
	mov 	byte ptr should_prnt, cl
	iret
	
	shprnt:
		mov 	cl, 1
		mov 	byte ptr should_prnt, cl
		iret
	unpressed:
		mov 	al, 0
		mov 	byte ptr should_prnt, al
		mov 	byte ptr was_pressed, al
		iret
	old_vect 	dd 	?
lala endp
start:
	mov 	ah, 0
	int 	16h
	mov 	cl, byte ptr should_prnt
	cmp 	cl, 1
	jne  	start
	cmp 	al, 27
	pushf
	call 	prnt_symb
	popf
	jne 	start
	mov 	ax, 0
	mov 	es, ax
	mov 	di, 9h*4
	mov 	si, offset old_vect
	movsw
	movsw
	ret
	was_pressed 	db 	0
	should_prnt 	db 	0
prnt_symb proc
	push 	ax
	push 	cx
	mov 	bl, 16
	xor 	cx, cx
	get_num:
		mov 	ah, 0
		div 	bl
		inc 	cx
		mov 	dl, ah
		push 	dx
		cmp 	al, 0
		jne 	get_num
	prnt:
		mov 	bx, offset symbols
		pop 	ax
		xlat
		mov 	dl, al
		mov 	ah, 02h
		int 	21h
		loop 	prnt
	mov 	dl, 10
	int 	21h
	pop 	cx
	pop 	ax
	ret
prnt_symb endp
	symbols 	db 	'0123456789ABCDEF'
end M