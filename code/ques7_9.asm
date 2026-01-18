; 将每行前三个字母转换成大写
assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
    db '1. display******'
    db '2. brows********'
    db '3. replace******'
    db '4. modify*******'
datasg ends

codesg segment
start:  mov ax,stacksg ; 这个栈用不上呀
        mov ss,ax
        mov sp,16

        mov ax,datasg
        mov ds,ax

        mov cx,4
        mov bx,0
souter: mov dx,cx

        mov cx,3
        mov si,0
sinner: mov al,[3+bx+si]
        and al,11011111B
        mov [3+bx+si],al

        inc si
        loop sinner

        add bx,16
        mov cx,dx
        loop souter

        mov ax,4C00h
        int 21h

codesg ends

end start

