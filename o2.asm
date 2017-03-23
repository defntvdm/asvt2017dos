	.model 	tiny
	.code
	org 	100h
start:
	mov 	al, 40h
	mov 	es, ax
	mov 	ax, es:[49h]
	mov 	di, es:[4eh]
	mov 	ah, 1eh
	mov 	bh, 0b8h
	cmp 	al, 4
	jl  	ok
	mov 	bh, 0b0h
	mov 	ah, 70h
	cmp 	al, 7
	je  	ok
	ret
ok:
	mov 	es, bx

	push 	di
	mov 	dx, di

	mov 	bx, 90
	add 	di, (80*2+22)*2
	mov 	cx, 2000
	cmp 	al, 1
	jg  	draw
wd40:
	mov 	cx, 1000
	mov 	bx, 10
	sub 	di, 200
	
draw:
	push 	cx
	push 	di
	mov 	al, 20h
	mov 	di, dx
	rep 	stosw
	pop 	di
	mov 	si, offset lines
	call 	draw_line
	mov 	al, 0bah
	stosw
	scasw
	mov 	al, 0b3h
	stosw
	mov 	cl, 15
	mov 	al, '0'
loop1:
	stosw
	scasw
	inc 	ax
	cmp 	al, 3ah
	jne  	chng1
	mov 	al, 'A'
	chng1:
	loop 	loop1
cont1:
	stosw
	mov 	al, 0bah
	stosw
	add 	di, bx
	call 	draw_line
	mov 	dl, '0'
	mov 	al, 0
	push 	ax
loop2:
	mov 	al, 0bah
	stosw
	mov 	al, dl
	stosw
	mov 	al, 0b3h
	stosw
	mov 	cl, 15
	pop 	ax
	loop3:
		stosw
		inc 	ax
		scasw
		loop 	loop3
	stosw
	inc 	al
	push 	ax
	inc 	dx
	mov 	al, 0bah
	stosw
	add 	di, bx
	cmp 	dl, 3ah
	jne  	chng2
	mov 	dl, 'A'
chng2:
	cmp 	dl, 'G'
	jne  	loop2

	pop 	ax
	call 	draw_line
	mov 	ah, 0
	int 	16h
	pop 	cx
	mov 	ax, 0720h
	pop  	di
	rep 	stosw
	ret

draw_line proc
	mov 	cl, 4
	loop4:
		lodsb
		stosw
		loop 	loop4
	mov 	cl, 30
	rep 	stosw
	lodsb
	stosw
	add 	di, bx
	ret
draw_line endp
lines 	db 	0c9h, 0cdh, 0d1h, 0cdh, 0bbh
	 	db 	0c7h, 0c4h, 0c5h, 0c4h, 0b6h
	 	db 	0c8h, 0cdh, 0cfh, 0cdh, 0bch
end 	start