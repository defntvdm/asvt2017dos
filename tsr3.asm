	.model	tiny
	.code
	org 100h
start:
	jmp init
Int_2fh_proc proc
	cmp ax, 4E56h
	je Ok
	jmp dword ptr cs:[Int_2fh_vect]
	Ok:
		push ds
		push dx
		push cs
		pop ds
		mov	ah, 09h
		mov dx, offset My_string - 102h
		pushf
		int	21h
		call dword ptr cs:[offset Int_2fh_vect - 102h]
		pop dx
		pop ds
		iret
		Int_2fh_vect dd ?
		My_string db 'It is mine!', 24h
Int_2fh_proc endp
prc_len 	equ 	$-start
init:
 	push 	es
	mov 	ax,352fh
	int 	21h
	mov 	word ptr Int_2fh_vect,bx
	mov 	word ptr Int_2fh_vect+2,es
	mov 	es, word ptr cs:[2ch]
	mov 	ah, 49h
	int 	21h
	mov 	bx, prc_len
	shr 	bx, 4
	;inc 	bx
	mov 	ah, 48h
	int 	21h
	mov 	es, ax
	mov 	si, offset start
	mov 	cx, prc_len
	rep 	movsb
	pop 	es
	mov 	bx, ax
	push 	ax
	dec 	ax
	mov 	es, ax
	pop 	ax
	mov 	word ptr es:[1], bx
	mov 	word ptr cs:[2ch], ax
	mov 	si, offset my_name
	mov 	di, 8
	mov 	cx, 8
	rep 	movsb
	push 	ds
	push 	ax
	pop 	ds
	mov 	ax, 252fh
	xor 	dx, dx
	int 	21h
	pop 	ds
	ret
	my_name 	db 	'NV', 0, 0, 0, 0, 0, 0
end start
