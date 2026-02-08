;将data段的数据写入table段

assume cs:codesg

data segment 
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上表示21年每年的年份

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上表示21年每年的总收入

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上表示21年每年的员工总人数
data ends

table segment
  db 21 dup ('year summ ne ?? ')
  ; 开辟21*(4+1+4+1+2+1+2+1)大小的内存
  ; 其中year占位的4个字节用于存放年份;
  ; summ占为的4个字节用于存放当年总收入
  ; ne 占位的两个字节用于存放当年员工人数
  ; ?? 占位的两个字节用于存放平均收入(取整)
  ; 中间穿插的1字节存放空格
table ends

codesg segment

start:    mov ax,data
          mov ds,ax                       
          mov ax,table
          mov ss,ax                       ;!!!AI建议，即使bp默认使用ss段寄存器，但也推荐换成es段寄存器

          mov bx,0                        ;用bx索引data段的年份和收入，因为都是4字节，所以同一组数据间相差84字节
          mov si,0                        
          add si,168                      ;用si索引data段的员工总人数
          mov bp,0                        ;用bp索引table段，bp默认的段寄存器是ss

          mov cx,21                       ;21年，循环21次

s:        mov ax,[bx]                     ;年份的前两个字节
          mov [bp].0h,ax
          mov ax,[bx+2]                   ;年份的后两个字节
          mov [bp].02h,ax
          mov byte ptr [bp].04h, ' '      ;空格

          mov ax,ds:[si]                  ;员工人数
          mov [bp].0ah,ax
          mov byte ptr [bp].0ch, ' '      ;空格

                                          ;最后再使用ax存放被除数
          mov ax,[bx+84]                  ;年收入的前两个字节(低位)
          mov [bp].05h,ax 
          mov dx,[bx+86]                  ;年收入的后两个字节(高位)
          mov [bp].07h,dx
          mov byte ptr [bp].09h, ' '      ;空格

          div word ptr ds:[si];           ;已准备好dx,ax中的被除数,除以员工人数
          mov [bp].0dh,ax
          mov byte ptr [bp].0fh, ' '      ;空格

          add bx,04h
          add si,02h
          add bp,10h

          loop s

          mov ax,4c00h
          int 21h

codesg ends

end start


