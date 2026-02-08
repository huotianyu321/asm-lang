;子程序描述
;名称:showstr
;功能:在指定的位置,用指定的颜色,显示一个用0结束的宁符串
;参数:(dh)=行号(取值范围0~24),(dl)=列号(取值范围0~79),
;(cl)=颜色,ds:si指向字符串的首地址
;返回:无

assume cs:code

data segment
  db 'Welcome to masm!',0
data ends

code segment

start:        mov dh,12                    ;指定行号
              mov dl,40                    ;列号
              mov cl,11001010B             ;指定颜色

              mov ax,data
              mov ds,ax
              mov si,0

              call show_str

              mov ax,4c00h
              int 21h


show_str:       push ax
                push bx
                push cx
                push es
                push si

                mov ax,0B800H
                mov es,ax                     ;初始化段寄存器

                ;用bx记录当前字符所要存放的内存地址的偏移地址
                mov al,160                    ;将被乘数放入al(8位相乘,默认在al中)
                mov ah,dh
                dec ah
                mul ah                        ;计算当前行的首地址(n-1)*160 得到的计算结果在ax中

                mov bx,0
                mov bl,dl
                add bx,bx                     ;每个字符占两个字节,偏移量是列数的2倍
                add bx,ax                    ;列偏移量 + 行首偏移地址

                mov ax,0                      ;将颜色放入ax中
                mov al,cl

s:              mov cx,ds:[si]               ;cx存放当前字符
                jcxz finish                  ;如果是0则结束

                mov es:[bx],cx
                mov es:[bx+1],ax
                add bx,2
                add si,1

                jmp s


finish:         pop si
                pop es
                pop cx
                pop bx
                pop ax
                ret

code ends

end start

