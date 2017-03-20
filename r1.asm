	.model	tiny
	.code
	.386
	org	100h

start:
	jmp 	parse_args

prc_2fh proc
	cmp 	ax, 4e56h
	je  	ok
	jmp 	dword ptr cs:[old_vect]
	ok:
		push 	cs
		push 	offset prc_2fh
		pushf
		call 	dword ptr cs:[old_vect]
		pop 	dx
		pop 	ax
		iret
	old_vect	dd	?
prc_2fh endp
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
	usage 	db 	' �ᯮ�짮�����: r1 [/h] [/s] [/u] [/k] [/i]', 13, 10
			db 	' �ᯮ���� ⮫쪮 ���� ��㬥��$'
	help	db 	' Help:', 13, 10
			db	'   /h   help          HELP', 0dh, 0ah
			db	'   /i   install       ��⠭����� १�����', 0dh, 0ah
			db	'   /u   uninstall     ���४⭮ ���� १�����', 0dh, 0ah
			db	'   /k   kick          ���� १����� � �� ��砥', 0dh, 0ah
			db	'   /s   status        ���ﭨ� १�����', 0dh, 0ah, 13, 10
			db 	'(C) ����� ��������, ��-301', 13, 10, 24h
	mass	db	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', ':'
	res_seg	dw	?
	res_off	dw	?
	error_msg_install 	db 	" Install: �� ��⠭������, १����� 㦥 � �����", 13, 10, 24h
	access_msg_install 	db 	' Install: �ᯥ譮', 13, 10, 24h
	uninstall_success 	db 	' Uninstall: �ᯥ譮', 13, 10, 24h
	uninstall_msg_error1 	db 	' Uninstall: १����� � ����� ���', 13, 10, 24h
	uninstall_msg_error2 	db 	' Uninstall: ��� १����� �� �� ���設� �맮���, ���஡�� /k', 13, 10, 24h
	status_msg 	db 	' Status: $'
	error_msg_status 	db 	' Status: १����� � ����� ���', 13, 10, 24h
	error_msg_kick 	db 	' Kick: १����� � ����� ���', 13, 10, 24h
	kick_success 	db 	' Kick: �ᯥ譮', 13, 10 ,24h
	my_name 	db 	24h, 0, 0, 1, 0, 'NV', 0
	functions 	dw 	no_args, no_args, bad_input, no_key, print_help, install, kick, status, uninstall, bad_key, many_args

install:
	mov 	ax, 4e56h
	xor 	dx, dx
	int 	2fh
	test 	dx, dx
	jne  	error_install
	push	es
	mov	ax, 352fh
	int	21h
	mov	word ptr old_vect, bx
	mov	word ptr old_vect+2, es
	pop	es
	mov	ax, 252fh
	mov	dx,	offset prc_2fh
	int	21h
	push	es
	mov	ah, 49h
	mov	es, cs:[2Ch]
	int	21h
	pop	es
	mov	ax, 4800h
	mov	bx, 1
	int	21h
	push	es
	mov	si, offset my_name
	mov	es, ax
	xor	di, di
	mov	cx, 8
	rep	movsb
	mov	cs:[2Ch], ax
	pop	es
	mov 	ah, 09h
	mov 	dx, offset access_msg_install
	int 	21h
	mov		dx, offset some_data
	shr 	dx, 4
	inc 	dx
	mov 	ax, 3100h
	int	21h
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
	mov 	ax, 352fh
	int 	21h
	mov 	ax, 4e56h
	xor 	dx, dx
	int 	2fh
	test 	dx, dx
	je  	error_uninstall1
	cmp 	dx, bx
	jne 	error_uninstall2
	mov 	bx, es
	cmp 	ax, bx
	jne 	error_uninstall2
	mov 	di, offset old_vect
	mov 	ax, es:di
	mov 	dx, ax
	mov 	ax, [es:di+2]
	push 	ds
	mov 	ds, ax
	mov 	ax, 252fh
	int 	21h
	pop 	ds
	push 	es
	mov 	ax, es:2ch
	mov 	es, ax
	mov 	ah, 49h
	int 	21h
	pop 	es
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
	mov 	ax, 4e56h
	xor 	dx, dx
	int 	2fh
	test 	dx, dx
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
	mov 	ax, 4e56h
	xor 	dx, dx
	int 	2fh
	test 	dx, dx
	je  	error_kick
	push 	ax
	mov 	es, ax
	mov 	di, offset old_vect
	mov 	ax, es:di
	mov 	dx, ax
	mov 	ax, [es:di+2]
	push 	ds
	mov 	ds, ax
	mov 	ax, 252fh
	int 	21h
	pop 	ds
	pop 	es
	push 	es
	mov 	ax, es:2ch
	mov 	es, ax
	mov 	ah, 49h
	int 	21h
	pop 	es
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
	call 	[bx]
	ret
no_args:
	lea 	dx, no_args_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	no_args_msg 	db '��� ��㬥�⮢', 13, 10, 24h
bad_input:
	lea 	dx, bad_input_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	bad_input_msg 	db 	'���娥 ��㬥���', 13, 10, 24h
no_key:
	lea 	dx, no_key_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	no_key_msg 	db 	'���� 㪠���, ��������', 13, 10, 24h
bad_key:
 	lea 	dx, bad_key_msg
 	mov 	ah, 09h
 	int 	21h
 	lea 	dx, usage
	int 	21h
 	ret
 	bad_key_msg 	db 	'�� ����� ⠪�� ���祩', 13, 10, 24h
many_args:
	lea 	dx, many_args_msg
	mov 	ah, 09h
	int 	21h
	lea 	dx, usage
	int 	21h
	ret
	many_args_msg 	db 	'��� ����� ��㬥�⮢', 13, 10, 24h
end	start