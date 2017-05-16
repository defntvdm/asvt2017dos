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
actions 	dw 	11h, offset direct1, -100h
			dw 	1fh, offset direct1, 100h
			dw 	1eh, offset direct1, -1h
			dw 	20h, offset direct1, 1h
			dw 	48h, offset direct2, -100h
			dw 	50h, offset direct2, 100h
			dw 	4bh, offset direct2, -1h
			dw 	4dh, offset direct2, 1h
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
head1 		dw 	4
head2 		dw 	4
tail1 		dw 	0
tail2 		dw 	0
snake1 		dw 	1201h, 1202h, 1203h, 196 dup (0)
snake2 		dw 	133eh, 133dh, 133ch, 196 dup (0)
question 	db 	'Сколько игроков? [1/2] : $'
players 	db 	?
old_seg 	dw 	?
old_off 	dw 	?
exit_flag 	db 	?


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
	mov 	[old_seg], es
	mov 	[old_off], bx
	mov 	dx, offset int9hand
	mov 	ax, 2509h
	int 	21h
	mov 	ah, 0fh
	int 	10h
	mov 	[old_mode], al
	mov 	ax, 13h
	int 	10h
	xor 	dx, dx
h:
	mov 	dl, 0
	w:
		call 	get_color
		add 	dl, 1
		cmp 	dl, 64
		jne 	w
	add 	dh, 1
	cmp 	dh, 38
	jne 	h

	mov 	bx, offset snake1
	add 	bx, [head1]
	mov 	dx, [bx]
	mov 	al, chsnake1
	call 	set_num

	mov 	bx, offset snake1
	add 	bx, [tail1]
	mov 	dx, [bx]
	mov 	al, csnake1
	call 	set_num

	cmp 	[players], 2
	jne 	main

	mov 	bx, offset snake2
	add 	bx, [head2]
	mov 	dx, [bx]
	mov 	al, chsnake2
	call 	set_num

	mov 	bx, offset snake2
	add 	bx, [tail2]
	mov 	dx, [bx]
	mov 	al, csnake2
	call 	set_num

main:
	mov 	dx, 0
	mov 	al, [exit_flag]
	call 	set_num
	push 	ds
	pop 	es
	cmp 	[exit_flag], 0
	jne 	exit
	call 	move_snakes
	xor 	ax, ax
	mov 	es, ax
	mov 	al, es:46ch
	add 	al, 5
sleeep:
	cmp 	al, es:46ch
	jg 		sleeep
	jmp 	main

exit:
	cmp 	[exit_flag], 3
	je 		escape
	cmp 	[exit_flag], 1
escape:
	mov 	ah, 1
	int 	21h
	xor 	ax, ax
	mov 	al, [old_mode]
	int 	10h
	mov 	dx, [old_off]
	mov 	ds, [old_seg]
	mov 	ax, 2509h
	int 	21h
	ret

move_snakes proc
	push 	dx
	mov 	bx, offset snake1
	add 	bx, [head1]
	mov 	dx, [bx]
	mov 	al, csnake1
	call 	set_num
	sub 	bx, [head1]
	add 	[head1], 2
	cmp 	[head1], offset head2
	jne 	@@1
	push 	dx
	mov 	dx, 1
	mov 	al, 0
	call 	set_num
	pop 	dx
	mov 	[head1], 0
@@1:
	add 	bx, [head1]
	add 	dx, [direct1]
	mov 	[bx], dx
	mov 	al, chsnake1
	call 	set_num
	cmp 	dh, 0
	je 		@@5
	cmp 	dh, 37
	je 		@@5
	cmp 	dl, 0
	je 		@@5
	cmp 	dl, 37
	je 		@@5
	
	mov 	bx, offset snake1
	add 	bx, [tail1]
	mov 	dx, [bx]
	mov 	al, 0
	call 	set_num
	add 	[tail1], 2
	cmp 	[tail1], offset tail2
	jne 	@@2
	mov 	[tail1], 0
@@2:
	cmp 	[players], 2
	jne 	@@4

	mov 	bx, offset snake2
	add 	bx, [head2]
	mov 	dx, [bx]
	mov 	al, csnake2
	call 	set_num
	sub 	bx, [head2]
	add 	[head2], 2
	cmp 	[head2], offset tail1
	jne 	@@3
	mov 	[head2], 0
@@3:
	add 	bx, [head2]
	add 	dx, [direct2] 	
	mov 	[bx], dx
	mov 	al, chsnake2
	call 	set_num
	cmp 	dh, 0
	je 		@@6
	cmp 	dh, 37
	je 		@@6
	cmp 	dl, 0
	je 		@@6
	cmp 	dl, 37
	je 		@@6

	mov 	bx, offset snake2
	add 	bx, [tail2]
	mov 	dx, [bx]
	mov 	al, 0
	call 	set_num
	add 	[tail2], 2
	cmp 	[tail2], offset snake1
	jne 	@@4
	mov 	[tail2], 0
@@5:
	mov 	[exit_flag], 1
	jmp 	@@4
@@6:
	mov 	[exit_flag], 2
@@4:
	ret
move_snakes endp

int9hand proc
	cli
	push 	ax
	push 	bx
	push 	cx
	push 	dx
	push 	es
	push 	di
	push 	si
	in 		al, 60h
	push 	ax
	in 		al, 61h
	or 		al, 80h
	out 	61, al
	and 	al, 7fh
	out 	61h, al
	pop 	ax
	test 	al, 80h
	jnz 	@@3
	and 	al, 7fh
	cmp 	al, 1
	je 		@@4

	push 	cs
	pop 	es
	mov 	ah, 0
	mov 	di, offset actions
	mov 	cx, 8
@@1:
	scasw
	je 		@@2
	scasw
	scasw
	loop 	@@1
	jmp 	@@3
@@2:
	mov 	si, di
	lodsw
	mov 	bx, ax
	lodsw
	mov 	dx, [bx]
	dec 	dx
	xor 	dx, 0ffffh
	cmp 	ax, dx
	je 		@@3
	mov 	[bx], ax
	jmp 	@@3

@@4:
	mov 	[exit_flag], 3
@@3:
	pop 	si
	pop 	di
	pop 	es
	mov 	al, 20h
	out 	20h, al
	pop 	dx
	pop 	cx
	pop 	bx
	pop 	ax
	sti
	iret
int9hand endp

set_num proc
	push 	bx
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
	;mov 	[di], al
	stosb
	pop 	dx
	call 	write_cell
	pop 	bx
	ret
set_num endp

get_color proc
	xor 	ax, ax
	mov 	al, dh
	shl 	ax, 6
	push 	dx
	mov 	dh, 0
	add 	ax, dx
	mov 	bx, offset field
	add 	bx, ax
	pop 	dx
	mov 	al, [bx]
	call 	write_cell
get_color endp

write_cell proc
	push 	es
	push 	dx
	push 	ax
	mov 	ax, 0a000h
	mov 	es, ax
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
	pop 	es
	ret
write_cell endp
end 	start
