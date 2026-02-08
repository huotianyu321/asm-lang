; 编写代码，将a段和b段的数据依次相加，将结果存在c段中
assume cs:code

a segment
  db 1,2,3,4,5,6,7,8
a ends

b segment
  db 1,2,3,4,5,6,7,8
b ends

c segment
  db 0,0,0,0,0,0,0,0
c ends

code segment
start: mov bx,0
       mov cx,8

s:     mov dl,0

       mov ax,a
       mov ds,ax
       add dl,[bx]
       
       mov ax,b
       mov ds,ax
       add dl,[bx]

       mov ax,c
       mov ds,ax
       mov [bx],dl

       inc bx
       loop s
       

       mov ax,4c00h
       int 21h

code ends

end start
