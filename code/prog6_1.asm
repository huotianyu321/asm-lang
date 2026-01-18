;
; 将8个数据相加
;
assume cs:code

  code segment
        dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h  ;dw - define word 在代码段定义了8个字型数据，这8个字型数据会在程序加载时被加载进行内存，并且位于代码段的最前边
start:  mov bx,0
        mov ax,0

        mov cx,8 ;循环8次

s:      add ax,cs:[bx]
        add bx,2 ;移动到下一个字数据
        loop s

        mov ax,4c00h
        int 21h

  code ends

end start
