.model tiny

.code
    org 100h
program:
    mov si, 81h
    xor dx, dx
    xor cx, cx
read_args_loop:
    lodsb
    mov cl, al
    lea bx, t1
    xlat
    cmp al, 2
    je end_of_args
    cmp al, 1
    jne read_args_loop
    sub cl, 48
    cmp cl, 9
    jle num
    sub cl, 7
num:
    push cx
    inc dx
    jmp read_args_loop
end_of_args:
    cmp dx, 2
    jne bad_args
    pop bx
    pop ax
    push bx
    xor ah, ah
    int 10h
    pop ax
    mov ah, 05h
    int 10h
    mov ah, 0fh
    int 10h
    add al, 48
    add bh, 48
    mov m_de, al
    mov p_ge, bh
    lea dx, msg_good
    mov ah, 09h
    int 21h
    ret
bad_args:
    mov cx, dx
    inc cx
    lea dx, msg_bad
    mov ah, 09h
    int 21h
stack_clear:
    loop lala
    ret

lala:
    pop ax
    jmp stack_clear

    t1 db 13 dup(0), 2, 34 dup(0), 10 dup(1), 7 dup(0), 6 dup(1), 186 dup(0)
    msg_bad db "only two numbers$"
    msg_good db "mode: "
    m_de     db ?
             db 0dh, 0ah
             db "page: "
    p_ge     db ?
             db "$"

end program
