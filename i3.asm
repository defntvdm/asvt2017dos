	model 	tiny
	.code
	org 	100h
	locals
start:
	mov 	di, offset my_st
	inc 	di
	jmp 	M

frequencies 	dw 	10h, 1540
				dw	03h, 1467
				dw	11h, 1393
				dw	04h, 1320
				dw	12h, 1247
				dw	13h, 1173
				dw	06h, 1100
				dw	14h, 1027
				dw	07h, 953
				dw	15h, 880
				dw	08h, 843
				dw	16h, 807
				dw	17h, 770
				dw	2ch, 770
				dw	1fh, 733
				dw	2dh, 697
				dw	20h, 660
				dw	2eh, 623
				dw	2fh, 587
				dw	22h, 550
				dw	30h, 513
				dw	23h, 477
				dw	31h, 440
				dw	24h, 422
				dw	32h, 403
				dw	33h, 385

old_vect 		dw 	?, ?

int9handler proc
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
	cmp 	al, 1
	je 		exit
	push 	ax
	sub 	al, 80h
	cmp 	al, byte ptr cs:di
	pop 	ax
	je 		unpressed
	mov 	ah, 0
	mov 	bx, ax
	mov 	si, offset frequencies
	mov 	cx, 26
search:
	lodsw
	cmp 	ax, bx
	je 		finded
	lodsw
	loop 	search
	pop 	ax
	iret
unpressed:
	in 		al, 61h
	and 	al, 0fdh
	out 	61h, al
	mov 	al, 0
	mov 	byte ptr cs:di, al
	pop 	ax
	iret
finded:
	xchg 	ax, bx
	cmp 	al, byte ptr [offset my_st]
	jne 	the_same
	pop 	ax
	iret
the_same:
	mov 	byte ptr cs:di, al
	in 		al, 61h
	and 	al, 0fdh
	out 	61h, al
	mov 	al, 10110110b
	out 	43h, al
	lodsw
	out 	42h, al
	mov 	al, ah
	out 	42h, al
	in 		al, 61h
	or 		al, 3h
	out 	61h, al
	pop 	ax
	iret
exit:
	mov 	byte ptr [offset zhuk], 1
	pop 	ax
	iret
	my_st 	db 	28 dup (0)
int9handler endp

zhuk 	db 	0

M:
	push 	es
	mov 	ax, 3509h
	int 	21h
	mov 	word ptr [offset old_vect], es
	mov 	word ptr [offset old_vect + 2], bx
	pop 	es
	mov 	dx, offset int9handler
	mov 	ax, 2509h
	int 	21h
main_loop:
	hlt
	cmp 	byte ptr [offset zhuk], 1
	jne 	main_loop

	in 		al, 61h
	and 	al, 7dh
	out 	61h, al

	mov 	ax, 2509h
	mov 	dx, word ptr [offset old_vect + 2]
	mov 	ds, word ptr [offset old_vect]
	int 	21h
 	ret
end 	start