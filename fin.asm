	model 	tiny
	.code
	org 	100h
	locals
start:
	jmp 	M

csnake1 	equ 2
chsnake1 	equ 10
csnake2 	equ 4
chsnake2 	equ 12
dir_vars 	dw 	11h, next_dir1, -100h
			dw 	1eh, next_dir1, -1h
			dw 	1fh, next_dir1, 100h
			dw 	20h, next_dir1, 1h
			dw 	48h, next_dir2, -100h
			dw 	4bh, next_dir2, -1h
			dw 	50h, next_dir2, 100h
			dw 	4dh, next_dir2, 1h
old_mode 	db 	?
msg 		db 	'Сколько игроков? [1/2] : $'
players 	db 	?
old_seg9 	dw 	?
old_off9 	dw 	?
old_seg1c 	dw 	?
old_off1c 	dw 	?
next_dir1 	dw 	1
next_dir2 	dw 	-1
direction1 	dw 	1
direction2 	dw 	-1
exit_flag 	dw 	0
buffer 		dw 	offset move_snake1, 19 dup (0)
head 		dw 	offset buffer
tail 		dw 	offset buffer
snake1 		dw 	1301h, 1302h, 1303h, 97 dup (0)
shead1 		dw 	offset snake1 + 4
stail1 		dw 	offset snake1
snake2 		dw 	143eh, 143dh, 143ch, 97 dup (0)
shead2 		dw	offset snake2 + 4
stail2 		dw 	offset snake2

M:
	mov 	ah, 0fh
	int 	10h
	mov  	[old_mode], al
	mov 	ah, 09h
	mov 	dx, offset msg
	int 	21h
option:
	xor 	ax, ax
	int 	16h
	cmp 	al, 31h
	je 		readed
	cmp 	al, 32h
	je 		readed
	jmp 	option
readed:
	sub 	al, 30h
	mov 	[players], al
	mov 	ax, 3509h
	int 	21h
	mov 	[old_seg9], es
	mov 	[old_off9], bx
	mov 	dx, offset int9handler
	mov 	ax, 2509h
	int 	21h
	mov 	ax, 351ch
	int 	21h
	mov 	[old_seg1c], es
	mov 	[old_off1c], bx
	mov 	ax, 251ch
	mov 	dx, offset int1chandler
	int 	21h

	push 	cs
	pop 	es

	mov 	ax, 13h
	int 	10h

	mov 	dx, 1301h
	mov 	al, csnake1
	call	set_num
	inc 	dx
	call 	set_num
	inc 	dx
	mov 	al, chsnake1
	call 	set_num
	call 	move_snake1

main_loop:
	hlt
	call 	read_buf
	jc 		main_loop

	mov 	bx, ax
	call 	bx
	jmp 	main_loop

exit_program:
	mov 	dx, [old_off9]
	mov 	ds, [old_seg9]
	mov 	ax, 2509h
	int 	21h
	push 	cs
	pop 	ds
	mov 	dx, [old_off1c]
	mov 	ds, [old_seg1c]
	mov 	ax, 251ch
	int 	21h
	push 	cs
	pop 	ds
	xor 	ax, ax
	int 	16h
	xor 	ax, ax
	mov 	al, [old_mode]
	int 	10h
	ret

move_snake1 proc
	mov 	bx, [shead1]
	mov 	dx, [bx]
	mov 	al, csnake1
	call 	set_num
	inc 	[shead1]
	inc 	[shead1]
	cmp 	[shead1], offset shead1
	jne 	@@1
	mov 	[shead1], offset snake1
@@1:
	mov 	bx, [next_dir1]
	add 	bx, [direction1]
	cmp 	bx, 0
	je 		@@2
	mov 	bx, [next_dir1]
	mov 	[direction1], bx
@@2:
	add 	dx, [direction1]
	call 	get_new_dx
	mov 	al, chsnake1
	call 	set_num
	mov 	bx, [stail1]
	mov 	dx, [bx]
	mov 	al, 0
	call 	set_num
	inc 	[stail1]
	inc 	[stail1]
	cmp 	[stail1], offset shead1
	jne 	@@3
	mov 	[stail1], offset snake1
@@3:
	ret
move_snake1 endp

move_snake2 proc
	ret
move_snake2 endp

get_new_dx proc
	cmp 	dh, -1
	je 		@@1
	cmp 	dh, 40
	je 		@@2
	cmp 	dl, -1
	je 		@@3
	cmp 	dl, 64
	je 		@@4
	ret
@@4:
	mov 	dl, 0
	ret
@@3:
	mov 	dl, 63
	ret
@@2:
	mov 	dh, 0
	ret
@@1:
 	mov 	dh, 39
	ret
get_new_dx endp

set_num proc
	xor 	bx, bx
	mov 	bl, dh
	shl 	bx, 6
	push 	dx
	mov 	dh, 0
	add 	bx, dx
	mov 	di, bx
	stosb
	pop 	dx
	call 	write_cell
	ret
set_num endp

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
	mov 	dh, 0
	mov 	ax, dx
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

write_buf proc
	push 	ax
	push 	bx
	mov 	bx, [head]
	mov 	[bx], ax
	mov 	ax, bx
	inc 	[head]
	inc 	[head]
	cmp 	[head], offset head
	jne 	@@1
	mov 	[head], offset buffer
@@1:
	mov 	bx, [head]
	cmp 	bx, [tail]
	jnz 	@@2
	mov 	[head], ax
@@2:
	pop 	bx
	pop 	ax
	ret
write_buf endp

read_buf proc
	push 	bx
	mov 	bx, [tail]
	cmp 	bx, [head]
	jnz 	@@1
	pop 	bx
	stc
	ret
@@1:
	mov 	bx, [tail]
	mov 	ax, [bx]
	inc 	[tail]
	inc 	[tail]
	cmp 	[tail], offset head
	jnz 	@@2
	mov 	[tail], offset buffer
@@2:
	pop 	bx
	clc
	ret
read_buf endp

int1chandler proc
	cli
	push 	ax
	cmp 	[tics], 0
	jne 	@@1
	mov 	ax, offset move_snake1
	call 	write_buf
	mov 	ax, offset move_snake2
	call 	write_buf
	mov 	[tics], 3
@@1:
	pop 	ax
	add 	[tics], 1
	sti
	iret
	tics 	db 	0
int1chandler endp

int9handler proc
	cli
	push 	ax
	push 	si
	push 	di
	in 		al, 60h
	push 	ax
	in 		al, 61h
	or 		al, 80h
	out 	61h, al
	and 	al, 7fh
	out 	61h, al
	pop 	ax
	test 	al, 80h
	jnz 	end_handler9
	cmp 	al, 1
	je 		set_exit_flag
	mov 	cx, 8
	mov 	ah, 0
	mov 	di, offset dir_vars
@@1:
	scasw
	je 		@@2
	add 	di, 4
	loop 	@@1
	jmp 	end_handler9
@@2:
	mov 	si, di
	lodsw
	mov 	bx, ax
	lodsw
	mov 	[bx], ax
	jmp 	end_handler9
set_exit_flag:
	mov 	ax, offset exit_program
	call 	write_buf
end_handler9:
	mov 	al, 20h
	out 	20h, al
	pop 	di
	pop 	si
	pop 	ax
	sti
	iret
int9handler endp
end 	start
