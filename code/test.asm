assume cs:codesg

data segment
 dd 12345678H
data ends

codesg segment

  start:  mov ax,data
          mov ds,ax
          mov bx,0
          mov [ bx ],bx
          mov [ bx+2 ],cs
          

          jmp dword ptr ds:[0]

codesg ends

end start
 