;
; 将8个数据倒序
;
assume cs:code

  code segment
        dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h  
        dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ; 定义一个长度为16个字型数据的内存空间作为栈使用

start:  mov ax,cs
        mov ss,ax     ;初始化栈段寄存器
        mov sp,30H    ;初始化栈顶指针。8 + 16个字 共2 * 24个字节

        mov bx,0
        mov cx,8      ;共八个数字循环8次压入栈
s1:     push cs:[bx]
        add bx,2
        loop s1

        mov bx,0
        mov cx,8      ;共八个数字循环8次弹出栈
s2:     pop cs:[bx]
        add bx,2
        loop s2

        mov ax,4c00h
        int 21h

  code ends

end start
