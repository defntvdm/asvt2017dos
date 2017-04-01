	.model	tiny
	.code
	.386
	org	100h

start:
	jmp 	parse_args

prc_2fh proc
	cmp 	dx, 4e56h
	je  	ok
	jmp 	dword ptr cs:[offset old_vect - offset prc_2fh]
	ok:
		push 	cs
		push 	0
		pushf
		call 	dword ptr cs:[offset old_vect - offset prc_2fh]
		pop 	dx
		pop 	ax
		iret
	old_vect	dd	?
prc_2fh endp
tsr_len 	equ 	$-prc_2fh
some_data:
	symbols	db	13 dup (0), 0, 18 dup (0), 1, 12 dup (0), 2, 0, 2, 56 dup(0), 3, 4, 0, 5, 7 dup (0), 6, 0, 7, 138 dup (0)
	curr_key	dw	?
	dka	db	2, 1, 3, 2, 2, 2, 2, 2 
		db	2, 1, 3, 2, 2, 2, 2, 2
		db	2, 2, 2, 2, 2, 2, 2, 2
		db	2, 2, 2, 4, 5, 6, 7, 8
		db 	9, 10, 9, 9, 9, 9, 9, 9 
		db 	9, 10, 9, 9, 9, 9, 9, 9
		db 	9, 10, 9, 9, 9, 9, 9, 9
		db 	9, 10, 9, 9, 9, 9, 9, 9
		db 	9, 10, 9, 9, 9, 9, 9, 9
		db 	9, 9, 9, 9, 9, 9, 9, 9
		db 	10, 10, 10, 10, 10, 10, 10, 10
	usage 	db 	' Использование: r2 [/h] [/s] [/u] [/k] [/i]', 13, 10
			db 	' Используйте только один аргумент$'
	help	db 	' Help:', 13, 10
			db	'   /h   help          HELP', 0dh, 0ah
			db	'   /i   install       установить резидента', 0dh, 0ah
			db	'   /u   uninstall     корректно снять резидента', 0dh, 0ah
			db	'   /k   kick          снять резидента в любом случае', 0dh, 0ah
			db	'   /s   status        состояние резидента', 0dh, 0ah, 13, 10
			db 	'(C) Вадим Николаев, КБ-301', 13, 10, 24h
	mass	db	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', ':'
	res_seg	dw	?
	res_off	dw	?
	error_msg_install 		db 	" Install: не установлено, резидент уже в памяти", 13, 10, 24h
	access_msg_install 		db 	' Install: успешно', 13, 10, 24h
	uninstall_success 		db 	' Uninstall: успешно', 13, 10, 24h
	uninstall_msg_error1 	db 	' Uninstall: резидента в памяти нет', 13, 10, 24h
	uninstall_msg_error2 	db 	' Uninstall: наш резидент не на вершине вызовов, попробуйте /k', 13, 10, 24h
	status_msg 				db 	' Status: $'
	error_msg_status 		db 	' Status: резидента в памяти нет', 13, 10, 24h
	error_msg_kick 			db 	' Kick: резидента в памяти нет', 13, 10, 24h
	kick_success 			db 	' Kick: успешно', 13, 10 ,24h
	my_name 				db 	'NV', 0, 0, 0, 0, 0, 0
	functions 				dw 	no_args, no_args, bad_input, no_key, print_help, install, kick, status, uninstall, bad_key, many_args

install:
	mov 	dx, 4e56h
	xor 	ax, ax
	int 	2fh
	test 	ax, ax
	jne  	error_install
	push	es
	
	push 	0
	pop 	es
	push 	word ptr es:[2fh*4]
	push 	word ptr es:[2fh*4+2]
	pop 	es
	pop 	bx
	
	mov	word ptr old_vect, bx
	mov	word ptr old_vect+2, es

	pop 	es
	mov 	bx, tsr_len
	shr 	bx, 4
	inc 	bx
	mov 	ah, 48h
	int 	21h
	push 	ax
	dec 	ax
	push 	ax
	pop 	es
	pop 	ax
	mov 	word ptr es:[1], ax
	mov 	di, 8
	mov 	si, offset my_name
	mov 	cx, 8
	rep 	movsb
	mov 	si, offset prc_2fh
	mov 	es, ax
	mov 	di, 0
	mov 	cx, tsr_len
	rep 	movsb

	cli
	push 	0
	pop 	es
	mov 	word ptr es:[2fh*4+2], ax
	mov 	word ptr es:[2fh*4], 0
	sti
	
	mov 	ah, 09h
	mov 	dx, offset access_msg_install
	int 	21h
	ret
	error_install:
		mov 	ah, 09h
		mov 	dx, offset error_msg_install
		int 	21h
		ret


print_help:
	mov 	ah, 09h
	mov 	dx, offset help
	int 	21h
	xor 	cx, cx
	ret


uninstall:
	push 	0
	pop 	es
	push 	word ptr es:[2fh*4]
	push 	word ptr es:[2fh*4+2]
	pop 	es
	pop 	bx

	mov 	dx, 4e56h
	xor 	ax, ax
	int 	2fh
	test 	ax, ax
	je  	error_uninstall1
	cmp 	dx, bx
	jne 	error_uninstall2
	mov 	bx, es
	cmp 	ax, bx
	jne 	error_uninstall2
	mov 	di, [offset old_vect-offset prc_2fh]
	mov 	ax, es:di
	mov 	dx, ax
	mov 	ax, [es:di+2]
	push 	ds
	push 	es
	mov 	ds, ax

	cli
	push 	0
	pop 	es
	mov 	word ptr es:[2fh*4], dx
	mov 	word ptr es:[2fh*4+2], ds
	sti
	
	pop 	es
	pop 	ds
	mov 	ah, 49h
	int 	21h
	mov 	ah, 09h
	mov		dx, offset uninstall_success
	int 	21h
	ret
	error_uninstall2:
		mov 	ah, 09h
		mov 	dx, offset uninstall_msg_error2
		int 	21h
		ret
	error_uninstall1:
		mov 	ah, 09h
		mov 	dx, offset uninstall_msg_error1
		int 	21h
		ret


status:
	mov 	dx, 4e56h
	xor 	ax, ax
	int 	2fh
	test 	ax, ax
	je  	error_status
	mov 	[res_off], dx
	mov 	[res_seg], ax
	mov 	ax, dx
	mov 	bx, 16
	mov 	cx, 4
cycle_offset:
	cmp		al, 0
	je		complite_offset
	xor 	dx, dx
	div 	bx
	push	dx
	dec 	cx
	jmp 	cycle_offset
complite_offset:
	test 	cx, cx
	je  	blabla
	xor 	dx, dx
	push	dx
	dec 	cx
	jmp 	complite_offset
blabla:
	mov 	ax, 16
	push	ax
	mov 	ax, [res_seg]
	mov 	bx, 16
	mov 	cx, 4
cycle_seg:
	test	ax, ax
	je		complite_seg
	xor 	dx, dx
	div 	bx
	push	dx
	dec 	cx
	jmp 	cycle_seg
complite_seg:
	test	cx, cx
	je  	bla
	xor 	dx, dx
	push	dx
	dec 	cx
	jmp 	complite_seg
bla:
	mov 	cx, 9
	mov 	ah, 09h
	mov 	dx, offset status_msg
	int 	21h
	jmp 	print
print:
	mov 	bx, offset mass
	mov 	ah, 02h
	pop 	dx
	mov 	al, dl
	xlat
	mov 	dl, al
	int 	21h
	loop 	print
	mov 	ah, 02h
	mov 	dl, 13
	int 	21h
	mov	 	dl, 10
	int 	21h
	ret
error_status:
	mov 	ah, 09h
	mov 	dx, offset error_msg_status
	int 	21h
	ret


kick:
	mov 	dx, 4e56h
	xor 	ax, ax
	int 	2fh
	test 	ax, ax
	je  	error_kick
	mov 	es, ax
	push 	es
	mov 	di, [offset old_vect - offset prc_2fh]
	mov 	ax, es:di
	mov 	dx, ax
	mov 	ax, [es:di+2]
	push 	ds
	mov 	ds, ax

	cli
	push 	0
	pop 	es
	mov 	word ptr es:[2fh*4+2], ds 
	mov 	word ptr es:[2fh*4], dx
	sti
	
	pop 	ds
	pop 	es
	mov 	ah, 49h
	int 	21h
	mov 	ah, 09h
	mov		dx, offset kick_success
	int 	21h
	ret
	error_kick:
		mov 	ah, 09h
		mov 	dx, offset error_msg_kick
		int 	21h
		ret


parse_args:
	mov cx, 0
    mov si, 81h
go_parse:
	xor 	ax, ax
	mov 	bx, offset symbols
	lodsb
	cmp 	al, 0Dh
	je  	end_parse
	xlat
	push 	ax
	mov 	ax, cx
	mov 	bl, 8
	mul 	bl
	pop 	cx
	add 	ax, cx
	mov 	bx, offset dka
	xlat
	mov 	cx, ax
	jmp 	go_parse
end_parse:
	mov 	bx, cx
	shl 	bx, 1
	add 	bx, offset functions
	jmp 	[bx]
	ret
no_args:
	lea 	dx, no_args_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	no_args_msg 	db 'Нет аргументов', 13, 10, 24h
bad_input:
	lea 	dx, bad_input_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	bad_input_msg 	db 	'Плохие аргументы', 13, 10, 24h
no_key:
	lea 	dx, no_key_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	no_key_msg 	db 	'Ключ укажите, пожалуйста', 13, 10, 24h
bad_key:
 	lea 	dx, bad_key_msg
 	mov 	ah, 09h
 	int 	21h
 	lea 	dx, usage
	int 	21h
 	ret
 	bad_key_msg 	db 	'Не знаем таких ключей', 13, 10, 24h
many_args:
	lea 	dx, many_args_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	many_args_msg 	db 	'Чот много аргументов', 13, 10, 24h
end	start