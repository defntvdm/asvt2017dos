 	model 	tiny
 	.code
 	.386
 	org 	100h
 	locals
start:
	jmp 	M

cboard 		equ 	7
csnake1 	equ 	2
chsnake1 	equ 	10
csnake2 	equ 	4
chsnake2 	equ 	12
cfruit 		equ 	35	
cmega 		equ 	14
field 		db 	64 dup(cboard)
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	cboard, 62 dup(0), cboard
			db 	64 dup (cboard)
old_mode 	db 	?
direct1 	dw 	1
direct2 	dw 	-1
head1 		dw 	2
head2 		dw 	2
tail1 		dw 	0
tail2 		dw 	0
snake1 		dw 	1201h, 1202h, 198 dup (0)
snake2 		dw 	133eh, 133dh, 198 dup (0)
question 	db 	'Сколько игроков? [1/2] : $'
players 	db 	?
old_seg 	dw 	?
old_off 	dw 	?
exit_flag 	db 	0
ttime 		dw 	?

M:
	mov 	ah, 09h
	mov 	dx, offset question
	int 	21h
option:
	mov 	ah, 0
	int 	16h
	cmp 	al, 32h
	je		ok
	cmp 	al, 31h
	je 		ok
	jmp 	option
ok:
	sub 	al, 30h
	mov 	players, al
	mov 	ax, 3509h
	int 	21h
	mov 	word ptr cs:[offset old_seg], es
	mov 	word ptr cs:[offset old_off], bx
	mov 	dx, offset int9hand
	mov 	ax, 2509h
	int 	21h
	xor 	ax, ax
	mov 	ds, ax
	mov 	ax, 0a000h
	mov 	es, ax
	mov 	ah, 0fh
	int 	10h
	mov 	byte ptr cs:[offset old_mode], al
	mov 	ax, 13h
	int 	10h
	xor 	dx, dx
h:
	mov 	dl, 0
	w:
		call 	write_cell
		add 	dl, 1
		cmp 	dl, 64
		jne 	w
	add 	dh, 1
	cmp 	dh, 38
	jne 	h

	mov 	bx, offset snake1
	add 	bx, cs:[head1]
	mov 	dx, cs:[bx]
	mov 	al, chsnake1
	call 	set_num

	mov 	bx, offset snake1
	add 	bx, cs:[tail1]
	mov 	dx, cs:[bx]
	mov 	al, csnake1
	call 	set_num

	cmp 	byte ptr cs:[players], 2
	jne 	cont

	mov 	bx, offset snake2
	add 	bx, cs:[head2]
	mov 	dx, cs:[bx]
	mov 	al, chsnake2
	call 	set_num

	mov 	bx, offset snake2
	add 	bx, cs:[tail2]
	mov 	dx, cs:[bx]
	mov 	al, csnake2
	call 	set_num

cont:
	mov 	al, ds:[46ch]
	add 	al, 3
ssleep:
	cmp 	al, ds:[46ch]
	jg 		ssleep
	call 	move_snakes
	cmp 	cs:[exit_flag], 1
	jne 	cont

	push 	ds
	mov 	dx, cs:[offset old_off]
	mov 	ds, cs:[offset old_seg]
	mov 	ax, 2509h
	int 	21h
	pop 	ds
	xor 	ax, ax
	mov 	al, byte ptr cs:[offset old_mode]
	int 	10h
	ret

move_snakes proc
	push 	ax
	mov 	bx, offset snake1
	add 	bx, cs:[offset head1]
	mov 	dx, cs:[bx]
	mov 	al, csnake1
	call 	set_num
	add 	dx, cs:[offset direct1]
	mov 	al, chsnake1
	call	set_num
	add 	word ptr cs:[offset head1], 2
	cmp 	word ptr cs:[offset head1], 400
	jne 	@@1
	mov 	word ptr cs:[offset head1], 0
@@1:
	mov 	bx, offset snake1
	add 	bx, cs:[offset head1]
	mov 	cs:[bx], dx

	mov 	bx, offset snake1
	add 	bx, cs:[offset tail1]
	mov 	dx, cs:[bx]
	mov 	al, 0
	call 	set_num
	add 	word ptr cs:[offset tail2], 2
	cmp 	word ptr cs:[offset tail2], 400
	jne 	@@2
	mov 	word ptr cs:[offset tail2], 0
@@2:

@@done:
	pop 	ax
	ret
move_snakes endp

int9hand proc
	push 	ax
	in 		al, 60h
	push 	ax
	in 		al, 61h
	or 		al, 80h
	out 	61, al
	and 	al, 7fh
	out 	61h, al
	mov 	al, 20h
	out 	20h, al
	pop 	ax
	test 	al, 80h
	jnz 	done
	and 	al, 7fh
	cmp 	al, 1
	je 		@@1
	cmp 	al, 20h
	je 		@@20
	cmp 	al, 11h
	je 		@@11
	cmp 	al, 1fh
	je 		@@1f
	cmp 	al, 1eh
	je 		@@1e
	cmp 	al, 4bh
	je 		@@4b
	cmp 	al, 50h
	je 		@@50
	cmp 	al, 48h
	je 		@@48
	cmp 	al, 4dh
	je 		@@4d
	jmp 	done
@@4d:
	cmp 	word ptr cs:[offset direct2], -1
	je 		done
	mov 	word ptr cs:[offset direct2], 1h
	jmp 	done
@@4b:
	cmp 	word ptr cs:[offset direct2], 1
	je 		done
	mov 	word ptr cs:[offset direct2], -1h
	jmp 	done
@@50:
	cmp 	word ptr cs:[offset direct2], -100h
	je 		done
	mov 	word ptr cs:[offset direct2], 100h
	jmp 	done
@@48:
	cmp 	word ptr cs:[offset direct2], 100h
	je 		done
	mov 	word ptr cs:[offset direct2], -100h
	jmp 	done
@@20:
 	cmp 	word ptr cs:[offset direct1], -1h
 	je 		done
	mov 	word ptr cs:[offset direct1], 1h
	jmp 	done
@@1e:
 	cmp 	word ptr cs:[offset direct1], 1h
 	je 		done
	mov 	word ptr cs:[offset direct1], -1h
	jmp 	done
@@1f:
	cmp 	word ptr cs:[offset direct1], -100h
	je 		done
	mov 	word ptr cs:[offset direct1], 100h
	jmp 	done
@@11:
 	cmp 	word ptr cs:[offset direct1], 100h
 	je 		done
	mov 	word ptr cs:[offset direct1], -100h
	jmp 	done
@@1:
	mov 	byte ptr cs:[offset exit_flag], 1
done:
	pop 	ax
	iret
int9hand endp

set_num proc
	push 	dx
	push 	ax
	xor 	ax, ax
	mov 	al, dh
	shl 	ax, 6
	mov 	dh, 0
	add 	ax, dx
	mov 	di, offset field
	add 	di, ax
	pop 	ax
	mov 	cs:di, al
	pop 	dx
	call 	write_cell
	ret
set_num endp

write_cell proc
	push 	dx
	xor 	ax, ax
	mov 	al, dh
	shl 	ax, 6
	push 	dx
	mov 	dh, 0
	add 	ax, dx
	mov 	bx, offset field
	add 	bx, ax
	pop 	dx
	mov 	al, cs:[bx]
	push 	ax
	xor 	ax, ax
	mov 	al, dh
	mov 	dh, 25
	mul 	dh
	shl 	ax, 6
	mov 	di, ax
	xor 	ax, ax
	mov 	al, dl
	mov 	dh, 5
	mul 	dh
	add 	di, ax
	pop 	ax
	mov 	dx, 5
@@1:
	mov 	cx, 5
	rep 	stosb
	add 	di, 315
	dec 	dx
	jnz 	@@1
	pop 	dx
	ret
write_cell endp
end 	start
