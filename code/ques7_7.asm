; 将每行的字母转换为大写
assume cs:codesg,ds:datasg

datasg segment

  db 'ibm*************'
  db 'dec*************'
  db 'dos*************'
  db 'vax*************'

datasg ends

codesg segment

start:  mov ax,datasg
        mov ds,ax
        mov bx,0

        mov cx,4
souter: mov dx,cx                     ;内外层公用cx, 在进入内层前保存cx的值

        mov cx,3
        mov si,0
sinner: mov al,[bx+si]
        and al,11011111B
        mov [bx+si],al
        inc si
        loop sinner

        add bx,10H
        mov cx,dx
        loop souter
      
        mov ax,4C00h
        int 21h

codesg ends

end start