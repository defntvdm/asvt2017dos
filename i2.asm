	model 	tiny
	.code
	org 	100h
	locals
start:
	jmp 	M

buf_len 	equ 	20
buffer 		db 		buf_len dup (0)
buf_end:
head 		dw 		offset buffer
tail 		dw 		offset buffer
old_vect 	dw 		0, 0

M:
	mov 	ax, 3509h
	int 	21h
	mov 	word ptr cs:[offset old_vect], es
	mov 	word ptr cs:[offset old_vect + 2], bx
	mov 	ax, 2509h
	mov 	dx, offset int9hhandler
	int 	21h
	mov 	ax, cs
	mov 	es, ax
	mov 	ds, ax
main_loop:
	hlt
	call 	read_buf
	jc 		main_loop
	call 	prnt_scancode
	cmp 	al, 1
	jne 	main_loop
	mov 	ds, word ptr cs:[offset old_vect]
	mov 	dx, word ptr cs:[offset old_vect + 2]
	mov 	ax, 2509h
	int 	21h
	ret

int9hhandler proc
	push 	ax
	in 		al, 60h
	push 	ax
	in 		al, 61h
	or 		al, 80h
	out 	61h, al
	and 	al, 7fh
	out 	61h, al
	mov 	al, 20h
	out 	20h, al
	pop 	ax
	cmp 	al, 0e0h
	jne 	@@1
	mov 	al, 0e0h
	mov 	byte ptr cs:[offset prev], al
	pop 	ax
	iret
@@1:
	test 	al, 80h
	jnz 	@@4
	push 	ax
	push 	bx
	mov 	bx, cs
	mov 	ds, bx
	mov 	bx, offset flags
	xlat
	pop 	bx
	cmp 	al, 0
	je 		@@3
	pop 	ax
	pop 	ax
	iret
@@3:
	cmp 	byte ptr cs:[offset prev], 0e0h
	jne 	@@2
	mov 	al, 0e0h
	call 	write_buf
@@2:
	pop 	ax
	mov 	byte ptr cs:[offset prev], al
	call 	write_buf
	push 	bx
	mov 	bx, cs
	mov 	ds, bx
	mov 	bx, offset flags
	mov 	ah, 0
	add 	bx, ax
	mov 	al, 1
	mov 	byte ptr cs:bx, al
	pop 	bx
	pop 	ax
	iret
@@4:
	push 	ax
	cmp 	byte ptr cs:[offset prev], 0e0h
	jne 	@@5
	mov 	al, 0e0h
	call 	write_buf
@@5:
	pop 	ax
	mov 	byte ptr cs:[offset prev], al
	call 	write_buf
	and 	al, 7fh
	push 	bx
	mov 	bx, offset flags
	mov 	ah, 0
	add 	bx, ax
	mov 	al, 0
	mov 	byte ptr cs:bx, al
	pop 	bx
	pop 	ax
	iret
	prev 	db 	?
	flags 	db 	127 dup (0)
int9hhandler endp

prnt_scancode proc
	push 	ax
	push 	bx
	push 	cx
	push 	dx
	mov 	bl, 10h
	xor 	cx, cx
@@1:
	mov 	ah, 0
	div 	bl
	mov 	dl, ah
	push 	dx
	inc 	cx
	cmp 	al, 0
	jne 	@@1
	mov 	bx, offset symbols
	mov 	ah, 02h
@@2:
	pop 	dx
	mov 	al, dl
	xlat
	mov 	dl, al
	int 	21h
	loop 	@@2
	mov 	dl, 'h'
	int 	21h
	mov 	dl, 13
	int 	21h
	mov 	dl, 10
	int 	21h
	pop 	dx
	pop 	cx
	pop 	bx
	pop 	ax
	ret
	symbols 	db 	'0123456789ABCDEF'
prnt_scancode endp

write_buf proc
	push 	ax
	push 	bx
	mov 	bx, word ptr cs:[offset head]
	mov 	byte ptr cs:bx, al
	mov 	ax, bx
	inc 	word ptr cs:[offset head]
	cmp 	word ptr cs:[offset head], offset buf_end
	jne 	@@1
	mov 	word ptr cs:[offset head], offset buffer
@@1:
	mov 	bx, word ptr cs:[offset head]
	cmp 	bx, word ptr cs:[offset tail]
	jnz 	@@2
	mov 	word ptr cs:[offset head], ax
@@2:
	pop 	bx
	pop 	ax
	ret
write_buf endp

read_buf proc
	push 	bx
	mov 	bx, word ptr cs:[offset tail]
	cmp 	bx, cs:[offset head]
	jnz 	@@1
	pop 	bx
	stc
	ret
@@1:
	mov 	al, byte ptr cs:bx
	inc 	word ptr cs:[offset tail]
	cmp 	word ptr cs:[offset tail], offset buf_end
	jnz 	@@2
	mov 	word ptr cs:[offset tail], offset buffer
@@2:
	pop 	bx
	clc
	ret
read_buf endp

end start
