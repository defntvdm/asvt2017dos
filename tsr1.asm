	.model	tiny
	.code
	org	100h
start:
	jmp	work
tsr:
	int	21h
work:
	push	es
	mov	es, cs:2ch
	mov	ah, 49h
	int	21h
	mov	bx, 1
	mov	ah, 48h
	int	21h
	mov	es, ax
	lea si, s
	xor	di, di
	mov	cx, 10
	rep	movsb
	mov	cs:2ch, ax
	pop	es
	mov	ax, offset work
	mov	dl, 16
	div	dl
	inc	al
	mov ah, 0
	mov	dx, ax
	mov	ax, 3100h
	jmp	tsr
	s 	db	'$', 0, 0, 1, 0, 'voot', 0
end start
