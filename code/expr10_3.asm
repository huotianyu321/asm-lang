;名称:dtoc
;功能:将word型数据转变为表示十进制数的字符串,字符串以0为结尾符。
;参数:(ax)-word型数据
;ds:si指向字符串的首地址
;返回:无

assume cs:code

data segment
  db 10 dup(0)                                        ;前提条件word型数组最多5位(65535),不会覆盖0
data ends


code segment

start:              mov ax,52666                      ;要打印的数字
                    mov bx,data
                    mov ds,bx
                    mov si,0

                    call dtoc

                    mov dh,8                          ;数字字符串显示的行
                    mov dl,3                          ;数字字符串显示的列
                    mov cl,2                          ;颜色

                    call show_str

                    mov ax,4c00h
                    int 21h


;如果用8位寄存器的除法,12666 / 10后商会溢出(商不能大于255)。因此采用16位寄存器除法(商最大可以是65535)
dtoc:               push ax                           ;16位除法的商
                    push bx                           ;存放除数10
                    push cx                           
                    push dx                           ;16位除法的余数
                    push si
              
                    mov bx,10                         ;bx作为除数
dtoc_step:          mov dx,0                          ;清空高8位
                    div bx                            ;计算结果中dx是余数(0-9)，ax是商

                    add dl,30H                        ;得到数字的ascii码
                    mov ds:[si],dl                    ;数字的ascii码放入内存
                    inc si                

                    mov cx,ax                         ;判断商是否为0，如果为0则结束
                    jcxz dtoc_done
                    jmp dtoc_step

dtoc_done:          pop si
                    pop dx
                    pop cx                 
                    pop bx
                    pop ax
                    call reverse_str
                    ret

;反转字符串
reverse_str:        push ax                           ;用ax记录字符串长度
                    push bx                           ;存放除数2
                    push cx                           ;记录要执行交换操作的循环次数
                    push dx       
                    push di                           ;用di和si交换字符
                    push si

                    mov ax,0
                    mov cx,0
call_len_step:      mov cl,ds:[si]
                    jcxz call_len_end
                    inc ax
                    inc si
                    jmp call_len_step
                    
call_len_end:       pop si                            ;恢复si的值
                    push si                       

                    push ax                           ;暂存字符串长度
                    mov dx,0                          ;清空被除数高8位
                    mov bx,2        
                    div bx                            ;(ax)*2+(dx)等于字符串的长度
                    mov cx,ax                         ;cx记录循环次数
                    pop ax                            ;恢复存放字符串长度

                    mov di,ax       
                    dec di                            ;初始化字符串末尾索引
swap_step:          jcxz reverse_str_done       
                    mov dl,ds:[si]
                    mov dh,ds:[di]
                    mov ds:[si],dh
                    mov ds:[di],dl
                    inc si
                    dec di
                    dec cx
                    jmp swap_step

reverse_str_done:   pop si
                    pop di
                    pop dx
                    pop cx
                    pop bx
                    pop ax
                    ret


show_str:           push ax                         ;用ax记录颜色属性
                    push bx                         ;用bx记录当前字符所要存放的内存地址的偏移地址
                    push cx                         ;用cx存放当前字符
                    push es
                    push si

                    mov ax,0B800H
                    mov es,ax                       ;初始化段寄存器

                    mov al,160                      ;将被乘数放入al(8位相乘,默认在al中)
                    mov ah,dh
                    dec ah
                    mul ah                          ;计算当前行的首地址(n-1)*160 得到的计算结果在ax中

                    mov bx,0
                    mov bl,dl
                    add bx,bx                       ;每个字符占两个字节,偏移量是列数的2倍
                    add bx,ax                       ;列偏移量 + 行首偏移地址

                    mov ax,0                        ;将颜色放入ax中
                    mov al,cl

show_str_step:      mov cx,ds:[si]                  ;cx存放当前字符
                    jcxz show_str_done              ;如果是0则结束

                    mov es:[bx],cx
                    mov es:[bx+1],ax
                    add bx,2
                    add si,1

                    jmp show_str_step


show_str_done:      pop si
                    pop es
                    pop cx
                    pop bx
                    pop ax
                    ret

code ends

end start