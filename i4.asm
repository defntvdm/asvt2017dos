	model 	tiny
	.code
	.386
	org 	100h
	locals
start:
	jmp 	M

timer_counter 	equ 	18643
old9 			dw 		0, 0
melodies 		dw 		offset one, offset two, offset three, offset four, offset five
one 			dw 		6087, 32
				dw 		0, 1
				dw 		6087, 32
				dw 		0, 1
				dw 		6087, 32
				dw 		0, 1
				dw 		7670, 24
				dw 		5119, 8
				dw 		6087, 32
				dw 		0, 1
				dw 		7670, 24
				dw 		5119, 8
				dw 		0, 1
				dw 		6087, 64
				dw 		0, 1
				dw  	4063, 32
				dw 		0, 1
				dw 		4063, 32
				dw 		0, 1
				dw 		4063, 32
				dw 		0, 1
				dw 		3834, 24
				dw 		5119, 8
				dw 		0, 1
				dw 		6449, 32
				dw 		0, 1
				dw 		7670, 24
				dw 		5119, 8
				dw 		0, 1
				dw 		6087, 64
				dw 		0, 1
				dw 		3043, 32
				dw 		0, 1
				dw 		6087, 24
				dw 		0, 1
				dw 		6087, 8
				dw 		3043, 32
				dw		0, 1
				dw 		3224, 24
				dw	 	3416, 8
				dw 		0, 1
				dw 		3619, 8
				dw 		3834, 8
				dw 		3618, 16
				dw 		0, 16
				dw 		5746, 16
				dw 		0, 1
				dw 		4304, 32
				dw 		0, 1
				dw		4560, 24
				dw 		4831, 8
				dw 		0, 1
				dw 		5119, 8
				dw 		5423, 8
				dw 		5119, 16
				dw 		0, 16
				dw 		7670, 16
				dw 		0, 1
				dw 		6449, 32
				dw 		0, 1
				dw	 	7670, 24
				dw 		5119, 8
				dw 		6087, 32
				dw 		0, 1
				dw 		7670, 24
				dw 		5119, 8
				dw 		0, 1
				dw 		6087, 64
				dw 		0ffffh

two 			dw 		4560, 20
				dw 		0, 1
				dw 		4560, 20
				dw	 	0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		5423, 20
				dw 		0, 1
				dw 		5423, 20
				dw 		0, 1
				dw 		5423, 20
				dw 		0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 1
				dw 		4560, 20
				dw	 	0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		5423, 40
				dw 		0, 1
				dw 		5423, 40
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		6449, 20
				dw 		0, 1
				dw 		6449, 20
				dw 		0, 1
				dw 		7239, 20
				dw 		0, 1
				dw 		7239, 20
				dw 		0, 1
				dw 		7239, 20
				dw 		0, 1
				dw 		6449, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		6449, 20
				dw 		0, 1
				dw 		6449, 20
				dw 		0, 1
				dw 		7239, 40
				dw 		0, 1
				dw 		7239, 40
				dw 		0ffffh

three 			dw	 	6087, 20
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 40
				dw 		0, 1
				dw	 	6087, 20
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 40
				dw 		0, 1
				dw	 	6087, 20
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		7670, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5119, 20
				dw 		0, 1
				dw 		4063, 40
				dw 		0, 1
				dw 		4560, 40
				dw	 	0, 1
				dw 		4831, 40
				dw 		0, 80
				dw 		5119, 20
				dw 		0, 1
				dw 		4831, 20
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		5119, 20
				dw 		0, 1
				dw 		4560, 40
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5423, 20
				dw 		0, 1
				dw 		5119, 20
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		5119, 40
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		8126, 20
				dw 		0, 1
				dw 		6833, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		4064, 40
				dw 		0, 1
				dw 		4560, 40
				dw 		0, 1
				dw 		6087, 40
				dw 		0, 120
				dw 		4560, 40
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 80
				dw 		5119, 40
				dw 		0, 1
				dw 		5119, 20
				dw 		0, 1
				dw 		5119, 20
				dw 		0, 80
				dw 		5746, 40
				dw 		0, 1
				dw 		6087, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		4064, 40
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 1
				dw 		4064, 20
				dw 		0, 1
				dw 		4560, 40
				dw 		4831, 40
				dw 		0, 80
				dw 		4560, 40
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 1
				dw 		4560, 20
				dw 		0, 80
				dw 		5119, 40
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 1
				dw 		5746, 20
				dw 		0, 80
				dw 		6087, 80
				dw 		0, 1
				dw 		5746, 40
				dw 		0, 1
				dw 		6087, 40
				dw 		0, 1
				dw 		9121, 80
				dw 		0ffffh
four 			dw 		0ffffh
five 			dw 		0ffffh
new_song 		db 		0
song_num 		db 		0
msg 			db 		'Space - остановка', 13, 10
				db 		'Esc - остановка и выход', 13, 10
				db 		'1 - Имперский марш', 13, 10
				db 		'2 - Во садули в огороде', 13, 10
				db 		'3 - Ландыши', 13, 10, 24h
M:
	mov 	ah, 09h
	mov 	dx, offset msg
	int 	21h

	mov al, 34h
	out 43h, al
	mov al, timer_counter - (timer_counter / 256) * 256
	out 40h, al
	mov al, timer_counter / 256
	out 40h, al
	
	mov 	ax, 3509h
	int 	21h
	mov 	word ptr cs:[offset old9], es
	mov 	word ptr cs:[offset old9 + 2], bx
	mov 	ax, 2509h
	mov 	dx, offset int9hhandler
	int 	21h
	mov 	ax, cs
	mov 	ds, ax
	xor 	ax, ax
	mov 	es, ax
main:
	in 		al, 61h
	and 	al, 0fdh
	out 	61h, al
	cmp 	byte ptr cs:[offset new_song], 0
	je 		main
	mov 	byte ptr cs:[offset new_song], 0
	xor 	bx, bx
	mov 	bl, byte ptr cs:[offset song_num]
	shl 	bx, 1
	add 	bx, offset melodies
	mov 	si, cs:bx
	;mov 	al, es:46ch
	;add 	al, 10
	;llloop:
	;	cmp 	al, byte ptr es:46ch
	;	jne 	llloop
	call 	make_music
	jmp 	main
	ret

make_music proc
	in 		al, 61h
	and 	al, 0fdh
	out 	61h, al
	mov 	al, 0b6h
	out 	43h, al
	lodsw
	cmp 	ax, 0ffffh
	jne 	@@1
	ret
@@1:
	cmp 	ax, 0
	je 		@@3
	out 	42h, al
	xchg 	ah, al
	out 	42h, al
	in 		al, 61h
	or 		al, 3
	out 	61h, al
@@3:
	lodsw
	mov 	bl, es:46ch
	add 	al, bl
lloop:
	cmp 	byte ptr cs:[offset song_num], 10
	jne 	@@4
	ret
@@4:
	cmp 	byte ptr cs:[offset new_song], 1
	jne 	@@2
	ret
@@2:
	cmp 	al, es:46ch
	jne 	lloop
	cmp 	byte ptr cs:[offset new_song], 1
	jne 	make_music
	ret
make_music endp

int9hhandler proc
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
	and 	al, 7fh
	cmp 	al, 39h
	je 		stop_play
	cmp 	al, 6
	jg 		ooops
	cmp 	al, 1
	je 		exit
	dec 	ax
	dec 	ax
	mov 	cs:[offset song_num], al
	mov 	byte ptr cs:[offset new_song], 1
	pop 	ax
	iret
ooops:
	mov 	byte ptr cs:[offset new_song], 0
	pop 	ax
	iret
stop_play:
	mov 	byte ptr cs:[offset song_num], 10
	pop 	ax
	iret
exit:
	mov 	byte ptr cs:[offset new_song], 0
	in 		al, 61h
	and 	al, 0fdh
	out 	61h, al
	mov 	ds, word ptr cs:[offset old9]
	mov 	dx, word ptr cs:[offset old9 + 2]
	mov 	ax, 2509h
	int 	21h
	int 	20h
int9hhandler endp
end start
