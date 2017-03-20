	.model 	tiny
	.code
	org 	100h
start:
	mov 	ah, 0fh
	int 	10h
	push 	bx
	mov 	ah, 09h
	mov 	dx, offset mode_msg
	int 	21h
	mov 	bx, offset table_symb
	xlat
	mov 	dl, al
	mov 	ah, 02h
	int 	21h
	mov 	ah, 09h
	mov 	dx, offset page_msg
	int 	21h
	pop 	bx
	mov 	al, bh
	mov 	bx, offset table_symb
	xlat
	mov 	dl, al
	mov 	ah, 02h
	int 	21h
	ret
	mode_msg 	db 	'Mode: ', 24h
	table_symb 	db 	'0123456789ABCDEF'
	page_msg 	db 	13, 10, 'Page: ', 24h
end start