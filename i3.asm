	model 	tiny
	.code
	org 	100h
	locals
start:
	mov 	di, offset my_st
	inc 	di
	jmp 	M

frequencies 	dw 	10h, 9121
				dw	03h, 8609
				dw	11h, 8126
				dw	04h, 7670
				dw	12h, 7239
				dw	13h, 6833
				dw	06h, 6449
				dw	14h, 6087
				dw	07h, 5746
				dw	15h, 5423
				dw	08h, 5119
				dw	16h, 4831
				dw	17h, 4560
				dw	2ch, 4560
				dw	1fh, 4304
				dw	2dh, 4063
				dw	20h, 3834
				dw	2eh, 3619
				dw	2fh, 3416
				dw	22h, 3224
				dw	30h, 3043
				dw	23h, 2873
				dw	31h, 2711
				dw	24h, 2559
				dw	32h, 2415
				dw	33h, 2280

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
	mov 	al, 0b6h
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