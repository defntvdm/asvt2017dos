	.model	tiny
	.code
	org 100h
start:
	jmp init
Int_2fh_proc proc
	cmp ax, 4E56h
	je Ok
	jmp dword ptr cs:[Int_2fh_vect]
	Ok:
		push ds
		push dx
		push cs
		pop ds
		mov	ah, 09h
		mov dx,offset My_string
		pushf
		int	21h
		call dword ptr cs:[Int_2fh_vect]
		pop dx
		pop ds
		iret
		Int_2fh_vect dd ?
		My_string db 'It is mine caller!$'
Int_2fh_proc endp
init:
	mov ax,352fh
	int 21h
	mov word ptr Int_2fh_vect,bx
	mov word ptr Int_2fh_vect+2,es
	mov ax, 252fh
	mov dx, offset Int_2fh_proc
	int 21h
	mov dx,offset Init
	int 27h
end start
