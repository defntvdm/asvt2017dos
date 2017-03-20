	.model 	tiny
	.code
	org 	100h
start:
	mov 	ax, 4e56h
	int 	2fh
	ret
end 	start