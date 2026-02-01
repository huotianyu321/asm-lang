assume cs:codesg,ds:datasg

colorsg segment

  db 02H,24H,71h                      ;绿色，绿底红字，白底蓝字三种颜色数据

colorsg ends

datasg segment

  db 'welcome to masm!' ;字符串长度为16

datasg ends

codesg segment

start:          mov ax,0B800H                 ;显示缓冲区第一页首地址作为段地址
                mov es,ax                     ;用es:bp指向要存放数据的地址
                mov bp,06E0H                  ;第12行的第0个字节，第n行的首地址是(n-1)*160, 结尾地址是(n-1)*160+159



                mov cx,3                      ;三种颜色执行三次
                mov di,0                      ;用于索引颜色
  scolor:       mov dx,cx;                    ;保存当前外层循环次数

                mov cx,16                     ;16个字符内层循环16次
                mov si,0                      ;用于索引字符
  sline:        mov ax,datasg
                mov ds,ax
                mov al,ds:[si]
                mov es:[bp],al                ;偶数字节地址放ascii码

                mov ax,colorsg
                mov ds,ax
                mov al,ds:[di]
                mov es:[bp+1],al              ;奇数字节地址放字符属性

                inc si                        ;指向下一个字符
                add bp,2                      ;下一个字符要存放的位置往后挪2个字节
                loop sline

                mov cx,dx                     ;恢复外层cx
                inc di                        ;指向下一个字符属性
                add bp,128                    ;每完成一行，bp指向第32(从0开始)字节,增加(160-32)使bp指向下一行行首
                loop scolor

                mov ax,4c00h
                int 21h



codesg ends

end start


