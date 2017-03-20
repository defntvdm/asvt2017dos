	.model 	tiny
	.code
	.386
	org 	100h
start:
	mov 	ah, 0fh    ; Узнаём страничечку, и видеорежимчик
	int 	10h
	mov 	byte ptr sc_width, ah
	mov 	byte ptr video_mode, al
	mov 	byte ptr video_page, bh
	sub 	ah, 31
	shr 	ah, 1
	mov 	byte ptr first_pos, ah
	cmp 	al, 3
	jg  	maybe_not_text_mode
	mov 	bl, 1eh
it_is_text_mode:
	mov 	ah, 0h
	mov 	al, byte ptr video_mode
	int 	10h	
	
	xor 	dx, dx
	mov 	al, byte ptr sc_width
	mov 	cl, 25
	mul 	cl
	mov 	cx, ax
	mov 	ax, 0920h
	int 	10h

	mov 	bh, byte ptr video_page
	mov 	ah, 02h	   ; ставим курсорчик
	mov 	dh, 04h    
	mov 	dl, byte ptr first_pos
	int 	10h
	mov 	al, 0
	mov 	cx, 16

print_next:
	push 	cx          ; пишем
	mov 	ah, 09h
	mov 	cx, 1
	int 	10h

	mov 	ah, 02h     ; двигаемся
	inc 	dl
	int 	10h
	
	push 	ax           ; пишем
	mov 	ah, 09h
	mov 	cx, 1
	mov 	al ,20h
	int 	10h
	pop 	ax

	mov 	ah, 02h      ; двигаемся
	inc 	dl
	int 	10h

	inc 	al
	test 	al, al
	je  	exit
	pop 	cx
	loop 	print_next
	mov 	cx, 16       ; заряжаемся на новую строчечку
	inc 	dh
	mov 	dl, byte ptr first_pos
	mov 	ah, 02
	int 	10h
	jmp 	print_next
exit:
	mov 	dl, 0
	mov 	dh, 25
	mov 	ah, 02h
	int 	10h
	mov 	ah, 05h
	mov 	al, byte ptr video_page
	int 	10h
	mov 	ah, 0h
	int 	16h
	mov 	ax, 0h
	mov 	al, byte ptr video_mode
	int 	10h
	mov 	ah, 05h
	mov 	al, byte ptr video_page
	int 	10h
	int 	20h
maybe_not_text_mode:
	mov 	bl, 70h
	cmp 	al, 07h
	je  	it_is_text_mode
	mov 	bl, 1eh
	cmp 	al, 0bh
	je  	it_is_text_mode
	cmp 	al, 0ch
	je  	it_is_text_mode

	mov 	ah, 09h
	mov 	dx, offset error
	int 	21h
	ret
	error 		db 	'Работает только в текстовых режимах', 24h
	sc_width 	db 	?
	first_pos 	db 	?
	video_mode 	db 	?
	video_page 	db 	?
end start